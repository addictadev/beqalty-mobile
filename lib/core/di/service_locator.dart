import 'package:baqalty/features/orders/data/services/order_details_service.dart';
import 'package:get_it/get_it.dart';
import '../services/shared_preferences_service.dart';
import '../../features/product_details/data/services/product_details_service.dart';
import '../../features/product_details/data/services/product_details_service_impl.dart';
import '../../features/cart/data/services/cart_service.dart';
import '../../features/cart/data/services/cart_service_impl.dart';
import '../../features/cart/data/services/shared_cart_service.dart';
import '../../features/saved_carts/data/services/favorite_items_service.dart';
import '../../features/saved_carts/data/services/favorite_items_service_impl.dart';
import '../../features/saved_carts/data/services/saved_carts_service.dart';
import '../../features/checkout/data/services/checkout_service.dart';
import '../../features/orders/data/services/orders_service.dart';
import '../../features/orders/data/services/replacement_orders_service.dart';
import '../../features/rewards/data/services/loyalty_service.dart';

class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> initialize() async {
    await _initializeSharedPreferencesService();
    _initializeProductDetailsService();
    _initializeCartService();
    _initializeSharedCartService();
    _initializeFavoriteItemsService();
    _initializeSavedCartsService();
    _initializeCheckoutService();
    _initializeOrdersService();
    _initializeOrderDetailsService();
    _initializeReplacementOrdersService();
    _initializeLoyaltyService();
  }

  static Future<void> _initializeSharedPreferencesService() async {
    final sharedPrefsService = await SharedPreferencesService.getInstance();
    _getIt.registerSingleton<SharedPreferencesService>(sharedPrefsService);
  }

  static void _initializeProductDetailsService() {
    _getIt.registerLazySingleton<ProductDetailsService>(
      () => ProductDetailsServiceImpl(),
    );
  }

  static void _initializeCartService() {
    _getIt.registerLazySingleton<CartService>(
      () => CartServiceImpl(),
    );
  }

  static void _initializeSharedCartService() {
    _getIt.registerLazySingleton<SharedCartService>(
      () => SharedCartServiceImpl(),
    );
  }

  static void _initializeFavoriteItemsService() {
    _getIt.registerLazySingleton<FavoriteItemsService>(
      () => FavoriteItemsServiceImpl(),
    );
  }

  static void _initializeSavedCartsService() {
    _getIt.registerLazySingleton<SavedCartsService>(
      () => SavedCartsService(),
    );
  }

  static void _initializeCheckoutService() {
    _getIt.registerLazySingleton<CheckoutService>(
      () => CheckoutService(),
    );
  }

  static void _initializeOrdersService() {
    _getIt.registerLazySingleton<OrdersService>(
      () => OrdersService(),
    );
  }

  static void _initializeOrderDetailsService() {
    _getIt.registerLazySingleton<OrderDetailsService>(
      () => OrderDetailsService(),
    );
  }


  static SharedPreferencesService get sharedPreferencesService {
    return _getIt<SharedPreferencesService>();
  }

  static T get<T extends Object>() {
    return _getIt<T>();
  }

  static bool isRegistered<T extends Object>() {
    return _getIt.isRegistered<T>();
  }

  static void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  static void _initializeReplacementOrdersService() {
    _getIt.registerLazySingleton<ReplacementOrdersService>(
      () => ReplacementOrdersServiceImpl(),
    );
  }

  static void _initializeLoyaltyService() {
    _getIt.registerLazySingleton<LoyaltyService>(
      () => LoyaltyServiceImpl(),
    );
  }

  static void registerLazySingleton<T extends Object>(T Function() factory) {
    _getIt.registerLazySingleton<T>(factory);
  }

  static Future<void> reset() async {
    await _getIt.reset();
  }
}
