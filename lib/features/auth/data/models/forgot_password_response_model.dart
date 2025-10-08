/// Model for forgot password response data
/// Contains the complete response structure from the forgot password API endpoint
class ForgotPasswordResponseModel {
  final bool success;
  final String message;
  final int code;
  final ForgotPasswordResponseDataModel data;
  final String timestamp;

  ForgotPasswordResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a ForgotPasswordResponseModel from JSON data
  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: ForgotPasswordResponseDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
      timestamp: json['timestamp'] as String,
    );
  }

  /// Converts ForgotPasswordResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'ForgotPasswordResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordResponseModel &&
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

/// Model for the data section of forgot password response
/// Contains OTP code for password reset verification
class ForgotPasswordResponseDataModel {
  final int otp;

  ForgotPasswordResponseDataModel({required this.otp});

  /// Creates a ForgotPasswordResponseDataModel from JSON data
  factory ForgotPasswordResponseDataModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseDataModel(otp: json['otp'] as int);
  }

  /// Converts ForgotPasswordResponseDataModel to JSON data
  Map<String, dynamic> toJson() {
    return {'otp': otp};
  }

  @override
  String toString() {
    return 'ForgotPasswordResponseDataModel(otp: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordResponseDataModel && other.otp == otp;
  }

  @override
  int get hashCode => otp.hashCode;
}
