"""Student request/response schemas"""
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class StudentCreate(BaseModel):
    student_id: str
    full_name: str
    class_id: int

class StudentResponse(BaseModel):
    id: int
    student_id: str
    full_name: str
    class_id: int
    face_enrolled: bool
    created_at: datetime
    class_obj: Optional[dict] = None  # Will be populated with class info
    
    class Config:
        from_attributes = True

class StudentWithClass(StudentResponse):
    class_name: Optional[str] = None