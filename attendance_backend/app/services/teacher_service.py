"""Teacher business logic"""
from typing import List, Optional
from sqlalchemy.orm import Session
from ..db import crud, models
from ..schemas.teacher import TeacherCreate

class TeacherService:
    def __init__(self):
        pass
    
    async def create_teacher(self, teacher_data: TeacherCreate, db: Session) -> models.Teacher:
        """Create a new teacher"""
        # Check if email already exists
        existing_teacher = crud.get_teacher_by_email(db, teacher_data.email)
        if existing_teacher:
            raise ValueError("Email already exists")
        
        teacher_dict = teacher_data.model_dump()
        return crud.create_teacher(db, teacher_dict)
    
    async def get_teachers(self, db: Session) -> List[models.Teacher]:
        """Get all teachers"""
        return crud.get_teachers(db)
    
    async def authenticate_teacher(self, email: str, password: str, db: Session) -> Optional[models.Teacher]:
        """Authenticate teacher login"""
        return crud.authenticate_teacher(db, email, password)
    
    async def get_teacher_by_id(self, teacher_id: int, db: Session) -> Optional[models.Teacher]:
        """Get teacher by ID"""
        return crud.get_teacher_by_id(db, teacher_id)