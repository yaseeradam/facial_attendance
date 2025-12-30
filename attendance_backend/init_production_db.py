"""
Database initialization script for production deployment.
This script creates necessary tables and default admin user.
Run this once after deploying to a new database.
"""
import os
import sys

# Add the parent directory to the path so we can import the app
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.db.base import engine, Base, SessionLocal
from app.db.models import Teacher
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def init_database():
    """Initialize database with tables and default admin user"""
    print("🔄 Creating database tables...")
    
    # Create all tables
    Base.metadata.create_all(bind=engine)
    print("✅ Database tables created successfully!")
    
    # Create default admin if not exists
    db = SessionLocal()
    try:
        existing_admin = db.query(Teacher).filter(Teacher.email == "admin@school.com").first()
        
        if not existing_admin:
            print("🔄 Creating default admin user...")
            admin = Teacher(
                teacher_id="ADMIN001",
                full_name="System Administrator",
                email="admin@school.com",
                password_hash=pwd_context.hash("admin123"),
                role="admin",
                status="active"
            )
            db.add(admin)
            db.commit()
            print("✅ Default admin user created!")
            print("   Email: admin@school.com")
            print("   Password: admin123")
            print("   ⚠️  CHANGE THIS PASSWORD IMMEDIATELY!")
        else:
            print("ℹ️  Admin user already exists, skipping creation.")
    finally:
        db.close()
    
    print("\n🎉 Database initialization complete!")

if __name__ == "__main__":
    init_database()
