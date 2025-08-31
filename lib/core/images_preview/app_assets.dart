class AppAssets {
  factory AppAssets() {
    return _instance;
  }
  AppAssets._();
  static final AppAssets _instance = AppAssets._();

  static const String _iconsPath = "assets/icons";
  static const String _imagesPath = "assets/images";

  static const String appIcon = "$_iconsPath/app_icon.png";
  static const String splashIcon = "$_imagesPath/splash_icon.svg";
  static const String authBackground = "$_imagesPath/auth_background.png";
  static const String authLoginBackground = "$_imagesPath/auth_welcome.svg";
  static const String shoppingBag = "$_iconsPath/cart_icon.svg";

  static const String onboardingPattern = "$_imagesPath/on_boarding_patern.png";
}
