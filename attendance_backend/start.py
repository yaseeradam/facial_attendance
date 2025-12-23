"""Startup script for the attendance backend"""
import subprocess
import sys
import os

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"\n🔄 {description}...")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} completed successfully!")
        if result.stdout:
            print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} failed!")
        print(f"Error: {e.stderr}")
        return False

def main():
    print("🚀 Starting Face Recognition Attendance System Backend")
    print("=" * 60)
    
    # Check if virtual environment is activated
    if not hasattr(sys, 'real_prefix') and not (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        print("⚠️  Warning: Virtual environment not detected!")
        print("It's recommended to run this in a virtual environment.")
        response = input("Continue anyway? (y/N): ")
        if response.lower() != 'y':
            print("Exiting...")
            return
    
    # Install dependencies
    if not run_command("pip install -r requirements.txt", "Installing dependencies"):
        return
    
    # Initialize database
    if not run_command("python init_db.py", "Initializing database"):
        return
    
    print("\n🎉 Setup completed successfully!")
    print("\n📋 Next steps:")
    print("1. Review and update .env file with your settings")
    print("2. Change the default admin password")
    print("3. Start the server with: uvicorn app.main:app --reload")
    print("\n📚 API Documentation will be available at:")
    print("   - Swagger UI: http://localhost:8000/docs")
    print("   - ReDoc: http://localhost:8000/redoc")
    print("\n🔐 Default admin credentials:")
    print("   Email: admin@school.com")
    print("   Password: admin123")
    print("   ⚠️  CHANGE THIS PASSWORD IN PRODUCTION!")
    
    # Ask if user wants to start the server
    response = input("\nStart the development server now? (y/N): ")
    if response.lower() == 'y':
        print("\n🚀 Starting development server...")
        print("Press Ctrl+C to stop the server")
        try:
            subprocess.run("uvicorn app.main:app --reload --host 0.0.0.0 --port 8000", shell=True)
        except KeyboardInterrupt:
            print("\n👋 Server stopped. Goodbye!")

if __name__ == "__main__":
    main()