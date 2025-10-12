/// Model for profile update response data
/// Contains the complete response structure from the POST /api/v1/profile endpoint
class ProfileUpdateResponseModel {
  final bool success;
  final String message;
  final int code;
  final ProfileUpdateDataModel data;

  ProfileUpdateResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  /// Creates a ProfileUpdateResponseModel from JSON data
  factory ProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: ProfileUpdateDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  /// Converts ProfileUpdateResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
    };
  }

  @override
  String toString() {
    return 'ProfileUpdateResponseModel(success: $success, message: $message, code: $code, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileUpdateResponseModel &&
        other.success == success &&
        other.message == message &&
        other.code == code &&
        other.data == data;
  }

  @override
  int get hashCode =>
      success.hashCode ^ message.hashCode ^ code.hashCode ^ data.hashCode;
}

/// Model for the profile update data section
/// Contains updated user information returned from the profile update endpoint
class ProfileUpdateDataModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> addresses; // Array of address objects (can be empty)

  ProfileUpdateDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.addresses,
  });

  /// Creates a ProfileUpdateDataModel from JSON data
  factory ProfileUpdateDataModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateDataModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      addresses: json['addresses'] as List<dynamic>? ?? [],
    );
  }

  /// Converts ProfileUpdateDataModel to JSON data
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
      'addresses': addresses,
    };
  }

  /// Creates a copy of this model with updated fields
  ProfileUpdateDataModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    List<dynamic>? addresses,
  }) {
    return ProfileUpdateDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  String toString() {
    return 'ProfileUpdateDataModel(id: $id, name: $name, email: $email, phone: $phone, avatar: $avatar, emailVerifiedAt: $emailVerifiedAt, createdAt: $createdAt, updatedAt: $updatedAt, addresses: $addresses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileUpdateDataModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.avatar == avatar &&
        other.emailVerifiedAt == emailVerifiedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        _listEquals(other.addresses, addresses);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        avatar.hashCode ^
        emailVerifiedAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        addresses.hashCode;
  }

  /// Helper method to compare lists
  bool _listEquals(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
