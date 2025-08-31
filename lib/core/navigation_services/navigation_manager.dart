import 'package:flutter/material.dart';
import 'package:palestine_console/palestine_console.dart';

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
