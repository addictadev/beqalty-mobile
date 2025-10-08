import 'package:flutter/material.dart';

/// Controller class for managing authentication form controllers
/// This class provides organized access to all text editing controllers
/// used in authentication flows
class AuthControllers {
  // User registration/login controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Address registration controllers
  final TextEditingController locationController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController buildingNoController = TextEditingController();
  final TextEditingController markerController = TextEditingController();
  final TextEditingController extraDetailsController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController streetController = TextEditingController();

  // Password reset controllers
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController resetConfirmPasswordController =
      TextEditingController();

  // Form keys
  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  /// Dispose all controllers to prevent memory leaks
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    locationController.dispose();
    cityController.dispose();
    apartmentController.dispose();
    buildingNoController.dispose();
    markerController.dispose();
    extraDetailsController.dispose();
    titleController.dispose();
    floorController.dispose();
    streetController.dispose();
    resetPasswordController.dispose();
    resetConfirmPasswordController.dispose();
  }

  /// Clear all form data
  void clearAll() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    locationController.clear();
    cityController.clear();
    apartmentController.clear();
    buildingNoController.clear();
    markerController.clear();
    extraDetailsController.clear();
    titleController.clear();
    floorController.clear();
    streetController.clear();
    resetPasswordController.clear();
    resetConfirmPasswordController.clear();
  }

  /// Clear only user data (name, phone, email, password)
  void clearUserData() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  /// Clear only address data
  void clearAddressData() {
    locationController.clear();
    cityController.clear();
    apartmentController.clear();
    buildingNoController.clear();
    markerController.clear();
    extraDetailsController.clear();
    titleController.clear();
    floorController.clear();
    streetController.clear();
  }

  /// Clear only password reset data
  void clearPasswordResetData() {
    resetPasswordController.clear();
    resetConfirmPasswordController.clear();
  }

  /// Check if user data is empty
  bool get isUserDataEmpty {
    return nameController.text.isEmpty &&
        phoneController.text.isEmpty &&
        emailController.text.isEmpty &&
        passwordController.text.isEmpty &&
        confirmPasswordController.text.isEmpty;
  }

  /// Check if address data is empty
  bool get isAddressDataEmpty {
    return locationController.text.isEmpty &&
        cityController.text.isEmpty &&
        apartmentController.text.isEmpty &&
        buildingNoController.text.isEmpty &&
        markerController.text.isEmpty &&
        extraDetailsController.text.isEmpty &&
        titleController.text.isEmpty &&
        floorController.text.isEmpty &&
        streetController.text.isEmpty;
  }

  /// Check if password reset data is empty
  bool get isPasswordResetDataEmpty {
    return resetPasswordController.text.isEmpty &&
        resetConfirmPasswordController.text.isEmpty;
  }
}
