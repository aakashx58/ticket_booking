class AppConstants {
  static const String appName = 'Ticket Booking';
  static const String baseUrl = 'https://api.ticketbooking.example.com';
  static const String apiVersion = 'v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String isLoggedInKey = 'is_logged_in';
  
  static const int defaultPageSize = 20;
  static const int maxImageCacheSize = 100 * 1024 * 1024;
  
  static const String eventsEndpoint = '/events';
  static const String bookingsEndpoint = '/bookings';
  static const String authEndpoint = '/auth';
  static const String profileEndpoint = '/profile';
  
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String forgotPasswordPath = '/forgot-password';
  static const String resetPasswordPath = '/reset-password';
  static const String verifyEmailPath = '/verify-email';
  static const String refreshTokenPath = '/refresh-token';
  static const String logoutPath = '/logout';
}