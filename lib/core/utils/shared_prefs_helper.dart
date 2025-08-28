import '../di/service_locator.dart';
import '../services/shared_preferences_service.dart';
import '../services/secure_storage_service.dart';

/// Helper class for easy access to shared preferences throughout the app
class SharedPrefsHelper {
  static SharedPreferencesService get _service =>
      ServiceLocator.sharedPreferencesService;

  // User Category Methods
  static Future<bool> setUserCategory(String category) =>
      _service.setUserCategory(category);
  static String? getUserCategory() => _service.getUserCategory();
  static bool isCompany() => _service.isCompany();
  static bool isIndividual() => _service.isIndividual();
  static bool hasUserCategory() => _service.hasUserCategory();
  static Future<bool> clearUserCategory() => _service.clearUserCategory();

  // User Token Methods (Secure Storage)
  static Future<bool> setUserToken(String token) async {
    try {
      await SecureStorageService.storeUserToken(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getUserToken() async {
    return await SecureStorageService.getUserToken();
  }

  static Future<bool> hasUserToken() async {
    final token = await getUserToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> clearUserToken() async {
    try {
      await SecureStorageService.clearAuthData();
      return true;
    } catch (e) {
      return false;
    }
  }

  // User Data Methods
  static Future<bool> setUserData(Map<String, dynamic> userData) =>
      _service.setUserData(userData);
  static Map<String, dynamic>? getUserData() => _service.getUserData();
  static Future<bool> clearUserData() => _service.clearUserData();

  // Language Methods
  static Future<bool> setLanguage(String languageCode) =>
      _service.setLanguage(languageCode);
  static String getLanguage() => _service.getLanguage();

  // Theme Methods
  static Future<bool> setThemeMode(String themeMode) =>
      _service.setThemeMode(themeMode);
  static String getThemeMode() => _service.getThemeMode();

  // First Time User Methods
  static Future<bool> setIsFirstTime(bool isFirstTime) =>
      _service.setIsFirstTime(isFirstTime);
  static bool getIsFirstTime() => _service.getIsFirstTime();

  // Generic Methods
  static Future<bool> setString(String key, String value) =>
      _service.setString(key, value);
  static String? getString(String key) => _service.getString(key);
  static Future<bool> setBool(String key, bool value) =>
      _service.setBool(key, value);
  static bool getBool(String key, {bool defaultValue = false}) =>
      _service.getBool(key, defaultValue: defaultValue);
  static Future<bool> setInt(String key, int value) =>
      _service.setInt(key, value);
  static int getInt(String key, {int defaultValue = 0}) =>
      _service.getInt(key, defaultValue: defaultValue);
  static Future<bool> setDouble(String key, double value) =>
      _service.setDouble(key, value);
  static double getDouble(String key, {double defaultValue = 0.0}) =>
      _service.getDouble(key, defaultValue: defaultValue);
  static Future<bool> setStringList(String key, List<String> value) =>
      _service.setStringList(key, value);
  static List<String> getStringList(String key) => _service.getStringList(key);

  // Utility Methods
  static bool containsKey(String key) => _service.containsKey(key);
  static Set<String> getKeys() => _service.getKeys();
  static Future<bool> remove(String key) => _service.remove(key);
  static Future<bool> clearAll() => _service.clearAll();
}
