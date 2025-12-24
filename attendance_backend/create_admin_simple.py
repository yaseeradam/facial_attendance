"""Simple script to create admin user using bcrypt directly"""
import sqlite3
import bcrypt

# Database path
db_path = "attendance.db"

# Admin credentials
admin_email = "admin@school.com"
admin_password = "admin123"
admin_teacher_id = "admin001"
admin_name = "System Administrator"
admin_role = "admin"

# Hash the password using bcrypt directly
password_bytes = admin_password.encode('utf-8')
salt = bcrypt.gensalt()
hashed_password = bcrypt.hashpw(password_bytes, salt).decode('utf-8')

# Connect to database
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Check if admin exists
cursor.execute("SELECT * FROM teachers WHERE email = ?", (admin_email,))
existing_admin = cursor.fetchone()

if existing_admin:
    print("✅ Admin user already exists!")
    print(f"   Email: {admin_email}")
    print(f"   Password: {admin_password}")
else:
    # Insert admin user
    cursor.execute("""
        INSERT INTO teachers (teacher_id, full_name, email, password_hash, role)
        VALUES (?, ?, ?, ?, ?)
    """, (admin_teacher_id, admin_name, admin_email, hashed_password, admin_role))
    
    conn.commit()
    print("✅ Admin user created successfully!")
    print(f"   Email: {admin_email}")
    print(f"   Password: {admin_password}")
    print("   ⚠️  CHANGE THIS PASSWORD IN PRODUCTION!")

conn.close()
