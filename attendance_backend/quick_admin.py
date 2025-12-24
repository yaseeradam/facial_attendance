import sqlite3
conn = sqlite3.connect('attendance.db')
conn.execute("INSERT INTO teachers (teacher_id, full_name, email, password_hash, role) VALUES ('admin001', 'System Administrator', 'admin@school.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYqgdstxkKC', 'admin')")
conn.commit()
print('Admin user created!')
print('Email: admin@school.com')
print('Password: admin123')
