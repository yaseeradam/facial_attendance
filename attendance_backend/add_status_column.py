import sqlite3

conn = sqlite3.connect('attendance.db')
cursor = conn.cursor()

# Check current columns
cursor.execute('PRAGMA table_info(teachers)')
columns = [col[1] for col in cursor.fetchall()]
print('Current columns:', columns)

# Add status column if it doesn't exist
if 'status' not in columns:
    print('Adding status column...')
    cursor.execute('ALTER TABLE teachers ADD COLUMN status TEXT DEFAULT "active"')
    conn.commit()
    print('✅ Status column added successfully!')
else:
    print('✅ Status column already exists')

# Verify
cursor.execute('PRAGMA table_info(teachers)')
columns = [col[1] for col in cursor.fetchall()]
print('Updated columns:', columns)

conn.close()
