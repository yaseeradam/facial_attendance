"""Face recognition unit tests"""
import pytest
from app.ai.embedding import generate_embedding
from app.ai.matcher import match_faces, cosine_similarity
from app.ai.validator import validate_single_face

def test_cosine_similarity():
    """Test cosine similarity calculation"""
    import numpy as np
    vec1 = np.array([1, 0, 0])
    vec2 = np.array([1, 0, 0])
    similarity = cosine_similarity(vec1, vec2)
    assert similarity == 1.0

def test_match_faces():
    """Test face matching logic"""
    import numpy as np
    embedding1 = np.random.rand(512)
    embedding2 = embedding1.copy()
    
    is_match, similarity = match_faces(embedding1, embedding2)
    assert is_match == True
    assert similarity > 0.9