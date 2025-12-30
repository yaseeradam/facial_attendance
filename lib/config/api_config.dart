/// API Configuration
/// 
/// Switch between development and production by changing [useProduction]
/// 
/// For development: Set useProduction = false and update [devBaseUrl] to your local IP
/// For production: Set useProduction = true (uses Render deployment)

class ApiConfig {
  // Toggle this to switch between dev and production
  static const bool useProduction = false;

  // Development URL - Your local computer's IP
  // Find your IP: Windows: ipconfig | Mac/Linux: ifconfig
  // Make sure your phone is on the same WiFi network
  static const String devBaseUrl = 'http://192.168.43.70:8000';

  // Production URL - Your Render deployment
  // Update this after deploying to Render
  static const String prodBaseUrl = 'https://face-attendance-backend.onrender.com';

  /// Get the current base URL based on environment
  static String get baseUrl => useProduction ? prodBaseUrl : devBaseUrl;
  
  /// Connection timeout in seconds
  static const int connectionTimeout = 30;
  
  /// File upload timeout in seconds (longer due to face images)
  static const int uploadTimeout = 60;
}
