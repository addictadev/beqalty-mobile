/// Model for change password request data
/// Contains old password, new password and new password confirmation for password change
class ChangePasswordRequestModel {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  /// Creates a ChangePasswordRequestModel from JSON data
  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequestModel(
      oldPassword: json['old_password'] as String,
      newPassword: json['new_password'] as String,
      newPasswordConfirmation: json['new_password_confirmation'] as String,
    );
  }

  /// Converts ChangePasswordRequestModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };
  }

  /// Converts ChangePasswordRequestModel to form data for API requests
  Map<String, dynamic> toFormData() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };
  }

  @override
  String toString() {
    return 'ChangePasswordRequestModel(oldPassword: [HIDDEN], newPassword: [HIDDEN], newPasswordConfirmation: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChangePasswordRequestModel &&
        other.oldPassword == oldPassword &&
        other.newPassword == newPassword &&
        other.newPasswordConfirmation == newPasswordConfirmation;
  }

  @override
  int get hashCode =>
      oldPassword.hashCode ^
      newPassword.hashCode ^
      newPasswordConfirmation.hashCode;
}
