"""Face registration and verification endpoints"""
from fastapi import APIRouter, UploadFile, File

router = APIRouter(prefix="/face", tags=["face"])

@router.post("/register")
async def register_face(file: UploadFile = File(...)):
    return {"message": "Face registered"}

@router.post("/verify")
async def verify_face(file: UploadFile = File(...)):
    return {"verified": True, "student_id": "123"}