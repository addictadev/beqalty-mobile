part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class RegistrationStepState extends AuthState {
  final int currentStep;
  final RegistrationDataModel registrationData;
  final bool isLoading;

  const RegistrationStepState({
    required this.currentStep,
    required this.registrationData,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [currentStep, registrationData, isLoading];

  RegistrationStepState copyWith({
    int? currentStep,
    RegistrationDataModel? registrationData,
    bool? isLoading,
  }) {
    return RegistrationStepState(
      currentStep: currentStep ?? this.currentStep,
      registrationData: registrationData ?? this.registrationData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final class RegistrationLoadingState extends AuthState {}

final class RegistrationSuccessState extends AuthState {}

final class RegistrationErrorState extends AuthState {
  final String message;

  const RegistrationErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthPasswordStrengthUpdated extends AuthState {}

final class AuthLoading extends AuthState {}

final class LoginLoadingState extends AuthState {}

final class LoginSuccessState extends AuthState {}

final class LoginErrorState extends AuthState {
  final String message;

  const LoginErrorState({required this.message});
}

final class LogoutLoadingState extends AuthState {}

final class LogoutSuccessState extends AuthState {}

final class LogoutErrorState extends AuthState {
  final String message;

  const LogoutErrorState({required this.message});
}

final class GetUserLoadingState extends AuthState {}

final class GetUserSuccessState extends AuthState {
  final UserProfileDataModel user;
  const GetUserSuccessState({required this.user});
}

final class GetUserErrorState extends AuthState {
  final String message;

  const GetUserErrorState({required this.message});
}

final class VerifyRegisterOtpLoadingState extends AuthState {}

final class VerifyRegisterOtpSuccessState extends AuthState {}

final class VerifyRegisterOtpErrorState extends AuthState {
  final String message;

  const VerifyRegisterOtpErrorState({required this.message});
}

final class ForgotPasswordLoadingState extends AuthState {}

final class ForgotPasswordSuccessState extends AuthState {}

final class ForgotPasswordErrorState extends AuthState {
  final String message;

  const ForgotPasswordErrorState({required this.message});
}

final class ResetPasswordLoadingState extends AuthState {}

final class ResetPasswordSuccessState extends AuthState {}

final class ResetPasswordErrorState extends AuthState {
  final String message;

  const ResetPasswordErrorState({required this.message});
}

final class UpdateProfileLoadingState extends AuthState {}

final class UpdateProfileSuccessState extends AuthState {}

final class UpdateProfileErrorState extends AuthState {
  final String message;

  const UpdateProfileErrorState({required this.message});
}

