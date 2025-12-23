"""App settings and configuration"""
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str = "sqlite:///./attendance.db"
    secret_key: str = "your-secret-key"
    
    class Config:
        env_file = ".env"

settings = Settings()