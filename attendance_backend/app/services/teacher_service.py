"""Teacher business logic"""
from typing import List, Optional
from sqlalchemy.orm import Session
from ..db import crud, models
from ..schemas.teacher import TeacherCreate, TeacherUpdate

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
    
    async def update_teacher(self, teacher_id: int, update_data: dict, db: Session) -> Optional[models.Teacher]:
        """Update teacher information"""
        teacher = crud.get_teacher_by_id(db, teacher_id)
        if not teacher:
            raise ValueError("Teacher not found")
        
        # Check if email is being updated and if it already exists
        if 'email' in update_data and update_data['email'] != teacher.email:
            existing_teacher = crud.get_teacher_by_email(db, update_data['email'])
            if existing_teacher:
                raise ValueError("Email already exists")
        
        # Remove None values
        update_data = {k: v for k, v in update_data.items() if v is not None}
        
        return crud.update_teacher(db, teacher_id, update_data)
    
    async def delete_teacher(self, teacher_id: int, db: Session) -> bool:
        """Delete a teacher"""
        teacher = crud.get_teacher_by_id(db, teacher_id)
        if not teacher:
            raise ValueError("Teacher not found")
        
        return crud.delete_teacher(db, teacher_id)
    
    async def bulk_delete_teachers(self, teacher_ids: List[int], db: Session) -> int:
        """Delete multiple teachers"""
        deleted_count = 0
        for teacher_id in teacher_ids:
            try:
                if crud.delete_teacher(db, teacher_id):
                    deleted_count += 1
            except Exception:
                # Continue deleting other teachers even if one fails
                continue
        return deleted_count