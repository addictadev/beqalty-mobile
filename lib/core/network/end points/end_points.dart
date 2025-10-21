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

  // Product Endpoints
  static String productDetails(int productId) => "products/$productId";
  static const String likeProduct = "like-products/like";
  static const String unlikeProduct = "like-products/unlike";
  static const String getAllFavoriteItems = "like-products/all";

  // Cart Endpoints
  static const String addToCart = "cart/add";
  static const String getAllCart = "cart";
  static const String updateCartItem = "cart/update";
  static const String removeCartItem = "cart/remove";
  static const String cartMinus = "cart/minus";
  static const String removeItem = "cart/remove";
  static const String clearCart = "cart/clear";
  static const String checkout = "orders/check-out";
  static const String createOrder = "orders/create-order";
  static String getSharedCart(String sharedCartId) => "cart?shared_cart_id=$sharedCartId";
  static String getSharedCartRedirect(String sharedCartId) => "shared-cart-redirect?id=$sharedCartId";

  // Search Endpoints
  static const String searchProducts = "search-products";

  // Saved Carts Endpoints
  static const String savedCarts = "saved-carts";
  static const String createSavedCart = "saved-carts/create";
  static const String saveMainCart = "saved-carts/save-mainCart";
  static String deleteSavedCart(int cartId) => "saved-carts/$cartId";
  static String getSavedCartDetails(int cartId) => "saved-carts/$cartId";
  static String removeItemFromSavedCart(int cartId) => "saved-carts/$cartId/remove";
  static String minusItemFromSavedCart(int cartId) => "saved-carts/$cartId/minus";
  static String plusItemFromSavedCart(int cartId) => "saved-carts/$cartId/add";

  // Orders Endpoints
  static const String orders = "orders";
  static String orderDetails(int orderId) => "orders/$orderId";
  static const String replacementOrders = "orders-replacement";
  static String selectReplacement(int orderId) => "orders/$orderId/select-replacement";
  static const String loyalty = "loyalty";
  static const String loyaltyRedeem = "loyalty/redeem";
  static const String pointsTransactions = "points/transactions";

  // Discount Endpoints
  static const String applyDiscount = "dicounts/apply";
}
