import 'package:equatable/equatable.dart';

class RemoveItemResponseModel extends Equatable {
  final bool success;
  final String message;
  final int data;
  final int code;

  const RemoveItemResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory RemoveItemResponseModel.fromJson(Map<String, dynamic> json) {
    return RemoveItemResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as int,
      code: json['code'] as int,
    );
  }

  @override
  List<Object?> get props => [success, message, data, code];
}
