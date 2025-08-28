class EndPoints {
  factory EndPoints() {
    return _instance;
  }
  EndPoints._();
  static final EndPoints _instance = EndPoints._();

  // API base url
  static const String baseUrl =
      "https://raalc-back.addictaco.website/api/v1/mobile/";

  // Auth Endpoints
  static const String register = "auth/register";
  static const String login = "auth/login";
  static const String verifyOtp = "auth/verfiy-otp";
  static const String resendOtp = "auth/resend-otp";
  static const String completeProfile = "auth/complete-profile";
  static const String updateImage = "auth/update-image";
  static const String logout = "auth/logout";
  static const String deleteAccount = "auth/delete-account";

  // Home Endpoints
  static const String banner = "banner";
}
