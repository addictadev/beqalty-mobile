class EndPoints {
  factory EndPoints() {
    return _instance;
  }
  EndPoints._();
  static final EndPoints _instance = EndPoints._();

  // API base url
  static const String baseUrl =
      "https://baqalty-back.addictaco.website/api/v1/";

  // Auth Endpoints
  static const String register = "auth/register";
  static const String login = "auth/login";
  static const String verifyRegisterOtp = "auth/verify-register-otp";
  static const String verifyOtp = "auth/verify-password-otp";
  static const String resendOtp = "auth/resend-otp";
  static const String forgotPassword = "auth/forgot-password";
  static const String resetPassword = "auth/reset-password";
  static const String completeProfile = "auth/complete-profile";
  static const String updateImage = "auth/update-image";
  static const String logout = "auth/logout";
  static const String deleteAccount = "account";
  static const String getUser = "auth/user";
  static const String updateProfile = "profile";
  static const String changePassword = "profile/reset-password";

  // Home Endpoints
  static const String home = "home";
  static const String banner = "banner";
  static const String categories = "categories/parents";
  static String subcategories(String parentId) =>
      "categories/parent/$parentId/sublevels";
  static String subcategoryProducts(String subcategoryId) =>
      "sublevel/$subcategoryId/products";
  static const String addresses = "addresses";
}
