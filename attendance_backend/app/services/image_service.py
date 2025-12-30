"""Image storage service (Local + Cloudinary)"""
import os
import uuid
from typing import Optional
import cloudinary
import cloudinary.uploader
from ..core.config import settings

# Configure Cloudinary if credentials exist
USE_CLOUDINARY = all([
    settings.cloudinary_cloud_name,
    settings.cloudinary_api_key,
    settings.cloudinary_api_secret
])

if USE_CLOUDINARY:
    cloudinary.config(
        cloud_name=settings.cloudinary_cloud_name,
        api_key=settings.cloudinary_api_key,
        api_secret=settings.cloudinary_api_secret
    )

# Local upload directory
UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "uploads", "students")
os.makedirs(UPLOAD_DIR, exist_ok=True)

class ImageService:
    @staticmethod
    def save_image(image_data: bytes, student_id: int) -> Optional[str]:
        """
        Save image to Cloudinary (if configured) or local storage.
        Returns the path or URL of the saved image.
        """
        filename = f"{student_id}_{uuid.uuid4().hex[:8]}"
        
        if USE_CLOUDINARY:
            try:
                # Upload to Cloudinary
                # folder="students" organizes images in a folder on Cloudinary
                response = cloudinary.uploader.upload(
                    image_data, 
                    folder="face_attendance/students",
                    public_id=filename,
                    overwrite=True,
                    resource_type="image"
                )
                # Return the secure URL
                return response.get("secure_url")
            except Exception as e:
                print(f"❌ Cloudinary upload failed: {e}")
                # Fallback to local storage if upload fails?
                # For now, let's try local fallback
                print("⚠️ Falling back to local storage")
        
        # Local storage (Fallback or default)
        try:
            local_filename = f"{filename}.jpg"
            file_path = os.path.join(UPLOAD_DIR, local_filename)
            with open(file_path, "wb") as f:
                f.write(image_data)
            
            # Return relative path for local storage
            return f"students/{local_filename}"
        except Exception as e:
            print(f"❌ Local save failed: {e}")
            return None

    @staticmethod
    def delete_image(photo_path: str):
        """
        Delete image from storage.
        Checks if it's a Cloudinary URL or local path.
        """
        if not photo_path:
            return

        if "cloudinary.com" in photo_path:
            if USE_CLOUDINARY:
                try:
                    # Extract public_id from URL
                    # URL format: .../face_attendance/students/filename.jpg
                    # We need: face_attendance/students/filename
                    parts = photo_path.split("/")
                    # Find where 'face_attendance' starts
                    try:
                        idx = parts.index("face_attendance")
                        public_id_parts = parts[idx:]
                        public_id = "/".join(public_id_parts)
                        # Remove extension
                        public_id = os.path.splitext(public_id)[0]
                        
                        cloudinary.uploader.destroy(public_id)
                        print(f"✅ Deleted from Cloudinary: {public_id}")
                    except ValueError:
                        print("Could not parse Cloudinary URL for deletion")
                except Exception as e:
                    print(f"❌ Cloudinary delete failed: {e}")
        else:
            # Local file
            try:
                # photo_path is like "students/filename.jpg"
                # UPLOAD_DIR is ".../uploads/students"
                # We need to join ".../uploads" + photo_path
                base_upload_dir = os.path.dirname(UPLOAD_DIR) # .../uploads
                full_path = os.path.join(base_upload_dir, photo_path)
                
                if os.path.exists(full_path):
                    os.remove(full_path)
                    print(f"✅ Deleted local file: {full_path}")
            except Exception as e:
                print(f"❌ Local delete failed: {e}")
