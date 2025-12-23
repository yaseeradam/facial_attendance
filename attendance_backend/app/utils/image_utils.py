"""Image processing utilities"""
import cv2
import numpy as np
from PIL import Image

def preprocess_image(image_bytes):
    """Preprocess image for face recognition"""
    nparr = np.frombuffer(image_bytes, np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    return image

def resize_image(image, max_size=640):
    """Resize image while maintaining aspect ratio"""
    height, width = image.shape[:2]
    if max(height, width) > max_size:
        scale = max_size / max(height, width)
        new_width = int(width * scale)
        new_height = int(height * scale)
        return cv2.resize(image, (new_width, new_height))
    return image