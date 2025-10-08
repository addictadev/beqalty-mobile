/// Model for verify forgot password OTP response data
/// Contains the complete response structure from the verify forgot password OTP API endpoint
class VerifyForgotPasswordOtpResponseModel {
  final bool success;
  final String message;
  final int code;
  final VerifyForgotPasswordOtpResponseDataModel data;
  final String timestamp;

  VerifyForgotPasswordOtpResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a VerifyForgotPasswordOtpResponseModel from JSON data
  factory VerifyForgotPasswordOtpResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VerifyForgotPasswordOtpResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: VerifyForgotPasswordOtpResponseDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
      timestamp: json['timestamp'] as String,
    );
  }

  /// Converts VerifyForgotPasswordOtpResponseModel to JSON data
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
    return 'VerifyForgotPasswordOtpResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerifyForgotPasswordOtpResponseModel &&
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

/// Model for the data section of verify forgot password OTP response
/// Contains reset token for password reset
class VerifyForgotPasswordOtpResponseDataModel {
  final String resetToken;

  VerifyForgotPasswordOtpResponseDataModel({required this.resetToken});

  /// Creates a VerifyForgotPasswordOtpResponseDataModel from JSON data
  factory VerifyForgotPasswordOtpResponseDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VerifyForgotPasswordOtpResponseDataModel(
      resetToken: json['reset_token'] as String,
    );
  }

  /// Converts VerifyForgotPasswordOtpResponseDataModel to JSON data
  Map<String, dynamic> toJson() {
    return {'reset_token': resetToken};
  }

  @override
  String toString() {
    return 'VerifyForgotPasswordOtpResponseDataModel(resetToken: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerifyForgotPasswordOtpResponseDataModel &&
        other.resetToken == resetToken;
  }

  @override
  int get hashCode => resetToken.hashCode;
}
