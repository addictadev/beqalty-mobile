/// Model for forgot password request data
/// Contains phone number for password reset request
class ForgotPasswordRequestModel {
  final String phone;

  ForgotPasswordRequestModel({required this.phone});

  /// Creates a ForgotPasswordRequestModel from JSON data
  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequestModel(phone: json['phone'] as String);
  }

  /// Converts ForgotPasswordRequestModel to JSON data
  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }

  /// Converts ForgotPasswordRequestModel to form data for API requests
  Map<String, dynamic> toFormData() {
    return {'phone': phone};
  }

  @override
  String toString() {
    return 'ForgotPasswordRequestModel(phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordRequestModel && other.phone == phone;
  }

  @override
  int get hashCode => phone.hashCode;
}
