import 'package:baqalty/features/splash/presentation/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

import 'core/navigation_services/navigation_manager.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  factory MyApp() => _instance;
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: AppTheme.createTheme(LocalizeAndTranslate.getLanguageCode()),
            builder: (BuildContext context, Widget? child) {
              child = LocalizeAndTranslate.directionBuilder(context, child);

              child = MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child,
              );
              return child;
            },
            title: "Baqalty",

            navigatorKey: NavigationManager.navigatorKey,
            localizationsDelegates: LocalizeAndTranslate.delegates,
            locale: Locale(LocalizeAndTranslate.getLanguageCode()),
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ], // Arabic first
            onGenerateRoute: (settings) {
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FadeTransition(
                    opacity: animation,
                    child: const SplashScreen(),
                  );
                },
              );
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
