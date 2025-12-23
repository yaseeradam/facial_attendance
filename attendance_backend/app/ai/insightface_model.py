"""InsightFace model initialization"""
import insightface

class InsightFaceModel:
    def __init__(self):
        self.model = None
    
    def load_model(self):
        # Load InsightFace model once
        self.model = insightface.app.FaceAnalysis()
        self.model.prepare(ctx_id=0, det_size=(640, 640))
    
    def get_model(self):
        if self.model is None:
            self.load_model()
        return self.model

# Global instance
face_model = InsightFaceModel()