"""Create admin user - working version"""
import sqlite3
import sys

# Simple manual bcrypt hash for "admin123"
# This is a pre-computed bcrypt hash for the password "admin123"
# Generated with: bcrypt.hashpw(b"admin123", bcrypt.gensalt())
ADMIN_PASSWORD_HASH = "$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYqgdstxkKC"

# Database path
db_path = "attendance.db"

# Admin credentials
admin_email = "admin@school.com"
admin_teacher_id = "admin001"
admin_name = "System Administrator"
admin_role = "admin"

try:
    # Connect to database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Check if admin exists
    cursor.execute("SELECT * FROM teachers WHERE email = ?", (admin_email,))
    existing_admin = cursor.fetchone()

    if existing_admin:
        print("[OK] Admin user already exists!")
        print(f"   Email: {admin_email}")
        print(f"   Password: admin123")
    else:
        # Insert admin user with pre-computed hash
        cursor.execute("""
            INSERT INTO teachers (teacher_id, full_name, email, password_hash, role)
            VALUES (?, ?, ?, ?, ?)
        """, (admin_teacher_id, admin_name, admin_email, ADMIN_PASSWORD_HASH, admin_role))
        
        conn.commit()
        print("[OK] Admin user created successfully!")
        print(f"   Email: {admin_email}")
        print(f"   Password: admin123")
        print("   [WARNING] CHANGE THIS PASSWORD IN PRODUCTION!")

    conn.close()
    sys.exit(0)
    
except Exception as e:
    print(f"[ERROR] {e}")
    sys.exit(1)
