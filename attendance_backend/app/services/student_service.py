"""Student business logic"""
from typing import List, Optional
from sqlalchemy.orm import Session
from ..db import crud, models
from ..schemas.student import StudentCreate, StudentResponse

class StudentService:
    def __init__(self):
        pass
    
    async def create_student(self, student_data: StudentCreate, db: Session) -> models.Student:
        """Create a new student"""
        # Check if student_id already exists
        existing_student = crud.get_student_by_student_id(db, student_data.student_id)
        if existing_student:
            raise ValueError("Student ID already exists")
        
        # Verify class exists
        class_obj = crud.get_class_by_id(db, student_data.class_id)
        if not class_obj:
            raise ValueError("Class not found")
        
        student_dict = student_data.model_dump()
        return crud.create_student(db, student_dict)
    
    async def get_students(self, db: Session, class_id: Optional[int] = None) -> List[models.Student]:
        """Get all students, optionally filtered by class"""
        return crud.get_students(db, class_id=class_id)
    
    async def get_student_by_id(self, student_id: int, db: Session) -> Optional[models.Student]:
        """Get student by ID"""
        return crud.get_student_by_id(db, student_id)
    
    async def get_student_by_student_id(self, student_id: str, db: Session) -> Optional[models.Student]:
        """Get student by student_id"""
        return crud.get_student_by_student_id(db, student_id)