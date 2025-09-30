import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashNavigateToMain extends SplashState {
  const SplashNavigateToMain();
}

class SplashNavigateToOnboarding extends SplashState {
  const SplashNavigateToOnboarding();
}

class SplashUpdateManagerInitialized extends SplashState {
  const SplashUpdateManagerInitialized();
}

class SplashUpdateCheckCompleted extends SplashState {
  const SplashUpdateCheckCompleted();
}

class SplashNavigationCompleted extends SplashState {
  const SplashNavigationCompleted();
}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
