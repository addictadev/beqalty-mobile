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
