"""Student CRUD and sync endpoints"""
from fastapi import APIRouter

router = APIRouter(prefix="/students", tags=["students"])

@router.get("/")
async def get_students():
    return {"students": []}

@router.post("/")
async def create_student():
    return {"message": "Student created"}