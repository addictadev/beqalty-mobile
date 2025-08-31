import 'package:get_it/get_it.dart';
import '../services/shared_preferences_service.dart';

class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> initialize() async {
    await _initializeSharedPreferencesService();
  }

  static Future<void> _initializeSharedPreferencesService() async {
    final sharedPrefsService = await SharedPreferencesService.getInstance();
    _getIt.registerSingleton<SharedPreferencesService>(sharedPrefsService);
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

  static void registerLazySingleton<T extends Object>(T Function() factory) {
    _getIt.registerLazySingleton<T>(factory);
  }

  static Future<void> reset() async {
    await _getIt.reset();
  }
}
