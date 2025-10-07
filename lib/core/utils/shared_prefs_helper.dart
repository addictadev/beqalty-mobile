import '../di/service_locator.dart';
import '../services/shared_preferences_service.dart';
import '../services/secure_storage_service.dart';
import '../constants/app_constants.dart';

class SharedPrefsHelper {
  static SharedPreferencesService get _service =>
      ServiceLocator.sharedPreferencesService;



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

  static Future<bool> setUserData(Map<String, dynamic> userData) =>
      _service.setUserData(userData);
  static Map<String, dynamic>? getUserData() => _service.getUserData();
  static Future<bool> clearUserData() => _service.clearUserData();





  static Future<String?> getSecureUserToken() async {
    try {
      return await SecureStorageService.getUserToken();
    } catch (e) {
      return null;
    }
  }

  static Future<bool> hasSecureUserToken() async {
    try {
      final token = await getSecureUserToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearSecureUserToken() async {
    try {
      await SecureStorageService.clearAuthData();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setUserEmail(String email) =>
      _service.setString('user_email', email);
  static String? getUserEmail() => _service.getString('user_email');

  static Future<bool> setUserId(int userId) =>
      _service.setInt('user_id', userId);
  static int? getUserId() => _service.getInt('user_id');

  static Future<bool> setUserName(String name) =>
      _service.setString('user_name', name);
  static String? getUserName() => _service.getString('user_name');

  static Future<bool> setUserPhone(String phone) =>
      _service.setString('user_phone', phone);
  static String? getUserPhone() => _service.getString('user_phone');

  static Future<bool> setUserAvatar(String avatar) =>
      _service.setString('user_avatar', avatar);
  static String? getUserAvatar() => _service.getString('user_avatar');

  static Future<bool> setEmailVerified(bool isVerified) =>
      _service.setBool('email_verified', isVerified);
  static bool isEmailVerified() => _service.getBool('email_verified');

  static Future<bool> clearAuthData() async {
    try {
      await clearSecureUserToken();
      await _service.remove(AppConstants.userEmailKey);
      await _service.remove(AppConstants.userIdKey);
      await _service.remove(AppConstants.userNameKey);
      await _service.remove(AppConstants.userPhoneKey);
      await _service.remove(AppConstants.userImageKey);
      await setLoginState(false);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setLanguage(String languageCode) =>
      _service.setLanguage(languageCode);
  static String getLanguage() => _service.getLanguage();

  static Future<bool> setThemeMode(String themeMode) =>
      _service.setThemeMode(themeMode);
  static String getThemeMode() => _service.getThemeMode();

  static Future<bool> setIsFirstTime(bool isFirstTime) =>
      _service.setIsFirstTime(isFirstTime);
  static bool getIsFirstTime() => _service.getIsFirstTime();

  static Future<bool> setLoginState(bool isLoggedIn) =>
      _service.setBool(AppConstants.isLoggedInKey, isLoggedIn);
  static bool getLoginState() => _service.getBool(AppConstants.isLoggedInKey);

  static Future<bool> isUserLoggedIn() async {
    try {
      final isLoggedIn = getLoginState();
      final hasSecureToken = await hasSecureUserToken();
      return isLoggedIn && hasSecureToken;
    } catch (e) {
      return false;
    }
  }

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

  static bool containsKey(String key) => _service.containsKey(key);
  static Set<String> getKeys() => _service.getKeys();
  static Future<bool> remove(String key) => _service.remove(key);
  static Future<bool> clearAll() => _service.clearAll();
}
