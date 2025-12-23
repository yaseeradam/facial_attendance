"""App entry point"""
from fastapi import FastAPI

app = FastAPI(title="Attendance Backend")

@app.get("/")
def root():
    return {"message": "Attendance Backend API"}