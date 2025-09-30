import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'core/di/service_locator.dart';
import 'core/services/shared_preferences_service.dart';
import 'my_app.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Enhanced error handling for better UX
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);
        // Log to crash reporting service in production
        log('Flutter Error: ${details.exception}');
        log('Stack Trace: ${details.stack}');
      };

      // Initialize localization with error handling
      try {
        await LocalizeAndTranslate.init(
          assetLoader: const AssetLoaderRootBundleJson('assets/translations/'),
          supportedLocales: const [Locale('en'), Locale('ar')],
          defaultType: LocalizationDefaultType.device,
        );
      } catch (e) {
        log('Localization initialization failed: $e');
        // Continue with default language
      }

      // Initialize services with error handling
      try {
        await ServiceLocator.initialize();
      } catch (e) {
        log('Service locator initialization failed: $e');
        // Continue without some services
      }

      // Handle language selection with better error handling
      String languageToSet = 'en'; // Default fallback
      try {
        final preferencesService = await SharedPreferencesService.getInstance();
        final savedLanguage = preferencesService.getLanguage();

        if (savedLanguage == 'device') {
          final deviceLocale = ui.PlatformDispatcher.instance.locale;
          languageToSet = deviceLocale.languageCode;

          if (languageToSet != 'ar' && languageToSet != 'en') {
            languageToSet = 'en';
          }
        } else {
          languageToSet = savedLanguage;
        }
      } catch (e) {
        log('Language preference loading failed: $e');
        // Use default language
      }

      try {
        await LocalizeAndTranslate.setLanguageCode(languageToSet);
      } catch (e) {
        log('Language setting failed: $e');
        // Continue with default language
      }

      // Set preferred orientations with error handling
      try {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } catch (e) {
        log('Orientation setting failed: $e');
        // Continue without orientation restriction
      }

      runApp(Phoenix(child: MyApp()));
    },
    (error, stackTrace) {
      log('Uncaught error: $error');
      log('Stack trace: $stackTrace');
      // In production, send to crash reporting service
    },
  );
}
