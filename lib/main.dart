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
      };

      await LocalizeAndTranslate.init(
        assetLoader: const AssetLoaderRootBundleJson('assets/translations/'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        defaultType: LocalizationDefaultType.device,
      );

      await ServiceLocator.initialize();

      final preferencesService = await SharedPreferencesService.getInstance();
      final savedLanguage = preferencesService.getLanguage();

      String languageToSet;
      if (savedLanguage == 'device') {
        final deviceLocale = ui.PlatformDispatcher.instance.locale;
        languageToSet = deviceLocale.languageCode;

        if (languageToSet != 'ar' && languageToSet != 'en') {
          languageToSet = 'en';
        }
      } else {
        languageToSet = savedLanguage;
      }

      await LocalizeAndTranslate.setLanguageCode(languageToSet);

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    runApp(Phoenix(child: MyApp()));
    },
    (error, stackTrace) {
      log('Caught error: $error');
      log('Stack trace: $stackTrace');
    },
  );
}
