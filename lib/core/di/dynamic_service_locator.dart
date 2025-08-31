import 'package:get_it/get_it.dart';

class DynamicServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  static void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  static void registerLazySingleton<T extends Object>(T Function() factory) {
    _getIt.registerLazySingleton<T>(factory);
  }

  static void registerFactory<T extends Object>(T Function() factory) {
    _getIt.registerFactory<T>(factory);
  }

  static T get<T extends Object>() {
    try {
      return _getIt<T>();
    } catch (e) {
      throw ServiceNotFoundException('Service of type $T is not registered');
    }
  }

  static T? getIfRegistered<T extends Object>() {
    try {
      return _getIt<T>();
    } catch (e) {
      return null;
    }
  }

  static T getWithFallback<T extends Object>(T fallback) {
    try {
      return _getIt<T>();
    } catch (e) {
      return fallback;
    }
  }

  static bool isRegistered<T extends Object>() {
    return _getIt.isRegistered<T>();
  }

  static Future<void> unregister<T extends Object>() async {
    await _getIt.unregister<T>();
  }

  static Future<void> reset() async {
    await _getIt.reset();
  }

  static void registerIfNotRegistered<T extends Object>(T Function() factory) {
    if (!isRegistered<T>()) {
      registerLazySingleton<T>(factory);
    }
  }

  static Future<void> registerAsync<T extends Object>(
    Future<T> Function() asyncFactory,
  ) async {
    _getIt.registerSingletonAsync<T>(asyncFactory);
  }

  static Future<void> waitForAsyncServices() async {
    await _getIt.allReady();
  }

  static void registerNamed<T extends Object>(String name, T instance) {
    _getIt.registerSingleton<T>(instance, instanceName: name);
  }

  static T getNamed<T extends Object>(String name) {
    try {
      return _getIt<T>(instanceName: name);
    } catch (e) {
      throw ServiceNotFoundException(
        'Service of type $T with name "$name" is not registered',
      );
    }
  }

  static bool isNamedRegistered<T extends Object>(String name) {
    return _getIt.isRegistered<T>(instanceName: name);
  }

  static Future<void> clear() async {
    await _getIt.reset();
  }
}

class ServiceNotFoundException implements Exception {
  final String message;
  ServiceNotFoundException(this.message);

  @override
  String toString() => 'ServiceNotFoundException: $message';
}

extension DynamicServiceLocatorExtension on DynamicServiceLocator {
  static void register<T extends Object>(T instance) {
    DynamicServiceLocator.registerSingleton<T>(instance);
  }

  static void registerLazy<T extends Object>(T Function() factory) {
    DynamicServiceLocator.registerLazySingleton<T>(factory);
  }

  static T resolve<T extends Object>() {
    return DynamicServiceLocator.get<T>();
  }
}
