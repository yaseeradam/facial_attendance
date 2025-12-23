"""Teacher management endpoints"""
from fastapi import APIRouter

router = APIRouter(prefix="/teachers", tags=["teachers"])

@router.get("/")
async def get_teachers():
    return {"teachers": []}