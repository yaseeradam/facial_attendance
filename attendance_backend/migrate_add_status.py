"""Add status field to teachers table"""
import sqlite3
import os

# Get the database path
db_path = os.path.join(os.path.dirname(__file__), 'attendance.db')

def migrate():
    """Add status column to teachers table if it doesn't exist"""
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    try:
        # Check if status column exists
        cursor.execute("PRAGMA table_info(teachers)")
        columns = [column[1] for column in cursor.fetchall()]
        
        if 'status' not in columns:
            print("Adding 'status' column to teachers table...")
            cursor.execute("ALTER TABLE teachers ADD COLUMN status TEXT DEFAULT 'active'")
            
            # Update existing records to have 'active' status
            cursor.execute("UPDATE teachers SET status = 'active' WHERE status IS NULL")
            
            conn.commit()
            print("✅ Migration completed successfully!")
        else:
            print("✅ Status column already exists. No migration needed.")
            
    except Exception as e:
        print(f"❌ Migration failed: {e}")
        conn.rollback()
    finally:
        conn.close()

if __name__ == "__main__":
    migrate()
