"""Generate face embeddings"""
import numpy as np
import json
from typing import Optional, Tuple
from .insightface_model import face_model

def generate_embedding(image: np.ndarray) -> Tuple[Optional[str], str]:
    """Generate face embedding from image
    
    Returns:
        Tuple[embedding_json, message]: (embedding as JSON string, status message)
    """
    try:
        faces = face_model.detect_faces(image)
        
        if len(faces) == 0:
            return None, "No face detected in image"
        
        if len(faces) > 1:
            return None, "Multiple faces detected. Please ensure only one face is visible"
        
        # Get the first (and only) face
        face = faces[0]
        embedding = face.embedding
        
        # Convert numpy array to JSON string for storage
        embedding_json = json.dumps(embedding.tolist())
        
        return embedding_json, "Face embedding generated successfully"
        
    except Exception as e:
        return None, f"Error generating embedding: {str(e)}"

def embedding_from_json(embedding_json: str) -> np.ndarray:
    """Convert JSON string back to numpy array"""
    embedding_list = json.loads(embedding_json)
    return np.array(embedding_list, dtype=np.float32)