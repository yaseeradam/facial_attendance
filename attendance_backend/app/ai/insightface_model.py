"""InsightFace model initialization"""
import insightface
import numpy as np
from ..core.config import settings

class InsightFaceModel:
    _instance = None
    _model = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(InsightFaceModel, cls).__new__(cls)
        return cls._instance
    
    def load_model(self):
        """Load InsightFace model once at startup"""
        if self._model is None:
            self._model = insightface.app.FaceAnalysis(name=settings.insightface_model_name)
            self._model.prepare(ctx_id=-1, det_size=(640, 640))
            print(f"InsightFace model {settings.insightface_model_name} loaded successfully")
    
    def get_model(self):
        """Get the loaded model instance"""
        if self._model is None:
            self.load_model()
        return self._model
    
    def detect_faces(self, image: np.ndarray):
        """Detect faces in image"""
        model = self.get_model()
        faces = model.get(image)
        return faces

# Global singleton instance
face_model = InsightFaceModel()