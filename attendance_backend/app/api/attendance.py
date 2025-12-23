"""Attendance marking and fetching endpoints"""
from fastapi import APIRouter

router = APIRouter(prefix="/attendance", tags=["attendance"])

@router.post("/mark")
async def mark_attendance():
    return {"message": "Attendance marked"}

@router.get("/")
async def get_attendance():
    return {"attendance": []}