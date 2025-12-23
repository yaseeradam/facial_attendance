"""File handling utilities"""
import os
import json
import pickle

def save_embedding(student_id, embedding, embeddings_dir="data/embeddings"):
    """Save face embedding to file"""
    os.makedirs(embeddings_dir, exist_ok=True)
    filepath = os.path.join(embeddings_dir, f"{student_id}.pkl")
    with open(filepath, 'wb') as f:
        pickle.dump(embedding, f)

def load_embedding(student_id, embeddings_dir="data/embeddings"):
    """Load face embedding from file"""
    filepath = os.path.join(embeddings_dir, f"{student_id}.pkl")
    if os.path.exists(filepath):
        with open(filepath, 'rb') as f:
            return pickle.load(f)
    return None