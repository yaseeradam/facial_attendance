"""Image processing utilities"""
import cv2
import numpy as np
from typing import Optional, Tuple
from PIL import Image
import io

def preprocess_image(image_bytes: bytes) -> Optional[np.ndarray]:
    """Convert image bytes to OpenCV format"""
    try:
        # Convert bytes to numpy array
        nparr = np.frombuffer(image_bytes, np.uint8)
        
        # Decode image
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        if image is None:
            return None
            
        # Convert BGR to RGB (InsightFace expects RGB)
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        
        return image
        
    except Exception as e:
        print(f"Error preprocessing image: {e}")
        return None

def validate_image_format(image_bytes: bytes) -> Tuple[bool, str]:
    """Validate if image is in supported format"""
    try:
        # Try to open with PIL to validate format
        image = Image.open(io.BytesIO(image_bytes))
        
        # Check if format is supported
        if image.format not in ['JPEG', 'PNG', 'JPG']:
            return False, "Unsupported image format. Please use JPEG or PNG"
        
        # Check image size
        width, height = image.size
        if width < 100 or height < 100:
            return False, "Image too small. Minimum size is 100x100 pixels"
        
        if width > 4000 or height > 4000:
            return False, "Image too large. Maximum size is 4000x4000 pixels"
        
        return True, "Image format is valid"
        
    except Exception as e:
        return False, f"Invalid image file: {str(e)}"

def resize_image_if_needed(image: np.ndarray, max_size: int = 1024) -> np.ndarray:
    """Resize image if it's too large while maintaining aspect ratio"""
    height, width = image.shape[:2]
    
    if max(height, width) <= max_size:
        return image
    
    # Calculate new dimensions
    if height > width:
        new_height = max_size
        new_width = int(width * (max_size / height))
    else:
        new_width = max_size
        new_height = int(height * (max_size / width))
    
    # Resize image
    resized = cv2.resize(image, (new_width, new_height), interpolation=cv2.INTER_AREA)
    return resized