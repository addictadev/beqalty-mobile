/// Model for reset password request data
/// Contains phone, token, password and password confirmation for password reset
class ResetPasswordRequestModel {
  final String phone;
  final String token;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequestModel({
    required this.phone,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  /// Creates a ResetPasswordRequestModel from JSON data
  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestModel(
      phone: json['phone'] as String,
      token: json['token'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['password_confirmation'] as String,
    );
  }

  /// Converts ResetPasswordRequestModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'token': token,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }

  /// Converts ResetPasswordRequestModel to form data for API requests
  Map<String, dynamic> toFormData() {
    return {
      'phone': phone,
      'token': token,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }

  @override
  String toString() {
    return 'ResetPasswordRequestModel(phone: $phone, token: [HIDDEN], password: [HIDDEN], passwordConfirmation: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResetPasswordRequestModel &&
        other.phone == phone &&
        other.token == token &&
        other.password == password &&
        other.passwordConfirmation == passwordConfirmation;
  }

  @override
  int get hashCode =>
      phone.hashCode ^
      token.hashCode ^
      password.hashCode ^
      passwordConfirmation.hashCode;
}
