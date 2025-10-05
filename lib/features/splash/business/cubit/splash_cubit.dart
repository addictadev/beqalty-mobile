import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/utils/shared_prefs_helper.dart';
import 'package:baqalty/core/widgets/force_update_manager.dart';
import 'package:baqalty/core/widgets/custom_update_dialog.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';
import 'package:baqalty/features/onboarding/presentation/view/onboarding_screen.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'dart:developer';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  final ForceUpdateManager _updateManager = ForceUpdateManager(
    // isTestMode: true,
    // testStoreVersion: '2.0.0',
    customUpdateDialog: (context, onUpdateNow, onSkip) =>
        CustomUpdateDialog(onUpdateNow: onUpdateNow, onSkip: onSkip),
  );

  Future<void> initializeSplash() async {
    try {
      emit(SplashLoading());

      final isLoggedIn = await SharedPrefsHelper.isUserLoggedIn();

      await Future.delayed(const Duration(milliseconds: 500));

      if (isLoggedIn) {
        log('✅ User is logged in, navigating to MainNavigationScreen');
        emit(SplashNavigateToMain());
      } else {
        log('ℹ️ User is not logged in, navigating to OnboardingScreen');
        emit(SplashNavigateToOnboarding());
      }
    } catch (e) {
      log('❌ Error checking login status: $e');
      emit(SplashError('Error checking login status: $e'));
    }
  }

  Future<void> initializeUpdateManager() async {
    try {
      await _updateManager.initialize();
      emit(SplashUpdateManagerInitialized());
    } catch (e) {
      log('❌ Error initializing update manager: $e');
      emit(SplashError('Error initializing update manager: $e'));
    }
  }

  void checkForUpdates() {
    try {
      final context = NavigationManager.getContext();
      if (context.mounted) {
        _updateManager.checkForUpdates(context);
        emit(SplashUpdateCheckCompleted());
      } else {
        log('⚠️ Context not available for update check');
        emit(SplashError('Context not available for update check'));
      }
    } catch (e) {
      log('❌ Error checking for updates: $e');
      emit(SplashError('Error checking for updates: $e'));
    }
  }

  void navigateToMain() {
    try {
      log('🚀 Navigating to MainNavigationScreen');
      NavigationManager.navigateToAndFinish(const MainNavigationScreen());
      emit(SplashNavigationCompleted());
    } catch (e) {
      log('❌ Error navigating to main screen: $e');
      emit(SplashError('Error navigating to main screen: $e'));
    }
  }

  void navigateToOnboarding() {
    try {
      log('🚀 Navigating to OnboardingScreen');
      NavigationManager.navigateToAndFinish(const OnboardingScreen());
      emit(SplashNavigationCompleted());
    } catch (e) {
      log('❌ Error navigating to onboarding screen: $e');
      emit(SplashError('Error navigating to onboarding screen: $e'));
    }
  }

  void handleError(String error) {
    log('⚠️ Handling error: $error');
    emit(SplashError(error));
  }

  void reset() {
    emit(SplashInitial());
  }

  void handleReturnFromStore() {
    try {
      log('🔄 User returned from store - checking for updates again');
      final context = NavigationManager.getContext();
      if (context.mounted) {
        _updateManager.checkForUpdates(context);
        emit(SplashUpdateCheckCompleted());
      }
    } catch (e) {
      log('❌ Error handling return from store: $e');
      emit(SplashError('Error handling return from store: $e'));
    }
  }

  /// Reset the update dialog state to allow showing dialog again
  void resetUpdateDialogState() {
    try {
      log('🔄 Resetting update dialog state in cubit');
      // Reset the force update manager's dialog state
      _updateManager.resetDialogState();
      log('✅ Update dialog state reset successfully');
    } catch (e) {
      log('❌ Error resetting update dialog state: $e');
    }
  }

  /// Force trigger update check for testing
  void forceUpdateCheck() {
    try {
      log('🧪 Force triggering update check for testing');
      final context = NavigationManager.getContext();
      if (context.mounted) {
        _updateManager.resetDialogState();
        _updateManager.checkForUpdates(context);
        emit(SplashUpdateCheckCompleted());
      } else {
        log('⚠️ Context not available for force update check');
        emit(SplashError('Context not available for force update check'));
      }
    } catch (e) {
      log('❌ Error in force update check: $e');
      emit(SplashError('Error in force update check: $e'));
    }
  }
}
