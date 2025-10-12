import 'dart:io';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import '../models/register_response_model.dart';
import '../models/registration_data_model.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/user_profile_response_model.dart';
import '../models/profile_update_response_model.dart';

import '../models/forgot_password_request_model.dart';
import '../models/forgot_password_response_model.dart';
import '../models/verify_forgot_password_otp_response_model.dart';
import '../models/reset_password_request_model.dart';

abstract class AuthService {
  Future<ApiResponse<RegisterResponseModel>> register(
    RegistrationDataModel request,
  );

  Future<ApiResponse<LoginResponseModel>> login(LoginRequestModel request);

  Future<ApiResponse<UserProfileResponseModel>> getUserProfile();

  Future<ApiResponse<dynamic>> logout();
  Future<ApiResponse<UserProfileResponseModel>> getUser();
  Future<ApiResponse<LoginResponseModel>> verifyRegisterOtp(
    String phone,
    otpCode,
  );

  Future<ApiResponse<ForgotPasswordResponseModel>> forgotPassword(
    ForgotPasswordRequestModel request,
  );

  Future<ApiResponse<VerifyForgotPasswordOtpResponseModel>>
  verifyForgotPasswordOtp(String phone, String otpCode);

  Future<ApiResponse<dynamic>> resetPassword(ResetPasswordRequestModel request);

  Future<ApiResponse<ProfileUpdateResponseModel>> updateProfile(
    File? image,
    String name,
    String email,
    String phone,
  );

}
