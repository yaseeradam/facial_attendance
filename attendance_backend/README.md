# Attendance Backend

Face recognition-based attendance system backend using FastAPI and InsightFace.

## Features

- Face registration and verification using InsightFace
- Student and teacher management
- Attendance tracking and reporting
- RESTful API endpoints
- SQLite database with SQLAlchemy ORM

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Configure environment variables in `.env`

3. Run the application:
```bash
uvicorn app.main:app --reload
```

## API Endpoints

- `/auth/login` - Authentication
- `/students/` - Student management
- `/teachers/` - Teacher management
- `/attendance/` - Attendance operations
- `/face/register` - Face registration
- `/face/verify` - Face verification

## Project Structure

- `app/` - Main application code
- `app/api/` - API route handlers
- `app/services/` - Business logic
- `app/ai/` - Face recognition logic
- `app/db/` - Database models and operations
- `data/` - Data storage (embeddings, logs)