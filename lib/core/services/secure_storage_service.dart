import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    webOptions: WebOptions(
      dbName: 'secure_storage',
      publicKey: 'secure_storage_key',
    ),
  );

  // Token Storage Keys
  static const String _userTokenKey = 'user_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  /// Store user authentication token securely
  static Future<void> storeUserToken(String token) async {
    try {
      await _storage.write(key: _userTokenKey, value: token);
      log('✅ User token stored securely');
    } catch (e) {
      log('❌ Error storing user token: $e');
      rethrow;
    }
  }

  /// Retrieve user authentication token
  static Future<String?> getUserToken() async {
    try {
      final token = await _storage.read(key: _userTokenKey);
      if (token != null) {
        log('✅ User token retrieved successfully');
      } else {
        log('⚠️ No user token found');
      }
      return token;
    } catch (e) {
      log('❌ Error retrieving user token: $e');
      return null;
    }
  }

  /// Store refresh token securely
  static Future<void> storeRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      log('✅ Refresh token stored securely');
    } catch (e) {
      log('❌ Error storing refresh token: $e');
      rethrow;
    }
  }

  /// Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      if (refreshToken != null) {
        log('✅ Refresh token retrieved successfully');
      } else {
        log('⚠️ No refresh token found');
      }
      return refreshToken;
    } catch (e) {
      log('❌ Error retrieving refresh token: $e');
      return null;
    }
  }

  /// Store token expiry timestamp
  static Future<void> storeTokenExpiry(DateTime expiry) async {
    try {
      final expiryString = expiry.toIso8601String();
      await _storage.write(key: _tokenExpiryKey, value: expiryString);
      log('✅ Token expiry stored: $expiryString');
    } catch (e) {
      log('❌ Error storing token expiry: $e');
      rethrow;
    }
  }

  /// Get token expiry timestamp
  static Future<DateTime?> getTokenExpiry() async {
    try {
      final expiryString = await _storage.read(key: _tokenExpiryKey);
      if (expiryString != null) {
        final expiry = DateTime.parse(expiryString);
        log('✅ Token expiry retrieved: $expiry');
        return expiry;
      } else {
        log('⚠️ No token expiry found');
        return null;
      }
    } catch (e) {
      log('❌ Error retrieving token expiry: $e');
      return null;
    }
  }

  /// Check if token is expired
  static Future<bool> isTokenExpired() async {
    try {
      final expiry = await getTokenExpiry();
      if (expiry == null) return true;

      final now = DateTime.now();
      final isExpired = now.isAfter(expiry);

      if (isExpired) {
        log('⚠️ Token is expired');
      } else {
        log('✅ Token is still valid');
      }

      return isExpired;
    } catch (e) {
      log('❌ Error checking token expiry: $e');
      return true;
    }
  }

  /// Clear all authentication data
  static Future<void> clearAuthData() async {
    try {
      await _storage.delete(key: _userTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _tokenExpiryKey);
      log('✅ All authentication data cleared');
    } catch (e) {
      log('❌ Error clearing authentication data: $e');
      rethrow;
    }
  }

  /// Store any sensitive data with custom key
  static Future<void> storeSecureData(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      log('✅ Secure data stored for key: $key');
    } catch (e) {
      log('❌ Error storing secure data: $e');
      rethrow;
    }
  }

  /// Retrieve sensitive data with custom key
  static Future<String?> getSecureData(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value != null) {
        log('✅ Secure data retrieved for key: $key');
      } else {
        log('⚠️ No secure data found for key: $key');
      }
      return value;
    } catch (e) {
      log('❌ Error retrieving secure data: $e');
      return null;
    }
  }

  /// Delete specific secure data
  static Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(key: key);
      log('✅ Secure data deleted for key: $key');
    } catch (e) {
      log('❌ Error deleting secure data: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final token = await getUserToken();
      if (token == null || token.isEmpty) {
        log('❌ No authentication token found');
        return false;
      }

      final isExpired = await isTokenExpired();
      if (isExpired) {
        log('❌ Token is expired');
        return false;
      }

      log('✅ User is authenticated');
      return true;
    } catch (e) {
      log('❌ Error checking authentication status: $e');
      return false;
    }
  }

  /// Get authentication status with details
  static Future<Map<String, dynamic>> getAuthStatus() async {
    try {
      final token = await getUserToken();
      final refreshToken = await getRefreshToken();
      final expiry = await getTokenExpiry();
      final isExpired = await isTokenExpired();

      return {
        'hasToken': token != null && token.isNotEmpty,
        'hasRefreshToken': refreshToken != null && refreshToken.isNotEmpty,
        'tokenExpiry': expiry?.toIso8601String(),
        'isExpired': isExpired,
        'isAuthenticated': token != null && token.isNotEmpty && !isExpired,
      };
    } catch (e) {
      log('❌ Error getting auth status: $e');
      return {
        'hasToken': false,
        'hasRefreshToken': false,
        'tokenExpiry': null,
        'isExpired': true,
        'isAuthenticated': false,
      };
    }
  }
}
