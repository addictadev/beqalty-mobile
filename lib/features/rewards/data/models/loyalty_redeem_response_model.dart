import 'package:equatable/equatable.dart';

class LoyaltyRedeemResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;

  const LoyaltyRedeemResponseModel({
    required this.success,
    required this.message,
    required this.code,
  });

  factory LoyaltyRedeemResponseModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyRedeemResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }

  @override
  List<Object?> get props => [success, message, code];
}
