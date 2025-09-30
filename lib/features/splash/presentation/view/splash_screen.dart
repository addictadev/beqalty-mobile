import 'dart:developer';

import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/features/splash/business/cubit/splash_cubit.dart';
import 'package:baqalty/features/splash/business/cubit/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: const SplashScreenBody(),
    );
  }
}

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // App state tracking
  bool _hasShownUpdateDialog = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupAppLifecycleObserver();
    _startSplashLogic();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  void _setupAppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        log('📱 App went to background/inactive');
        break;
      case AppLifecycleState.resumed:
        log('📱 App came to foreground');
        _handleAppResumed();
        break;
      case AppLifecycleState.detached:
        log('📱 App detached');
        break;
      case AppLifecycleState.hidden:
        log('📱 App hidden');
        break;
    }
  }

  void _handleAppResumed() {
    // If app was in background and we had shown update dialog before,
    // check for updates again when user returns
    if (_hasShownUpdateDialog && mounted) {
      log('🔄 App resumed - user likely returned from store');
      log('📱 Has shown update dialog: $_hasShownUpdateDialog');
      log('📱 App mounted: $mounted');

      // Wait a moment for the app to fully resume
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          log('🔄 Starting update check after app resume');
          // Reset the dialog flag to allow showing update dialog again
          context.read<SplashCubit>().resetUpdateDialogState();
          // Check for updates again
          context.read<SplashCubit>().checkForUpdates();
        } else {
          log('⚠️ App no longer mounted after delay');
        }
      });
    } else {
      log(
        '📱 App resumed but no update dialog was shown before or app not mounted',
      );
      log('📱 Has shown update dialog: $_hasShownUpdateDialog');
      log('📱 App mounted: $mounted');
    }
  }

  void _startSplashLogic() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        context.read<SplashCubit>().initializeSplash();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToMain) {
          context.read<SplashCubit>().initializeUpdateManager();
          context.read<SplashCubit>().checkForUpdates();
          context.read<SplashCubit>().navigateToMain();
        } else if (state is SplashNavigateToOnboarding) {
          context.read<SplashCubit>().initializeUpdateManager();
          context.read<SplashCubit>().checkForUpdates();
          context.read<SplashCubit>().navigateToOnboarding();
        } else if (state is SplashError) {
          context.read<SplashCubit>().navigateToOnboarding();
        } else if (state is SplashUpdateCheckCompleted) {
          // Track that we've shown update dialog
          _hasShownUpdateDialog = true;
          log('📱 Update check completed - dialog shown');
        } else if (state is SplashNavigationCompleted) {
          // Navigation completed, reset the flag
          _hasShownUpdateDialog = false;
          log('📱 Navigation completed - resetting update dialog flag');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: CustomSvgImage(
                assetName: AppAssets.splashIcon,
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
