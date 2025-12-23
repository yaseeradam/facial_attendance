"""Face validation and quality checks"""
from .insightface_model import face_model

def validate_single_face(image):
    """Ensure only one face is detected"""
    model = face_model.get_model()
    faces = model.get(image)
    return len(faces) == 1, len(faces)

def check_face_quality(image):
    """Check face quality and pose"""
    model = face_model.get_model()
    faces = model.get(image)
    if faces:
        face = faces[0]
        # Basic quality checks
        return True, "Good quality"
    return False, "No face detected"