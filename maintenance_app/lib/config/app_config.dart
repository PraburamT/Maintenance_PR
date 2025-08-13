class AppConfig {
  // Backend Configuration
  static const String backendUrl = 'http://localhost:3000';
  
  // API Endpoints
  static const String loginEndpoint = '/maintenance-login';
  static const String plantEndpoint = '/plant-list';
  static const String notificationEndpoint = '/notify-list';
  static const String workEndpoint = '/main-work';
  
  // App Configuration
  static const String appName = 'Maintenance App';
  static const String appVersion = '1.0.0';
  
  // Timeout Configuration
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Local Storage Keys
  static const String empIdKey = 'empId';
  static const String authTokenKey = 'authToken';
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 4.0;
}
