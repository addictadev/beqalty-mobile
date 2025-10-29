import 'package:equatable/equatable.dart';

class CreateSavedCartResponseModel extends Equatable {
  final bool success;
  final String message;
  final CreateSavedCartDataModel? data;
  final int code;

  const CreateSavedCartResponseModel({
    required this.success,
    required this.message,
    this.data,
    required this.code,
  });

  factory CreateSavedCartResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateSavedCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null 
          ? CreateSavedCartDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      code: json['code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'code': code,
    };
  }

  @override
  List<Object?> get props => [success, message, data, code];
}

class CreateSavedCartDataModel extends Equatable {
  final int userId;
  final String cartType;
  final String name;
  final bool isActive;
  final String updatedAt;
  final String createdAt;
  final int id;

  const CreateSavedCartDataModel({
    required this.userId,
    required this.cartType,
    required this.name,
    required this.isActive,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory CreateSavedCartDataModel.fromJson(Map<String, dynamic> json) {
    return CreateSavedCartDataModel(
      userId: json['user_id'] as int,
      cartType: json['cart_type'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'cart_type': cartType,
      'name': name,
      'is_active': isActive,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        cartType,
        name,
        isActive,
        updatedAt,
        createdAt,
        id,
      ];
}
