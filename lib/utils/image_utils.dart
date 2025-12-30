import '../services/api_service.dart';

class ImageUtils {
  /// Get full image URL from a path.
  /// 
  /// Handles:
  /// 1. Cloudinary URLs (starts with http/https) -> returns as-is
  /// 2. Local backend paths (relative) -> prepends base URL
  /// 3. Null/Empty -> returns placeholder (or handled by caller)
  static String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Remove leading slash if present to avoid double slashes
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    
    // Check if it's already an uploads path
    if (cleanPath.startsWith('uploads/')) {
        return '${ApiService.baseUrl}/$cleanPath';
    }

    return '${ApiService.baseUrl}/uploads/$cleanPath';
  }
}
