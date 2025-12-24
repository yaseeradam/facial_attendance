"""Create admin with correct bcrypt hash"""
import sys
sys.path.append('.')

from app.core.security import get_password_hash
import sqlite3

# Generate correct hash using our fixed bcrypt implementation
password_hash = get_password_hash("admin123")
print(f"Generated hash: {password_hash}")

# Connect to database
conn = sqlite3.connect('attendance.db')
cursor = conn.cursor()

# Delete existing admin if exists
cursor.execute("DELETE FROM teachers WHERE email = 'admin@school.com'")

# Insert new admin with correct hash
cursor.execute("""
    INSERT INTO teachers (teacher_id, full_name, email, password_hash, role)
    VALUES (?, ?, ?, ?, ?)
""", ("admin001", "System Administrator", "admin@school.com", password_hash, "admin"))

conn.commit()
print("\n[SUCCESS] Admin user created!")
print("Email: admin@school.com")
print("Password: admin123")

conn.close()
