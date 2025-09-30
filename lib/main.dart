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

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);

        log('Flutter Error: ${details.exception}');
        log('Stack Trace: ${details.stack}');
      };

      try {
        await LocalizeAndTranslate.init(
          assetLoader: const AssetLoaderRootBundleJson('assets/translations/'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          defaultType: LocalizationDefaultType.device,
        );
      } catch (e) {
        log('Localization initialization failed: $e');
      }

      try {
        await ServiceLocator.initialize();
      } catch (e) {
        log('Service locator initialization failed: $e');
      }

      String languageToSet = 'ar';
      try {
        final preferencesService = await SharedPreferencesService.getInstance();
        final savedLanguage = preferencesService.getLanguage();

        if (savedLanguage == 'device') {
          final deviceLocale = ui.PlatformDispatcher.instance.locale;
          languageToSet = deviceLocale.languageCode;

          if (languageToSet != 'ar' && languageToSet != 'en') {
            languageToSet = 'ar';
          }
        } else {
          languageToSet = savedLanguage;
        }
      } catch (e) {
        log('Language preference loading failed: $e');
      }

      try {
        await LocalizeAndTranslate.setLanguageCode(languageToSet);
      } catch (e) {
        log('Language setting failed: $e');
      }

      try {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } catch (e) {
        log('Orientation setting failed: $e');
      }

      runApp(Phoenix(child: MyApp()));
    },
    (error, stackTrace) {
      log('Uncaught error: $error');
      log('Stack trace: $stackTrace');
    },
  );
}
