import 'package:equatable/equatable.dart';

class ClearCartResponseModel extends Equatable {
  final bool success;
  final String message;
  final dynamic data;
  final int code;

  const ClearCartResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory ClearCartResponseModel.fromJson(Map<String, dynamic> json) {
    return ClearCartResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
      code: json['code'] as int,
    );
  }

  @override
  List<Object?> get props => [success, message, data, code];
}
