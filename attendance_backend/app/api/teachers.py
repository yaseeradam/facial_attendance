"""Teacher management endpoints"""
from typing import List
from fastapi import APIRouter, HTTPException, status, Depends
from sqlalchemy.orm import Session
from ..core.security import require_admin
from ..db.base import get_db
from ..services.teacher_service import TeacherService
from ..schemas.teacher import TeacherCreate, TeacherResponse

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