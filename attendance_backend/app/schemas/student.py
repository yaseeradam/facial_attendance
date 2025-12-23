"""Student request/response schemas"""
from pydantic import BaseModel

class StudentCreate(BaseModel):
    student_id: str
    name: str
    class_name: str

class StudentResponse(BaseModel):
    id: int
    student_id: str
    name: str
    class_name: str
    
    class Config:
        from_attributes = True