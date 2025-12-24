"""Student CRUD and management endpoints"""
from typing import List, Optional
from fastapi import APIRouter, HTTPException, status, Depends, Query
from sqlalchemy.orm import Session
from ..core.security import require_teacher
from ..db.base import get_db
from ..services.student_service import StudentService
from ..services.class_service import ClassService
from ..schemas.student import StudentCreate, StudentUpdate, StudentResponse, StudentWithClass

router = APIRouter(prefix="/students", tags=["students"])
student_service = StudentService()
class_service = ClassService()

@router.post("/", response_model=StudentResponse)
async def create_student(
    student_data: StudentCreate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Create a new student"""
    # Check if teacher has access to the class
    has_access = await class_service.check_teacher_access(student_data.class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this class")
    
    try:
        student = await student_service.create_student(student_data, db)
        return StudentResponse.model_validate(student)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/", response_model=List[StudentWithClass])
async def get_students(
    class_id: Optional[int] = Query(None, description="Filter by class ID"),
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Get students, optionally filtered by class"""
    # If class_id is specified, check access
    if class_id:
        has_access = await class_service.check_teacher_access(class_id, current_user["user_id"], db)
        if not has_access:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this class")
    
    # For non-admin teachers, only show students from their classes
    if current_user["role"] != "admin" and not class_id:
        # Get teacher's classes and filter students
        teacher_classes = await class_service.get_classes(db, teacher_id=current_user["user_id"])
        class_ids = [cls.id for cls in teacher_classes]
        
        all_students = []
        for cls_id in class_ids:
            students = await student_service.get_students(db, class_id=cls_id)
            all_students.extend(students)
    else:
        all_students = await student_service.get_students(db, class_id=class_id)
    
    result = []
    for student in all_students:
        student_dict = StudentWithClass.model_validate(student).model_dump()
        if student.class_obj:
            student_dict["class_name"] = student.class_obj.class_name
        result.append(student_dict)
    
    return result

@router.get("/{student_id}", response_model=StudentWithClass)
async def get_student_by_id(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Get student by ID"""
    student = await student_service.get_student_by_id(student_id, db)
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    
    # Check if teacher has access to this student's class
    has_access = await class_service.check_teacher_access(student.class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this student")
    
    student_dict = StudentWithClass.model_validate(student).model_dump()
    if student.class_obj:
        student_dict["class_name"] = student.class_obj.class_name
    
    return student_dict

@router.put("/{student_id}", response_model=StudentResponse)
async def update_student(
    student_id: int,
    student_data: StudentUpdate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Update a student"""
    student = await student_service.get_student_by_id(student_id, db)
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    
    # Check if teacher has access to this student's class
    has_access = await class_service.check_teacher_access(student.class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this student")
    
    # If changing class, check access to new class
    if student_data.class_id and student_data.class_id != student.class_id:
        has_new_access = await class_service.check_teacher_access(student_data.class_id, current_user["user_id"], db)
        if not has_new_access:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to target class")
    
    try:
        updated_student = await student_service.update_student(student_id, student_data, db)
        return StudentResponse.model_validate(updated_student)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.delete("/{student_id}")
async def delete_student(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Delete a student"""
    student = await student_service.get_student_by_id(student_id, db)
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    
    # Check if teacher has access to this student's class
    has_access = await class_service.check_teacher_access(student.class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this student")
    
    try:
        await student_service.delete_student(student_id, db)
        return {"message": "Student deleted successfully"}
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))