import 'package:baqalty/features/splash/presentation/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;

import 'core/navigation_services/navigation_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/services/shared_preferences_service.dart';

class MyApp extends StatefulWidget {
  factory MyApp() => _instance;
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();
  static final GlobalKey<_MyAppState> _appKey = GlobalKey<_MyAppState>();

  static void refreshLanguage() {
    _appKey.currentState?._loadSavedLanguage();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final preferencesService = await SharedPreferencesService.getInstance();
    final savedLanguage = preferencesService.getLanguage();

    String languageToSet;
    if (savedLanguage == 'device') {
      final deviceLocale = ui.PlatformDispatcher.instance.locale;
      languageToSet = deviceLocale.languageCode;

      if (languageToSet != 'ar' && languageToSet != 'en') {
        languageToSet = 'ar';
      }
    } else {
      languageToSet = savedLanguage;
    }

    setState(() {
      _currentLanguage = languageToSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            theme: AppTheme.createTheme(_currentLanguage),
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
            locale: Locale(_currentLanguage),
            supportedLocales: const [Locale('ar'), Locale('en')],
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
