/// Model for change password response data
/// Contains only the message string as requested
class ChangePasswordResponseModel {
  final bool success;
  final String message;
  final int code;
  final dynamic data; // null in response
  final String timestamp;

  ChangePasswordResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a ChangePasswordResponseModel from JSON data
  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: json['data'], // Can be null
      timestamp: json['timestamp'] as String,
    );
  }

  /// Converts ChangePasswordResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'ChangePasswordResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChangePasswordResponseModel &&
        other.success == success &&
        other.message == message &&
        other.code == code &&
        other.data == data &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      success.hashCode ^
      message.hashCode ^
      code.hashCode ^
      data.hashCode ^
      timestamp.hashCode;
}
