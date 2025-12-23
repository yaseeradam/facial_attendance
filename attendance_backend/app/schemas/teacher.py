"""Teacher request/response schemas"""
from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime

class TeacherCreate(BaseModel):
    teacher_id: str
    full_name: str
    email: EmailStr
    password: str
    role: Optional[str] = "teacher"

class TeacherResponse(BaseModel):
    id: int
    teacher_id: str
    full_name: str
    email: str
    role: str
    created_at: datetime
    
    class Config:
        from_attributes = True

class TeacherLogin(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str
    teacher: TeacherResponse