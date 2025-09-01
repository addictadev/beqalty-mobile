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
  
  // Profile icons
  static const String profilePerson = "$_iconsPath/Icon.svg";
  static const String profileWallet = "$_iconsPath/wallett.svg";
  static const String profileOrders = "$_iconsPath/orders.svg";
  static const String profileSavedCarts = "$_iconsPath/savedcarts.svg";
  static const String profileHeart = "$_iconsPath/Heart Open.svg";
  static const String profileSettings = "$_iconsPath/settings.svg";
  static const String profileHelp = "$_iconsPath/help .svg";
  static const String profilePhone = "$_iconsPath/pho.svg";

  static const String onboardingPattern = "$_imagesPath/on_boarding_patern.png";
  static const String profileCamera = "$_imagesPath/cam.png";
}
