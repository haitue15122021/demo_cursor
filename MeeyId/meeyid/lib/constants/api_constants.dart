class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.meeyid.com';
  static const String baseUrlDev = 'https://dev-api.meeyid.com';

  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/update';

  // Headers
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String acceptLanguage = 'Accept-Language';
  static const String userAgent = 'User-Agent';

  // Values
  static const String applicationJson = 'application/json';
  static const String bearer = 'Bearer';
}
