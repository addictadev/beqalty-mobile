/// Model for login request data
/// Contains phone number and password for user authentication
class LoginRequestModel {
  final String phone;
  final String password;

  LoginRequestModel({required this.phone, required this.password});

  /// Creates a LoginRequestModel from JSON data
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      phone: json['phone'] as String,
      password: json['password'] as String,
    );
  }

  /// Converts LoginRequestModel to JSON data
  Map<String, dynamic> toJson() {
    return {'phone': phone, 'password': password};
  }

  /// Converts LoginRequestModel to form data for API requests
  Map<String, dynamic> toFormData() {
    return {'phone': phone, 'password': password};
  }

  @override
  String toString() {
    return 'LoginRequestModel(phone: $phone, password: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequestModel &&
        other.phone == phone &&
        other.password == password;
  }

  @override
  int get hashCode => phone.hashCode ^ password.hashCode;
}
