"""Teacher request/response schemas"""
from pydantic import BaseModel

class TeacherResponse(BaseModel):
    id: int
    teacher_id: str
    name: str
    email: str
    
    class Config:
        from_attributes = True