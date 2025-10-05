class UserRegistrationModel {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  const UserRegistrationModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }

  UserRegistrationModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return UserRegistrationModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
