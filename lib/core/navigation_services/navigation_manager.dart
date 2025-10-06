import 'package:flutter/material.dart';
import 'package:palestine_console/palestine_console.dart';
import '../services/app_control_service.dart';

class NavigationManager {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?>? navigateTo<T>(Widget screen, {bool replace = false}) {
    Print.green('Navigating to => $screen');

    if (replace) {
      return navigatorKey.currentState?.pushReplacement(
        FadePageRoute<T>(builder: (_) => screen),
      );
    } else {
      return navigatorKey.currentState?.push<T>(
        FadePageRoute<T>(builder: (_) => screen),
      );
    }
  }

  static Future? navigateToAndFinish(Widget screen) {
    Print.green('Navigating and finishing to => $screen');
    return navigatorKey.currentState?.pushAndRemoveUntil(
      FadePageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  static void pop<T extends Object>([T? result]) {
    navigatorKey.currentState?.pop<T>(result);
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  static BuildContext getContext() {
    return navigatorKey.currentState!.overlay!.context;
  }

  /// Moves the app to background instead of closing it
  /// Preserves app state and allows user to return to the same screen
  static Future<void> moveToBackground() async {
    Print.cyan('Moving app to background...');
    await AppControlService.moveToBackground();
  }

  /// Completely exits the app (closes it)
  /// Use this when you want to close the app entirely
  static Future<void> exitApp() async {
    Print.cyan('Exiting app completely...');
    await AppControlService.exitApp();
  }

  /// Smart exit that moves to background on Android and closes on other platforms
  static Future<void> smartExit() async {
    Print.cyan('Smart exit - moving to background or closing app...');
    await AppControlService.smartExit();
  }

  /// Shows a dialog to let user choose between background or exit
  static Future<void> showExitDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('What would you like to do?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                moveToBackground();
              },
              child: Text('Minimize to Background'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                exitApp();
              },
              child: Text('Close App'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  FadePageRoute({required this.builder})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => builder(context),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) => FadeTransition(opacity: animation, child: child),
      );
}
