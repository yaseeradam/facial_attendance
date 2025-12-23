"""Face recognition request/response schemas"""
from pydantic import BaseModel

class FaceRegisterResponse(BaseModel):
    success: bool
    message: str

class FaceVerifyResponse(BaseModel):
    verified: bool
    student_id: str = None
    confidence: float = None