"""App settings and configuration"""
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Database
    database_url: str = "sqlite:///./attendance.db"
    
    # Security
    secret_key: str = "your-super-secret-key-change-in-production"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Face Recognition
    face_similarity_threshold: float = 0.6
    insightface_model_name: str = "buffalo_l"
    
    # App
    app_name: str = "Face Recognition Attendance System"
    debug: bool = False
    
    # Cloudinary (Optional - for persistent storage in free tier)
    # If not provided, will default to local storage (which is ephemeral on Render free tier)
    cloudinary_cloud_name: str = ""
    cloudinary_api_key: str = ""
    cloudinary_api_secret: str = ""
    
    class Config:
        env_file = ".env"

settings = Settings()