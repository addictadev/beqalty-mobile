class AppConstants {
  // User Categories
  static const String userCategoryCompany = 'company';
  static const String userCategoryIndividual = 'individual';
  static const String isProfileCompletedKey = 'is_profile_completed';

  // Default Values
  static const String defaultLanguage = 'en';
  static const String defaultThemeMode = 'system';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // User Data Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userPhoneKey = 'user_phone';
  static const String userImageKey = 'user_image';
  static const String userTypeKey = 'user_type';
  static const String userDocumentsKey = 'user_documents';

  // File Compression Settings
  static const int compressionMaxWidth = 1024;
  static const int compressionMaxHeight = 1024;
  static const int compressionQuality = 85;
  static const int compressionMaxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int compressionMaxTotalSizeBytes = 10 * 1024 * 1024; // 10MB
}
