import 'package:baqalty/features/splash/presentation/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import 'core/navigation_services/navigation_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/deep_link_helper.dart';
import 'core/utils/shared_prefs_helper.dart';
import 'features/cart/presentation/view/shared_cart_screen.dart';

class MyApp extends StatefulWidget {
  factory MyApp() => _instance;
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  bool _isNavigatingToSharedCart = false;
  bool _hasHandledInitialLink = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _initDeepLinks() {
    // Handle deep links when app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri.toString());
      },
      onError: (err) {
        print('Deep link error: $err');
      },
    );

    // Handle deep link when app is launched from a link
    _appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null && !_hasHandledInitialLink) {
        _hasHandledInitialLink = true;
        _handleDeepLink(uri.toString());
      }
    });
  }

  void _handleDeepLink(String link) {
    print('🔗 Received deep link: $link');
    
    final parsedLink = DeepLinkHelper.parseDeepLink(link);
    if (parsedLink != null) {
      print('📱 Parsed deep link: $parsedLink');
      
      if (parsedLink['type'] == 'shared-cart' && parsedLink['id'] != null) {
        // Check if user is logged in before navigating to shared cart
        _checkUserLoginAndNavigate(parsedLink['id']!);
      }
    }
  }

  void _checkUserLoginAndNavigate(String cartId) async {
    try {
      // Import SharedPrefsHelper to check login status
      final isLoggedIn = await SharedPrefsHelper.isUserLoggedIn();
      
      if (isLoggedIn) {
        print('✅ User is logged in, navigating to shared cart');
        _navigateToSharedCart(cartId);
      } else {
        print('ℹ️ User is not logged in, will navigate to shared cart after login');
        // Store the cart ID for later navigation
        _storeCartIdForLaterNavigation(cartId);
      }
    } catch (e) {
      print('❌ Error checking login status: $e');
      // If error, still try to navigate (fallback behavior)
      _navigateToSharedCart(cartId);
    }
  }

  void _storeCartIdForLaterNavigation(String cartId) {
    // Store the cart ID in SharedPreferences for later use
    SharedPrefsHelper.setString('pending_shared_cart_id', cartId);
  }

  void _navigateToSharedCart(String cartId) {
    setState(() {
      _isNavigatingToSharedCart = true;
    });
    
    // Wait for the app to be fully ready
    Future.delayed(const Duration(milliseconds: 3000), () {
      try {
        // Use pushAndRemoveUntil to clear the navigation stack and go directly to shared cart
        NavigationManager.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SharedCartScreen(sharedCartId: cartId),
          ),
          (route) => false, // Remove all previous routes
        );
        print('✅ Navigated to shared cart: $cartId');
      } catch (e) {
        print('❌ Error navigating to shared cart: $e');
        // Try alternative navigation method
        try {
          // Use NavigationManager as fallback
          NavigationManager.navigateTo(
            SharedCartScreen(sharedCartId: cartId),
          );
          print('✅ Fallback navigation successful');
        } catch (fallbackError) {
          print('❌ All navigation methods failed: $fallbackError');
        }
      } finally {
        setState(() {
          _isNavigatingToSharedCart = false;
        });
      }
    });
  }

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
