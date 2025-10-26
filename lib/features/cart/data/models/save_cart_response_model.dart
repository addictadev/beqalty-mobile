import 'package:equatable/equatable.dart';

class SaveCartResponseModel extends Equatable {
  final bool success;
  final String message;
  final int? cartId;
  final String? cartName;

  const SaveCartResponseModel({
    required this.success,
    required this.message,
    this.cartId,
    this.cartName,
  });

  factory SaveCartResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      cartId: json['cart_id'] as int?,
      cartName: json['cart_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (cartId != null) 'cart_id': cartId,
      if (cartName != null) 'cart_name': cartName,
    };
  }

  @override
  List<Object?> get props => [success, message, cartId, cartName];
}
