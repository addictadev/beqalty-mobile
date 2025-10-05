class RegisterResponseModel {
  final bool success;
  final String message;
  final int code;
  final RegisterResponseDataModel data;
  final String timestamp;

  RegisterResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: RegisterResponseDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }
}

class RegisterResponseDataModel {
  final UserResponseModel user;

  RegisterResponseDataModel({required this.user});

  factory RegisterResponseDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDataModel(
      user: UserResponseModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson()};
  }
}

class UserResponseModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  UserResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
