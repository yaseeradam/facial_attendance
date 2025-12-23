# Face Recognition Attendance System Backend

A production-ready backend system for face recognition-based attendance tracking using FastAPI and InsightFace.

## 🚀 Features

- **Face Recognition**: Uses InsightFace buffalo_l model for accurate face detection and recognition
- **Attendance Tracking**: Automatic attendance marking upon face verification
- **Role-Based Access**: Admin and Teacher roles with appropriate permissions
- **RESTful API**: Complete REST API with comprehensive endpoints
- **Database Management**: SQLAlchemy ORM with SQLite (configurable)
- **Security**: JWT-based authentication with bcrypt password hashing
- **Validation**: Comprehensive input validation and error handling

## 🏗️ Architecture

```
app/
├── main.py              # FastAPI application entry point
├── core/                # Core configurations
│   ├── config.py        # App settings
│   └── security.py      # Authentication & authorization
├── api/                 # API route handlers
│   ├── auth.py          # Authentication endpoints
│   ├── teachers.py      # Teacher management
│   ├── classes.py       # Class management
│   ├── students.py      # Student management
│   ├── attendance.py    # Attendance operations
│   └── face.py          # Face recognition endpoints
├── services/            # Business logic layer
├── ai/                  # AI/ML components
│   ├── insightface_model.py  # Model initialization
│   ├── embedding.py     # Face embedding generation
│   └── matcher.py       # Face matching algorithms
├── db/                  # Database layer
│   ├── models.py        # SQLAlchemy models
│   ├── crud.py          # Database operations
│   └── base.py          # Database connection
├── schemas/             # Pydantic schemas
└── utils/               # Utility functions
```

## 📋 Requirements

- Python 3.10+
- 4GB+ RAM (for InsightFace model)
- CPU or GPU (GPU recommended for better performance)

## 🛠️ Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd attendance_backend
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your settings
```

5. **Run the application**
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## 🔧 Configuration

Edit `.env` file:

```env
DATABASE_URL=sqlite:///./attendance.db
SECRET_KEY=your-super-secret-key-change-in-production
FACE_SIMILARITY_THRESHOLD=0.6  # Adjust face matching sensitivity
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

## 📚 API Documentation

Once running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Key Endpoints

#### Authentication
- `POST /auth/login` - Teacher login

#### Teachers (Admin only)
- `POST /teachers` - Create teacher
- `GET /teachers` - List teachers

#### Classes
- `POST /classes` - Create class (Admin)
- `GET /classes` - List classes
- `GET /classes/{id}` - Get class details

#### Students
- `POST /students` - Create student
- `GET /students` - List students
- `GET /students/{id}` - Get student details

#### Face Recognition
- `POST /face/register` - Register student face
- `POST /face/verify` - Verify face & mark attendance

#### Attendance
- `GET /attendance/today` - Today's attendance
- `GET /attendance/by-class/{class_id}` - Class attendance
- `GET /attendance/summary/{class_id}` - Attendance summary

## 🧠 Face Recognition Workflow

### Face Enrollment
1. Upload student photo via `/face/register`
2. System detects exactly one face (rejects multiple/no faces)
3. Generates 512-dimensional embedding using InsightFace
4. Stores embedding in database (no raw images stored)
5. Sets `face_enrolled = true` for student

### Attendance Marking
1. Upload photo via `/face/verify` with `class_id`
2. Generate embedding from uploaded image
3. Compare with all enrolled faces in the class
4. If similarity ≥ threshold: mark attendance
5. Return recognition result with confidence score

## 🔐 Security Features

- **JWT Authentication**: Secure token-based auth
- **Role-Based Access**: Admin/Teacher permissions
- **Password Hashing**: bcrypt for secure password storage
- **Input Validation**: Comprehensive request validation
- **Access Control**: Teachers can only access their classes

## 🗄️ Database Schema

```sql
teachers:
- id, teacher_id, full_name, email, password_hash, role

classes:
- id, class_name, class_code, teacher_id

students:
- id, student_id, full_name, class_id, face_enrolled

face_embeddings:
- id, student_id, embedding (JSON), created_at

attendance:
- id, student_id, class_id, marked_at, confidence_score
```

## 🚀 Production Deployment

1. **Environment Setup**
```bash
# Use production database
DATABASE_URL=postgresql://user:pass@localhost/attendance

# Strong secret key
SECRET_KEY=your-very-strong-secret-key

# Disable debug
DEBUG=False
```

2. **Run with Gunicorn**
```bash
pip install gunicorn
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker
```

3. **Docker Deployment**
```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## 🧪 Testing

```bash
# Run tests
pytest app/tests/

# Test face recognition
python -m pytest app/tests/test_face.py -v
```

## 📊 Performance Tuning

- **Face Similarity Threshold**: Adjust `FACE_SIMILARITY_THRESHOLD` (0.4-0.8)
- **Model Performance**: Use GPU for faster inference
- **Database**: Use PostgreSQL for production
- **Caching**: Implement Redis for session management

## 🔧 Troubleshooting

### Common Issues

1. **InsightFace Installation**
```bash
# If installation fails
pip install onnxruntime
pip install insightface --no-deps
```

2. **Memory Issues**
- Ensure 4GB+ RAM available
- Use CPU mode if GPU memory insufficient

3. **Face Detection Issues**
- Ensure good lighting in photos
- Use high-resolution images (min 100x100px)
- Ensure only one face per image

## 📝 API Usage Examples

### Create Admin User (First Time Setup)
```python
# Run this script once to create admin user
import asyncio
from app.db.base import SessionLocal
from app.services.teacher_service import TeacherService
from app.schemas.teacher import TeacherCreate

async def create_admin():
    db = SessionLocal()
    service = TeacherService()
    admin_data = TeacherCreate(
        teacher_id="admin001",
        full_name="System Administrator",
        email="admin@school.com",
        password="admin123",
        role="admin"
    )
    await service.create_teacher(admin_data, db)
    print("Admin user created")

asyncio.run(create_admin())
```

### Login and Get Token
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@school.com", "password": "admin123"}'
```

### Register Student Face
```bash
curl -X POST "http://localhost:8000/face/register" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "student_id=1" \
  -F "file=@student_photo.jpg"
```

### Verify Face for Attendance
```bash
curl -X POST "http://localhost:8000/face/verify" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "class_id=1" \
  -F "file=@verification_photo.jpg"
```

## 📄 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📞 Support

For issues and questions:
- Create GitHub issue
- Check documentation at `/docs`
- Review troubleshooting section