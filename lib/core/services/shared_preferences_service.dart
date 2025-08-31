import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._();

  static Future<SharedPreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService._();
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Keys for different data types
  static const String _userCategoryKey = 'user_category';
  static const String _userTokenKey = 'user_token';
  static const String _userDataKey = 'user_data';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme_mode';

  // User Category Methods
  Future<bool> setUserCategory(String category) async {
    return await _preferences!.setString(_userCategoryKey, category);
  }

  String? getUserCategory() {
    return _preferences!.getString(_userCategoryKey);
  }

  bool isCompany() {
    final category = getUserCategory();
    return category == AppConstants.userCategoryCompany;
  }

  bool isIndividual() {
    final category = getUserCategory();
    return category == AppConstants.userCategoryIndividual;
  }

  bool hasUserCategory() {
    return getUserCategory() != null;
  }

  Future<bool> clearUserCategory() async {
    return await _preferences!.remove(_userCategoryKey);
  }

  // User Token Methods
  Future<bool> setUserToken(String token) async {
    return await _preferences!.setString(_userTokenKey, token);
  }

  String? getUserToken() {
    return _preferences!.getString(_userTokenKey);
  }

  bool hasUserToken() {
    return getUserToken() != null;
  }

  Future<bool> clearUserToken() async {
    return await _preferences!.remove(_userTokenKey);
  }

  // User Data Methods
  Future<bool> setUserData(Map<String, dynamic> userData) async {
    return await _preferences!.setString(_userDataKey, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final userDataString = _preferences!.getString(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> clearUserData() async {
    return await _preferences!.remove(_userDataKey);
  }

  // First Time User Methods
  Future<bool> setIsFirstTime(bool isFirstTime) async {
    return await _preferences!.setBool(_isFirstTimeKey, isFirstTime);
  }

  bool getIsFirstTime() {
    return _preferences!.getBool(_isFirstTimeKey) ?? true;
  }

  // Language Methods
  Future<bool> setLanguage(String languageCode) async {
    return await _preferences!.setString(_languageKey, languageCode);
  }

  String getLanguage() {
    return _preferences!.getString(_languageKey) ??
        AppConstants.defaultLanguage;
  }

  // Theme Methods
  Future<bool> setThemeMode(String themeMode) async {
    return await _preferences!.setString(_themeKey, themeMode);
  }

  String getThemeMode() {
    return _preferences!.getString(_themeKey) ?? AppConstants.defaultThemeMode;
  }

  // Generic Methods
  Future<bool> setString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _preferences!.getBool(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _preferences!.getInt(key) ?? defaultValue;
  }

  Future<bool> setDouble(String key, double value) async {
    return await _preferences!.setDouble(key, value);
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _preferences!.getDouble(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences!.setStringList(key, value);
  }

  List<String> getStringList(String key) {
    return _preferences!.getStringList(key) ?? [];
  }

  // Clear Methods
  Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  Future<bool> clearAll() async {
    return await _preferences!.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _preferences!.getKeys();
  }
}
