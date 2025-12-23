"""Face registration and verification endpoints"""
from fastapi import APIRouter, UploadFile, File, HTTPException, status, Depends, Form
from sqlalchemy.orm import Session
from ..core.security import require_teacher
from ..db.base import get_db
from ..services.face_service import FaceService
from ..services.class_service import ClassService
from ..services.attendance_service import AttendanceService
from ..schemas.face import FaceRegisterResponse, FaceVerifyResponse

router = APIRouter(prefix="/face", tags=["face"])
face_service = FaceService()
class_service = ClassService()
attendance_service = AttendanceService()

@router.post("/register", response_model=FaceRegisterResponse)
async def register_face(
    student_id: int = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Register a face for a student"""
    # Validate file type
    if not file.content_type.startswith('image/'):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="File must be an image"
        )
    
    try:
        # Read image data
        image_data = await file.read()
        
        # Register face
        success, message = await face_service.register_face(image_data, student_id, db)
        
        return FaceRegisterResponse(
            success=success,
            message=message,
            student_id=student_id if success else None
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error processing face registration: {str(e)}"
        )

@router.post("/verify", response_model=FaceVerifyResponse)
async def verify_face(
    class_id: int = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: dict = Depends(require_teacher)
):
    """Verify a face and mark attendance if recognized"""
    # Check if teacher has access to this class
    has_access = await class_service.check_teacher_access(class_id, current_user["user_id"], db)
    if not has_access:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied to this class")
    
    # Validate file type
    if not file.content_type.startswith('image/'):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="File must be an image"
        )
    
    try:
        # Read image data
        image_data = await file.read()
        
        # Verify face
        success, message, student_id, confidence_score = await face_service.verify_face(image_data, class_id, db)
        
        attendance_marked = False
        student_name = None
        
        if success and student_id:
            try:
                # Mark attendance
                await attendance_service.mark_attendance(student_id, class_id, confidence_score, db)
                attendance_marked = True
                
                # Get student name
                from ..db import crud
                student = crud.get_student_by_id(db, student_id)
                if student:
                    student_name = student.full_name
                    
            except ValueError as e:
                # Attendance already marked or other error
                if "already marked" in str(e):
                    attendance_marked = False
                    message += " (Attendance already marked today)"
        
        return FaceVerifyResponse(
            success=success,
            message=message,
            student_id=student_id,
            student_name=student_name,
            confidence_score=confidence_score,
            attendance_marked=attendance_marked
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error processing face verification: {str(e)}"
        )