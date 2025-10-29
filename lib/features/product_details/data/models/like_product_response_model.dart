import 'package:equatable/equatable.dart';

class LikeProductResponseModel extends Equatable {
  final bool success;
  final String message;
  final dynamic data;
  final int code;

  const LikeProductResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory LikeProductResponseModel.fromJson(Map<String, dynamic> json) {
    return LikeProductResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'],
      code: json['code'] as int,
    );
  }

  @override
  List<Object?> get props => [success, message, data, code];
}
