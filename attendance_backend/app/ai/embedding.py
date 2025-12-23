"""Generate face embeddings"""
import numpy as np
from .insightface_model import face_model

def generate_embedding(image):
    """Generate face embedding from image"""
    model = face_model.get_model()
    faces = model.get(image)
    if faces:
        return faces[0].embedding
    return None