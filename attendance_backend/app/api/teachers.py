"""Teacher management endpoints"""
from typing import List
from fastapi import APIRouter, HTTPException, status, Depends
from sqlalchemy.orm import Session
from ..core.security import require_admin
from ..db.base import get_db
from ..services.teacher_service import TeacherService
from ..schemas.teacher import TeacherCreate, TeacherResponse, TeacherUpdate

router = APIRouter(prefix="/teachers", tags=["teachers"])
teacher_service = TeacherService()

@router.post("/", response_model=TeacherResponse)
async def create_teacher(
    teacher_data: TeacherCreate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_admin)
):
    """Create a new teacher (Admin only)"""
    try:
        teacher = await teacher_service.create_teacher(teacher_data, db)
        return TeacherResponse.model_validate(teacher)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/", response_model=List[TeacherResponse])
async def get_teachers(
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_admin)
):
    """Get all teachers (Admin only)"""
    teachers = await teacher_service.get_teachers(db)
    return [TeacherResponse.model_validate(teacher) for teacher in teachers]

@router.get("/{teacher_id}", response_model=TeacherResponse)
async def get_teacher(
    teacher_id: int,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_admin)
):
    """Get teacher by ID (Admin only)"""
    teacher = await teacher_service.get_teacher_by_id(teacher_id, db)
    if not teacher:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Teacher not found")
    return TeacherResponse.model_validate(teacher)

@router.put("/{teacher_id}", response_model=TeacherResponse)
async def update_teacher(
    teacher_id: int,
    teacher_data: dict,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_admin)
):
    """Update teacher (Admin only)"""
    try:
        teacher = await teacher_service.update_teacher(teacher_id, teacher_data, db)
        if not teacher:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Teacher not found")
        return TeacherResponse.model_validate(teacher)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.delete("/{teacher_id}")
async def delete_teacher(
    teacher_id: int,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_admin)
):
    """Delete teacher (Admin only)"""
    try:
        success = await teacher_service.delete_teacher(teacher_id, db)
        if not success:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Teacher not found")
        return {"message": "Teacher deleted successfully"}
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.post("/bulk-delete")
async def bulk_delete_teachers(
    request_body: dict,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_admin)
):
    """Delete multiple teachers (Admin only)"""
    try:
        teacher_ids = request_body.get('teacher_ids', [])
        if not teacher_ids:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="No teacher IDs provided")
        
        deleted_count = await teacher_service.bulk_delete_teachers(teacher_ids, db)
        return {
            "message": f"{deleted_count} teacher(s) deleted successfully",
            "deleted_count": deleted_count
        }
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/export/csv")
async def export_teachers_csv(
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_admin)
):
    """Export all teachers to CSV (Admin only)"""
    from fastapi.responses import StreamingResponse
    import io
    import csv
    from datetime import datetime
    
    teachers = await teacher_service.get_teachers(db)
    
    # Create CSV in memory
    output = io.StringIO()
    writer = csv.writer(output)
    
    # Write header
    writer.writerow(['ID', 'Teacher ID', 'Full Name', 'Email', 'Role', 'Status', 'Created At'])
    
    # Write data
    for teacher in teachers:
        writer.writerow([
            teacher.id,
            teacher.teacher_id,
            teacher.full_name,
            teacher.email,
            teacher.role,
            getattr(teacher, 'status', 'active'),
            teacher.created_at.strftime('%Y-%m-%d %H:%M:%S') if teacher.created_at else ''
        ])
    
    # Prepare response
    output.seek(0)
    filename = f"teachers_export_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    
    return StreamingResponse(
        iter([output.getvalue()]),
        media_type="text/csv",
        headers={"Content-Disposition": f"attachment; filename={filename}"}
    )