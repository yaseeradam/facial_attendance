"""Database CRUD operations"""
from sqlalchemy.orm import Session
from . import models

def create_student(db: Session, student_data):
    db_student = models.Student(**student_data)
    db.add(db_student)
    db.commit()
    db.refresh(db_student)
    return db_student

def get_students(db: Session):
    return db.query(models.Student).all()

def create_attendance(db: Session, attendance_data):
    db_attendance = models.Attendance(**attendance_data)
    db.add(db_attendance)
    db.commit()
    return db_attendance