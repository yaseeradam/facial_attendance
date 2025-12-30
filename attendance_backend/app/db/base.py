"""Database connection setup"""
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
from ..core.config import settings

# Determine if using SQLite or PostgreSQL
database_url = settings.database_url

# Handle Render's PostgreSQL URL format (postgres:// vs postgresql://)
if database_url.startswith("postgres://"):
    database_url = database_url.replace("postgres://", "postgresql://", 1)

# Configure engine based on database type
if database_url.startswith("sqlite"):
    # SQLite configuration (for local development)
    engine = create_engine(
        database_url,
        connect_args={"check_same_thread": False},
        poolclass=StaticPool
    )
else:
    # PostgreSQL configuration (for production/Render)
    engine = create_engine(
        database_url,
        pool_pre_ping=True,  # Verify connections before use
        pool_size=5,
        max_overflow=10
    )

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()