"""Attendance marking and fetching endpoints"""
from typing import List, Optional
from datetime import date
from fastapi import APIRouter, HTTPException, status, Depends, Query
from sqlalchemy.orm import Session
from ..core.security import require_teacher
from ..db.base import get_db
from ..services.attendance_service import AttendanceService
from ..services.class_service import ClassService
from ..schemas.attendance import AttendanceResponse, AttendanceWithDetails, AttendanceSummary

router = APIRouter(prefix="/attendance", tags=["attendance"])
attendance_service = AttendanceService()
class_service = ClassService()

@router.post("/mark", response_model=AttendanceResponse)
async def mark_attendance(
    student_id: int,
    class_id: int,
    confidence_score: float,
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Mark attendance for a student (Internal use - called by face verification)"""
    # Check if teacher has access to this class
    has_access = await class_service.check_teacher_access(class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this class")
    
    try:
        attendance = await attendance_service.mark_attendance(student_id, class_id, confidence_score, db)
        return AttendanceResponse.model_validate(attendance)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/today", response_model=List[AttendanceWithDetails])
async def get_attendance_today(
    class_id: Optional[int] = Query(None, description="Filter by class ID"),
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Get today's attendance records"""
    # Check access if class_id is specified
    if class_id:
        has_access = await class_service.check_teacher_access(class_id, current_user["user_id"], db)
        if not has_access:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this class")
    
    # For non-admin teachers, filter by their classes
    if current_user["role"] != "admin" and not class_id:
        teacher_classes = await class_service.get_classes(db, teacher_id=current_user["user_id"])
        all_attendance = []
        for cls in teacher_classes:
            attendance_records = await attendance_service.get_attendance_today(db, class_id=cls.id)
            all_attendance.extend(attendance_records)
    else:
        all_attendance = await attendance_service.get_attendance_today(db, class_id=class_id)
    
    result = []
    for attendance in all_attendance:
        attendance_dict = AttendanceWithDetails.model_validate(attendance).model_dump()
        if attendance.student:
            attendance_dict["student_name"] = attendance.student.full_name
            attendance_dict["student_student_id"] = attendance.student.student_id
        if attendance.class_obj:
            attendance_dict["class_name"] = attendance.class_obj.class_name
        result.append(attendance_dict)
    
    return result

@router.get("/by-class/{class_id}", response_model=List[AttendanceWithDetails])
async def get_attendance_by_class(
    class_id: int,
    date_filter: Optional[date] = Query(None, description="Filter by date (YYYY-MM-DD)"),
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Get attendance records for a specific class"""
    # Check if teacher has access to this class
    has_access = await class_service.check_teacher_access(class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this class")
    
    attendance_records = await attendance_service.get_attendance_by_class(class_id, db, date_filter=date_filter)
    
    result = []
    for attendance in attendance_records:
        attendance_dict = AttendanceWithDetails.model_validate(attendance).model_dump()
        if attendance.student:
            attendance_dict["student_name"] = attendance.student.full_name
            attendance_dict["student_student_id"] = attendance.student.student_id
        if attendance.class_obj:
            attendance_dict["class_name"] = attendance.class_obj.class_name
        result.append(attendance_dict)
    
    return result

@router.get("/summary/{class_id}", response_model=AttendanceSummary)
async def get_attendance_summary(
    class_id: int,
    date_filter: Optional[date] = Query(None, description="Filter by date (YYYY-MM-DD)"),
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Get attendance summary for a class"""
    # Check if teacher has access to this class
    has_access = await class_service.check_teacher_access(class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this class")
    
    summary = await attendance_service.get_attendance_summary(class_id, db, date_filter=date_filter)
    return AttendanceSummary(**summary)