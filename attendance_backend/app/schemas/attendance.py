"""Attendance request/response schemas"""
from pydantic import BaseModel
from datetime import datetime

class AttendanceCreate(BaseModel):
    student_id: str
    timestamp: datetime
    status: str

class AttendanceResponse(BaseModel):
    id: int
    student_id: str
    timestamp: datetime
    status: str
    
    class Config:
        from_attributes = True