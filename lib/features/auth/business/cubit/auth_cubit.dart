import 'dart:developer';
import 'dart:io';

import 'package:baqalty/core/constants/app_constants.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/custom_new_toast.dart';
import 'package:baqalty/core/utils/shared_prefs_helper.dart';
import 'package:baqalty/features/auth/data/models/forgot_password_request_model.dart';
import 'package:baqalty/features/auth/data/models/login_request_model.dart';
import 'package:baqalty/features/auth/data/models/reset_password_request_model.dart';
import 'package:baqalty/features/auth/data/models/change_password_request_model.dart';
import 'package:baqalty/features/auth/presentation/view/create_new_password_screen.dart';
import 'package:baqalty/features/auth/presentation/view/login_screen.dart';
import 'package:baqalty/features/auth/presentation/view/otp_verification_screen.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../data/models/user_registration_model.dart';
import '../../data/models/address_model.dart';
import '../../data/models/registration_data_model.dart';
import '../../data/models/user_profile_response_model.dart';
import '../../data/services/auth_services.dart';
import '../controllers/auth_controllers.dart';
import '../managers/password_strength_manager.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final AuthControllers _controllers = AuthControllers();
  final PasswordStrengthManager _passwordStrengthManager =
      PasswordStrengthManager();

  AuthCubit(this._authService) : super(AuthInitial());

  @override
  Future<void> close() {
    _controllers.dispose();
    return super.close();
  }

  // Controller getters
  TextEditingController get nameController => _controllers.nameController;
  TextEditingController get phoneController => _controllers.phoneController;
  TextEditingController get emailController => _controllers.emailController;
  TextEditingController get passwordController =>
      _controllers.passwordController;
  TextEditingController get confirmPasswordController =>
      _controllers.confirmPasswordController;

  // Register controllers (aliases for compatibility)
  TextEditingController get registerPasswordController =>
      _controllers.passwordController;
  TextEditingController get registerConfirmPasswordController =>
      _controllers.confirmPasswordController;
  TextEditingController get locationController =>
      _controllers.locationController;
  TextEditingController get cityController => _controllers.cityController;
  TextEditingController get apartmentController =>
      _controllers.apartmentController;
  TextEditingController get buildingNoController =>
      _controllers.buildingNoController;
  TextEditingController get markerController => _controllers.markerController;
  TextEditingController get extraDetailsController =>
      _controllers.extraDetailsController;
  TextEditingController get titleController => _controllers.titleController;
  TextEditingController get floorController => _controllers.floorController;
  TextEditingController get streetController => _controllers.streetController;

  // Password reset controllers
  TextEditingController get resetPasswordController =>
      _controllers.resetPasswordController;
  TextEditingController get resetConfirmPasswordController =>
      _controllers.resetConfirmPasswordController;

  // Form key getters
  GlobalKey<FormState> get userFormKey => _controllers.userFormKey;
  GlobalKey<FormState> get addressFormKey => _controllers.addressFormKey;
  GlobalKey<FormState> get resetPasswordFormKey =>
      _controllers.resetPasswordFormKey;

  // Password strength getters
  bool get isRegisterPasswordValid => _passwordStrengthManager.isPasswordValid;
  String get registerPasswordStrength =>
      _passwordStrengthManager.passwordStrength;
  Color get registerPasswordStrengthColor =>
      _passwordStrengthManager.passwordStrengthColor;
  bool get isRegisterConfirmPasswordValid =>
      _passwordStrengthManager.isConfirmPasswordValid;

  // Password reset strength getters
  bool get isResetPasswordValid => _passwordStrengthManager.isPasswordValid;
  String get resetPasswordStrength => _passwordStrengthManager.passwordStrength;
  Color get resetPasswordStrengthColor =>
      _passwordStrengthManager.passwordStrengthColor;
  bool get isResetConfirmPasswordValid =>
      _passwordStrengthManager.isConfirmPasswordValid;

  bool validateUserForm() {
    return _controllers.userFormKey.currentState?.validate() ?? false;
  }

  bool validateAddressForm() {
    return _controllers.addressFormKey.currentState?.validate() ?? false;
  }

  bool validateResetPasswordForm() {
    return _controllers.resetPasswordFormKey.currentState?.validate() ?? false;
  }

  bool hasAddressData() {
    return !_controllers.isAddressDataEmpty;
  }

  bool hasUserData() {
    return !_controllers.isUserDataEmpty;
  }

  bool hasPasswordResetData() {
    return !_controllers.isPasswordResetDataEmpty;
  }

  void calculateRegisterPasswordStrength(String password) {
    _passwordStrengthManager.updatePasswordStrength(password);
    emit(AuthPasswordStrengthUpdated());
  }

  void validateRegisterPasswordMatching() {
    final confirmPassword = registerConfirmPasswordController.text;
    final password = registerPasswordController.text;
    _passwordStrengthManager.validatePasswordMatching(
      password,
      confirmPassword,
    );
    emit(AuthPasswordStrengthUpdated());
  }

  void calculateResetPasswordStrength(String password) {
    _passwordStrengthManager.updatePasswordStrength(password);
    emit(AuthPasswordStrengthUpdated());
  }

  void validateResetPasswordMatching() {
    final confirmPassword = resetConfirmPasswordController.text;
    final password = resetPasswordController.text;
    _passwordStrengthManager.validatePasswordMatching(
      password,
      confirmPassword,
    );
    emit(AuthPasswordStrengthUpdated());
  }

  void startRegistration() {
    emit(
      RegistrationStepState(
        currentStep: 1,
        registrationData: RegistrationDataModel(
          userData: UserRegistrationModel(
            name: '',
            phone: '',
            email: '',
            password: '',
            confirmPassword: '',
          ),
          addressData: AddressModel(
            lat: 0.0,
            lng: 0.0,
            city: '',
            street: '',
            buildingNo: '',
            floor: '',
            apartment: '',
            title: '',
            marker: '',
            extraDetails: '',
          ),
        ),
      ),
    );
  }

  void updateUserDataFromControllers() {
    if (state is RegistrationStepState) {
      final currentState = state as RegistrationStepState;
      final userData = UserRegistrationModel(
        name: _controllers.nameController.text,
        phone: _controllers.phoneController.text,
        email: _controllers.emailController.text,
        password: _controllers.passwordController.text,
        confirmPassword: _controllers.confirmPasswordController.text,
      );

      emit(
        currentState.copyWith(
          registrationData: currentState.registrationData.copyWith(
            userData: userData,
          ),
        ),
      );
    }
  }

  void updateAddressDataFromControllers() {
    if (state is RegistrationStepState) {
      final currentState = state as RegistrationStepState;

      double lat = _lat;
      double lng = _lng;

      if (lat == 0.0 && lng == 0.0) {
        final locationParts = _controllers.locationController.text.split(',');
        if (locationParts.length == 2) {
          lat = double.tryParse(locationParts[0].trim()) ?? 0.0;
          lng = double.tryParse(locationParts[1].trim()) ?? 0.0;
        }
      }

      final addressData = AddressModel(
        lat: lat,
        lng: lng,
        city: _controllers.cityController.text,
        apartment: _controllers.apartmentController.text,
        buildingNo: _controllers.buildingNoController.text,
        marker: _controllers.markerController.text,
        extraDetails: _controllers.extraDetailsController.text,
        title: _controllers.titleController.text,
        floor: _controllers.floorController.text,
        street: _controllers.streetController.text,
      );

      emit(
        currentState.copyWith(
          registrationData: currentState.registrationData.copyWith(
            addressData: addressData,
          ),
        ),
      );
    }
  }

  void updateUserData(UserRegistrationModel userData) {
    if (state is RegistrationStepState) {
      final currentState = state as RegistrationStepState;
      emit(
        currentState.copyWith(
          registrationData: currentState.registrationData.copyWith(
            userData: userData,
          ),
        ),
      );
    }
  }

  void updateAddressData(AddressModel addressData) {
    if (state is RegistrationStepState) {
      final currentState = state as RegistrationStepState;
      emit(
        currentState.copyWith(
          registrationData: currentState.registrationData.copyWith(
            addressData: addressData,
          ),
        ),
      );
    }
  }

  void nextStep() {
    if (state is RegistrationStepState) {
      final currentState = state as RegistrationStepState;
      if (currentState.currentStep < 2) {
        emit(currentState.copyWith(currentStep: currentState.currentStep + 1));
      }
    }
  }

  void previousStep() {
    if (state is RegistrationStepState) {
      final currentState = state as RegistrationStepState;
      if (currentState.currentStep > 1) {
        emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
      }
    }
  }

  void submitRegistration() async {
    if (state is RegistrationStepState) {
      final currentState = state as RegistrationStepState;

      if (!validateUserForm() || !validateAddressForm()) {
        emit(
          const RegistrationErrorState(
            message: 'Please complete all required fields',
          ),
        );
        return;
      }

      updateUserDataFromControllers();
      updateAddressDataFromControllers();

      if (!currentState.registrationData.isRegistrationComplete) {
        emit(
          const RegistrationErrorState(
            message: 'Please complete all registration steps',
          ),
        );
        return;
      }

      emit(currentState.copyWith(isLoading: true));

      try {
        await Future.delayed(const Duration(seconds: 2));

        emit(RegistrationSuccessState());
      } catch (e) {
        emit(RegistrationErrorState(message: e.toString()));
      }
    }
  }

  void handleNextStep() {
    if (validateUserForm()) {
      updateUserDataFromControllers();
      nextStep();
    }
  }

  void handleBackNavigation() {
    previousStep();
  }

  void updateLocationCoordinates(double lat, double lng) {
    _lat = lat;
    _lng = lng;
  }

  void resetRegistration() {
    emit(AuthInitial());
  }

  double _lat = 0.0;
  double _lng = 0.0;
  String? _resetToken;

  void _saveAllDataToState() {
    updateUserDataFromControllers();
    updateAddressDataFromControllers();
  }

  Future<void> register() async {
    try {
      emit(RegistrationLoadingState());

      _saveAllDataToState();

      RegistrationDataModel registerRequest;

      if (state is RegistrationStepState) {
        final currentState = state as RegistrationStepState;
        registerRequest = currentState.registrationData;
      } else {
        registerRequest = RegistrationDataModel(
          userData: UserRegistrationModel(
            name: _controllers.nameController.text.trim(),
            phone: _controllers.phoneController.text.trim(),
            email: _controllers.emailController.text.trim(),
            password: _controllers.passwordController.text,
            confirmPassword: _controllers.confirmPasswordController.text,
          ),
          addressData: AddressModel(
            apartment: _controllers.apartmentController.text,
            buildingNo: _controllers.buildingNoController.text,
            city: _controllers.cityController.text,
            lat: _lat,
            lng: _lng,
            street: _controllers.streetController.text,
            marker: _controllers.markerController.text,
            extraDetails: _controllers.extraDetailsController.text,
            title: _controllers.titleController.text,
            floor: _controllers.floorController.text,
          ),
        );
      }

      final response = await _authService.register(registerRequest);

      if (response.status) {
        emit(RegistrationSuccessState());
        ToastHelper.showSuccessToast(
          "${response.message!} ${response.data!.data.otp}",
        );
        NavigationManager.navigateTo(
          OtpVerificationScreen(
            fromRegister: 'register',
            phone: _controllers.phoneController.text.trim(),
          ),
        );
      } else {
        emit(RegistrationErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(RegistrationErrorState(message: e.toString()));
    }
  }

  Future<void> verifyRegisterOtp(String otpCode, phone) async {
    try {
      emit(VerifyRegisterOtpLoadingState());
      final response = await _authService.verifyRegisterOtp(
        phone.trim(),
        otpCode.trim(),
      );
      if (response.status) {
        emit(VerifyRegisterOtpSuccessState());
        ToastHelper.showSuccessToast(response.message!);
        SharedPrefsHelper.setUserToken(response.data!.data.accessToken);

        SharedPrefsHelper.setInt(
          AppConstants.userIdKey,
          response.data!.data.user.id,
        );

        SharedPrefsHelper.setString(
          AppConstants.userNameKey,
          response.data!.data.user.name,
        );

        SharedPrefsHelper.setString(
          AppConstants.userPhoneKey,
          response.data!.data.user.phone,
        );

        SharedPrefsHelper.setString(
          AppConstants.userImageKey,
          response.data!.data.user.avatar ?? '',
        );

        SharedPrefsHelper.setString(
          AppConstants.userEmailKey,
          response.data!.data.user.email,
        );
        SharedPrefsHelper.setLoginState(true);
        NavigationManager.navigateToAndFinish(const MainNavigationScreen());
      } else {
        emit(VerifyRegisterOtpErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(VerifyRegisterOtpErrorState(message: e.toString()));
    }
  }

  Future<void> forgotPassword({String? phone}) async {
    try {
      emit(ForgotPasswordLoadingState());

      final phoneToUse = phone ?? _controllers.phoneController.text.trim();

      if (phoneToUse.isEmpty) {
        emit(ForgotPasswordErrorState(message: "Phone number is required"));
        ToastHelper.showErrorToast("Phone number is required");
        return;
      }

      final response = await _authService.forgotPassword(
        ForgotPasswordRequestModel(phone: phoneToUse),
      );

      if (response.status) {
        emit(ForgotPasswordSuccessState());
        ToastHelper.showSuccessToast(
          "${response.message!} ${response.data!.data.otp}",
        );
        // Only navigate if we're not already on OTP screen (for resend functionality)
        if (phone == null) {
          NavigationManager.navigateTo(
            OtpVerificationScreen(phone: phoneToUse),
          );
        }
      } else {
        emit(ForgotPasswordErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(ForgotPasswordErrorState(message: e.toString()));
    }
  }

  Future<void> verifyForgotPasswordOtp(String otpCode, String phone) async {
    try {
      emit(VerifyRegisterOtpLoadingState());
      final response = await _authService.verifyForgotPasswordOtp(
        phone.trim(),
        otpCode.trim(),
      );
      if (response.status) {
        emit(VerifyRegisterOtpSuccessState());
        ToastHelper.showSuccessToast(response.message!);

        _resetToken = response.data!.data.resetToken;
        log('Reset token stored: ${_resetToken?.toString()}');
        SharedPrefsHelper.setUserToken(response.data!.data.resetToken);
        NavigationManager.navigateTo(CreateNewPasswordScreen(phone: phone));
      } else {
        emit(VerifyRegisterOtpErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(VerifyRegisterOtpErrorState(message: e.toString()));
    }
  }

  Future<void> resetPassword({String? phone}) async {
    try {
      emit(ResetPasswordLoadingState());

      var token = await SharedPrefsHelper.getUserToken();

      final phoneToUse = phone ?? _controllers.phoneController.text.trim();
      if (phoneToUse.isEmpty) {
        emit(ResetPasswordErrorState(message: "phone_required".tr()));
        ToastHelper.showErrorToast("phone_required".tr());
        return;
      }

      final request = ResetPasswordRequestModel(
        phone: phoneToUse,
        token: token!,
        password: _controllers.resetPasswordController.text.trim(),
        passwordConfirmation: _controllers.resetConfirmPasswordController.text
            .trim(),
      );

      final response = await _authService.resetPassword(request);

      if (response.status) {
        emit(ResetPasswordSuccessState());
        ToastHelper.showSuccessToast(response.message!);

        _controllers.clearPasswordResetData();
        _resetToken = null;

        NavigationManager.navigateToAndFinish(const LoginScreen());
      } else {
        emit(ResetPasswordErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(ResetPasswordErrorState(message: e.toString()));
      ToastHelper.showErrorToast(e.toString());
    }
  }

  Future<void> login() async {
    try {
      emit(LoginLoadingState());
      final response = await _authService.login(
        LoginRequestModel(
          phone: _controllers.phoneController.text.trim(),
          password: _controllers.passwordController.text,
        ),
      );
      if (response.status) {
        emit(LoginSuccessState());
        ToastHelper.showSuccessToast(response.message!);

        SharedPrefsHelper.setUserToken(response.data!.data.accessToken);

        SharedPrefsHelper.setInt(
          AppConstants.userIdKey,
          response.data!.data.user.id,
        );

        SharedPrefsHelper.setString(
          AppConstants.userNameKey,
          response.data!.data.user.name,
        );

        SharedPrefsHelper.setString(
          AppConstants.userPhoneKey,
          response.data!.data.user.phone,
        );

        SharedPrefsHelper.setString(
          AppConstants.userImageKey,
          response.data!.data.user.avatar ?? '',
        );

        SharedPrefsHelper.setString(
          AppConstants.userEmailKey,
          response.data!.data.user.email,
        );
        SharedPrefsHelper.setLoginState(true);
        NavigationManager.navigateToAndFinish(const MainNavigationScreen());
      } else {
        emit(LoginErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(LoginErrorState(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(LogoutLoadingState());
      final response = await _authService.logout();
      if (response.status) {
        emit(LogoutSuccessState());
        ToastHelper.showSuccessToast(response.message!);
        SharedPrefsHelper.clearAuthData();
        SharedPrefsHelper.clearUserToken();
        NavigationManager.navigateToAndFinish(const LoginScreen());
      } else {
        emit(LogoutErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(LogoutErrorState(message: e.toString()));
    }
  }

  Future<void> getUser() async {
    try {
      emit(GetUserLoadingState());
      final response = await _authService.getUser();
      if (response.status) {
        final userData = response.data!.data;
        _populateUserControllers(userData);
        emit(GetUserSuccessState(user: userData));
      } else {
        emit(GetUserErrorState(message: response.message!));
      }
    } catch (e) {
      emit(GetUserErrorState(message: e.toString()));
    }
  }

  void _populateUserControllers(UserProfileDataModel user) {
    _controllers.nameController.text = user.name;
    _controllers.phoneController.text = user.phone;
    _controllers.emailController.text = user.email;
  }

  Future<void> updateProfile(File? selectedImage) async {
    try {
      emit(UpdateProfileLoadingState());
      final response = await _authService.updateProfile(
        selectedImage,
        _controllers.nameController.text.trim(),
        _controllers.emailController.text.trim(),
        _controllers.phoneController.text.trim(),
      );
      if (response.status) {
        emit(UpdateProfileSuccessState());
        ToastHelper.showSuccessToast(response.message!);
        SharedPrefsHelper.setString(
          AppConstants.userEmailKey,
          response.data!.data.email,
        );
        SharedPrefsHelper.setString(
          AppConstants.userPhoneKey,
          response.data!.data.phone,
        );
        SharedPrefsHelper.setString(
          AppConstants.userNameKey,
          response.data!.data.name,
        );
        SharedPrefsHelper.setString(
          AppConstants.userImageKey,
          response.data!.data.avatar ?? '',
        );

        NavigationManager.pop();
      } else {
        emit(UpdateProfileErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(UpdateProfileErrorState(message: e.toString()));
      ToastHelper.showErrorToast(e.toString());
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      emit(ChangePasswordLoadingState());

      final request = ChangePasswordRequestModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      final response = await _authService.changePassword(request);

      if (response.status) {
        emit(ChangePasswordSuccessState(message: response.data!.message));
        ToastHelper.showSuccessToast(response.data!.message);
        NavigationManager.pop();
      } else {
        emit(ChangePasswordErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(ChangePasswordErrorState(message: e.toString()));
      ToastHelper.showErrorToast(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(DeleteAccountLoadingState());
      final response = await _authService.deleteAccount();
      if (response.status) {
        emit(DeleteAccountSuccessState());
        ToastHelper.showSuccessToast(response.message!);
        SharedPrefsHelper.clearAuthData();
        SharedPrefsHelper.clearUserToken();
        NavigationManager.navigateToAndFinish(const LoginScreen());
      }
    } catch (e) {
      emit(DeleteAccountErrorState(message: e.toString()));
      ToastHelper.showErrorToast(e.toString());
    }
  }
}
