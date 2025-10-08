import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

/// Manager class for handling password strength calculations and validation
/// This class provides centralized password strength logic that can be used
/// across different authentication screens
class PasswordStrengthManager {
  // Password strength properties
  bool _isPasswordValid = false;
  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;
  bool _isConfirmPasswordValid = false;

  // Getters for password strength
  bool get isPasswordValid => _isPasswordValid;
  String get passwordStrength => _passwordStrength;
  Color get passwordStrengthColor => _passwordStrengthColor;
  bool get isConfirmPasswordValid => _isConfirmPasswordValid;

  /// Calculate password strength based on various criteria
  /// Returns a strength score from 0-5
  int calculatePasswordStrengthScore(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check (8+ characters)
    if (password.length >= 8) strength++;

    // Uppercase letter check
    if (password.contains(RegExp(r'[A-Z]'))) strength++;

    // Lowercase letter check
    if (password.contains(RegExp(r'[a-z]'))) strength++;

    // Number check
    if (password.contains(RegExp(r'[0-9]'))) strength++;

    // Special character check
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength;
  }

  /// Get password strength text based on score
  String getPasswordStrengthText(int strength) {
    if (strength == 0) return '';
    if (strength <= 2) return 'weak'.tr();
    if (strength <= 3) return 'medium'.tr();
    return 'strong'.tr();
  }

  /// Get password strength color based on score
  Color getPasswordStrengthColor(int strength) {
    if (strength == 0) return Colors.grey;
    if (strength <= 2) return Colors.red;
    if (strength <= 3) return Colors.orange;
    return Colors.green;
  }

  /// Get password strength icon based on score
  IconData getPasswordStrengthIcon(int strength) {
    if (strength == 0) return Icons.lock_outline;
    if (strength <= 2) return Icons.error;
    if (strength <= 3) return Icons.warning;
    return Icons.check_circle;
  }

  /// Update password strength properties
  void updatePasswordStrength(String password) {
    final strength = calculatePasswordStrengthScore(password);

    _isPasswordValid = password.isNotEmpty && password.length >= 6;
    _passwordStrength = getPasswordStrengthText(strength);
    _passwordStrengthColor = getPasswordStrengthColor(strength);
  }

  /// Validate password matching
  void validatePasswordMatching(String password, String confirmPassword) {
    _isConfirmPasswordValid =
        confirmPassword.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword == password;
  }

  /// Get password requirements as a list
  List<PasswordRequirement> getPasswordRequirements(String password) {
    return [
      PasswordRequirement(
        text: 'password_min_length'.tr(),
        isMet: password.length >= 8,
      ),
      PasswordRequirement(
        text: 'password_uppercase'.tr(),
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRequirement(
        text: 'password_lowercase'.tr(),
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      PasswordRequirement(
        text: 'password_number'.tr(),
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      PasswordRequirement(
        text: 'password_special_char'.tr(),
        isMet: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];
  }

  /// Check if password meets all requirements
  bool isPasswordStrong(String password) {
    final requirements = getPasswordRequirements(password);
    return requirements.every((requirement) => requirement.isMet);
  }

  /// Reset all password strength properties
  void reset() {
    _isPasswordValid = false;
    _passwordStrength = '';
    _passwordStrengthColor = Colors.grey;
    _isConfirmPasswordValid = false;
  }
}

/// Class representing a password requirement
class PasswordRequirement {
  final String text;
  final bool isMet;

  PasswordRequirement({required this.text, required this.isMet});
}
