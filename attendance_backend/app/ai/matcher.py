"""Compare face embeddings"""
import numpy as np

def cosine_similarity(embedding1, embedding2):
    """Calculate cosine similarity between embeddings"""
    return np.dot(embedding1, embedding2) / (np.linalg.norm(embedding1) * np.linalg.norm(embedding2))

def match_faces(embedding1, embedding2, threshold=0.6):
    """Check if two embeddings match"""
    similarity = cosine_similarity(embedding1, embedding2)
    return similarity > threshold, similarity