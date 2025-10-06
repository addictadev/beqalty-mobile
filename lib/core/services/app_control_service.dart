import 'dart:developer';

import 'package:flutter/services.dart';

/// Service to control app lifecycle behavior
/// Allows moving app to background instead of closing it completely
class AppControlService {
  static const platform = MethodChannel("app/control");

  /// Moves the app to background (like pressing home button)
  /// Preserves app state and allows user to return to the same screen
  static Future<void> moveToBackground() async {
    try {
      await platform.invokeMethod("moveToBackground");
    } on PlatformException catch (e) {
      log("Failed to move app to background: ${e.message}");
      // Fallback to SystemNavigator.pop() if method channel fails
      SystemNavigator.pop();
    }
  }

  /// Completely exits the app (closes it)
  /// Use this when you want to close the app entirely
  static Future<void> exitApp() async {
    try {
      await platform.invokeMethod("exitApp");
    } on PlatformException catch (e) {
      log("Failed to exit app: ${e.message}");
      // Fallback to SystemNavigator.pop() if method channel fails
      SystemNavigator.pop();
    }
  }

  /// Smart navigation that moves to background on Android
  /// and uses SystemNavigator.pop() on other platforms
  static Future<void> smartExit() async {
    try {
      // Try to move to background first (Android only)
      await platform.invokeMethod("moveToBackground");
    } on PlatformException {
      // If method channel is not available (iOS/other platforms), use SystemNavigator
      SystemNavigator.pop();
    }
  }
}
