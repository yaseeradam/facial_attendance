import sqlite3

conn = sqlite3.connect('attendance.db')
cursor = conn.cursor()

# Check for admin users
cursor.execute("SELECT teacher_id, full_name, email, role, status FROM teachers WHERE role = 'admin'")
admins = cursor.fetchall()

print("=" * 50)
print("ADMIN USERS IN DATABASE")
print("=" * 50)

if admins:
    for admin in admins:
        print(f"\nTeacher ID: {admin[0]}")
        print(f"Name: {admin[1]}")
        print(f"Email: {admin[2]}")
        print(f"Role: {admin[3]}")
        print(f"Status: {admin[4] if admin[4] else 'active'}")
        print("-" * 50)
    
    print("\n" + "=" * 50)
    print("LOGIN CREDENTIALS")
    print("=" * 50)
    print("Email: admin@school.com")
    print("Password: admin123")
    print("=" * 50)
else:
    print("\nNo admin users found!")
    print("Run this script to create one:")
    print("  python quick_admin.py")

conn.close()
