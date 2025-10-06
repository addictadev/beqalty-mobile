import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/custom_new_toast.dart';
import 'package:baqalty/features/auth/presentation/view/login_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../data/models/user_registration_model.dart';
import '../../data/models/address_model.dart';
import '../../data/models/registration_data_model.dart';
import '../../data/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _markerController = TextEditingController();
  final TextEditingController _extraDetailsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  AuthCubit(this._authService) : super(AuthInitial());

  @override
  Future<void> close() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _apartmentController.dispose();
    _buildingNoController.dispose();
    _markerController.dispose();
    _extraDetailsController.dispose();
    _titleController.dispose();
    _floorController.dispose();
    _streetController.dispose();
    return super.close();
  }

  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  // Register controllers (aliases for compatibility)
  TextEditingController get registerPasswordController => _passwordController;
  TextEditingController get registerConfirmPasswordController =>
      _confirmPasswordController;
  TextEditingController get locationController => _locationController;
  TextEditingController get cityController => _cityController;
  TextEditingController get apartmentController => _apartmentController;
  TextEditingController get buildingNoController => _buildingNoController;
  TextEditingController get markerController => _markerController;
  TextEditingController get extraDetailsController => _extraDetailsController;
  TextEditingController get titleController => _titleController;
  TextEditingController get floorController => _floorController;
  TextEditingController get streetController => _streetController;

  GlobalKey<FormState> get userFormKey => _userFormKey;
  GlobalKey<FormState> get addressFormKey => _addressFormKey;

  // Password strength getters
  bool get isRegisterPasswordValid => _isRegisterPasswordValid;
  String get registerPasswordStrength => _registerPasswordStrength;
  Color get registerPasswordStrengthColor => _registerPasswordStrengthColor;
  bool get isRegisterConfirmPasswordValid => _isRegisterConfirmPasswordValid;

  bool validateUserForm() {
    return _userFormKey.currentState?.validate() ?? false;
  }

  bool validateAddressForm() {
    return _addressFormKey.currentState?.validate() ?? false;
  }

  bool hasAddressData() {
    return _locationController.text.isNotEmpty ||
        _cityController.text.isNotEmpty ||
        _streetController.text.isNotEmpty ||
        _buildingNoController.text.isNotEmpty ||
        _floorController.text.isNotEmpty ||
        _apartmentController.text.isNotEmpty ||
        _titleController.text.isNotEmpty ||
        _markerController.text.isNotEmpty ||
        _extraDetailsController.text.isNotEmpty;
  }

  bool hasUserData() {
    return _nameController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;
  }

  void calculateRegisterPasswordStrength(String password) {
    bool isValid = password.isNotEmpty && password.length >= 6;

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    _isRegisterPasswordValid = isValid;

    if (password.isEmpty) {
      _registerPasswordStrength = '';
      _registerPasswordStrengthColor = Colors.grey;
    } else if (strength <= 2) {
      _registerPasswordStrength = 'weak'.tr();
      _registerPasswordStrengthColor = Colors.red;
    } else if (strength <= 3) {
      _registerPasswordStrength = 'medium'.tr();
      _registerPasswordStrengthColor = Colors.orange;
    } else {
      _registerPasswordStrength = 'strong'.tr();
      _registerPasswordStrengthColor = Colors.green;
    }

    emit(AuthPasswordStrengthUpdated());
  }

  void validateRegisterPasswordMatching() {
    final confirmPassword = registerConfirmPasswordController.text;
    final password = registerPasswordController.text;

    _isRegisterConfirmPasswordValid =
        confirmPassword.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword == password;

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
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
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
        final locationParts = _locationController.text.split(',');
        if (locationParts.length == 2) {
          lat = double.tryParse(locationParts[0].trim()) ?? 0.0;
          lng = double.tryParse(locationParts[1].trim()) ?? 0.0;
        }
      }

      final addressData = AddressModel(
        lat: lat,
        lng: lng,
        city: _cityController.text,
        apartment: _apartmentController.text,
        buildingNo: _buildingNoController.text,
        marker: _markerController.text,
        extraDetails: _extraDetailsController.text,
        title: _titleController.text,
        floor: _floorController.text,
        street: _streetController.text,
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

  bool _isRegisterPasswordValid = false;
  String _registerPasswordStrength = '';
  Color _registerPasswordStrengthColor = Colors.grey;
  bool _isRegisterConfirmPasswordValid = false;

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
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          ),
          addressData: AddressModel(
            apartment: _apartmentController.text,
            buildingNo: _buildingNoController.text,
            city: _cityController.text,
            lat: _lat,
            lng: _lng,
            street: _streetController.text,
            marker: _markerController.text,
            extraDetails: _extraDetailsController.text,
            title: _titleController.text,
            floor: _floorController.text,
          ),
        );
      }

      final response = await _authService.register(registerRequest);

      if (response.status) {
        emit(RegistrationSuccessState());
        ToastHelper.showSuccessToast(response.message!);
        NavigationManager.navigateTo(const LoginScreen());
      } else {
        emit(RegistrationErrorState(message: response.message!));
        ToastHelper.showErrorToast(response.message!);
      }
    } catch (e) {
      emit(RegistrationErrorState(message: e.toString()));
    }
  }
}
