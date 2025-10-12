import 'dart:developer';
import 'dart:io';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end%20points/end_points.dart';
import 'package:baqalty/features/auth/data/models/login_request_model.dart';
import 'package:baqalty/features/auth/data/models/login_response_model.dart';
import 'package:baqalty/features/auth/data/models/register_response_model.dart';
import 'package:baqalty/features/auth/data/models/registration_data_model.dart';
import 'package:baqalty/features/auth/data/models/user_profile_response_model.dart';
import 'package:baqalty/features/auth/data/models/profile_update_response_model.dart';

import 'package:baqalty/features/auth/data/models/forgot_password_request_model.dart';
import 'package:baqalty/features/auth/data/models/forgot_password_response_model.dart';
import 'package:baqalty/features/auth/data/models/verify_forgot_password_otp_response_model.dart';
import 'package:baqalty/features/auth/data/models/reset_password_request_model.dart';
import 'package:baqalty/features/auth/data/models/change_password_request_model.dart';
import 'package:baqalty/features/auth/data/models/change_password_response_model.dart';
import 'package:baqalty/features/auth/data/services/auth_services.dart';
import 'package:dio/dio.dart';

class AuthServicesImpl implements AuthService {
  @override
  Future<ApiResponse<RegisterResponseModel>> register(
    RegistrationDataModel request,
  ) async {
    try {
      final response = await DioHelper.post<RegisterResponseModel>(
        EndPoints.register,
        data: request.toRegistrationJson(),
        requiresAuth: false,
        fromJson: (json) =>
            RegisterResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ auth services register failed: $e');
      return ApiResponse<RegisterResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    try {
      final response = await DioHelper.post<LoginResponseModel>(
        EndPoints.login,
        data: request,
        requiresAuth: false,
        fromJson: (json) =>
            LoginResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ auth services login failed: $e');
      return ApiResponse<LoginResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<UserProfileResponseModel>> getUserProfile() async {
    try {
      final response = await DioHelper.get<UserProfileResponseModel>(
        EndPoints.getUser,
        requiresAuth: true,
        fromJson: (json) =>
            UserProfileResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ auth services getUserProfile failed: $e');
      return ApiResponse<UserProfileResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> logout() async {
    try {
      final response = await DioHelper.post(
        EndPoints.logout,
        requiresAuth: true,
      );
      return response;
    } catch (e) {
      log('❌ auth services logout failed: $e');
      return ApiResponse(status: false, message: e.toString());
    }
  }

  @override
  Future<ApiResponse<UserProfileResponseModel>> getUser() async {
    try {
      final response = await DioHelper.get<UserProfileResponseModel>(
        EndPoints.getUser,
        requiresAuth: true,
        fromJson: (json) =>
            UserProfileResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ auth services getUser failed: $e');
      return ApiResponse<UserProfileResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<LoginResponseModel>> verifyRegisterOtp(
    String phone,
    otpCode,
  ) async {
    try {
      final response = await DioHelper.post<LoginResponseModel>(
        EndPoints.verifyRegisterOtp,
        data: {'phone': phone, 'otp': otpCode},
        requiresAuth: false,
        fromJson: (json) =>
            LoginResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ auth services verifyRegisterOtp failed: $e');
      return ApiResponse<LoginResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<ForgotPasswordResponseModel>> forgotPassword(
    ForgotPasswordRequestModel request,
  ) async {
    try {
      final response = await DioHelper.post<ForgotPasswordResponseModel>(
        EndPoints.forgotPassword,
        data: request.toFormData(),
        requiresAuth: false,
        fromJson: (json) =>
            ForgotPasswordResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ auth services forgotPassword failed: $e');
      return ApiResponse<ForgotPasswordResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<VerifyForgotPasswordOtpResponseModel>>
  verifyForgotPasswordOtp(String phone, String otpCode) async {
    try {
      final response =
          await DioHelper.post<VerifyForgotPasswordOtpResponseModel>(
            EndPoints.verifyOtp,
            data: {'phone': phone, 'otp': otpCode},
            requiresAuth: false,
            fromJson: (json) => VerifyForgotPasswordOtpResponseModel.fromJson(
              json as Map<String, dynamic>,
            ),
          );
      return response;
    } catch (e) {
      log('❌ auth services verifyForgotPasswordOtp failed: $e');
      return ApiResponse<VerifyForgotPasswordOtpResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> resetPassword(
    ResetPasswordRequestModel request,
  ) async {
    try {
      final response = await DioHelper.post<dynamic>(
        EndPoints.resetPassword,
        data: request.toFormData(),
        requiresAuth: false,
      );
      return response;
    } catch (e) {
      log('❌ auth services resetPassword failed: $e');
      return ApiResponse<dynamic>(status: false, message: e.toString());
    }
  }

  @override
  Future<ApiResponse<ProfileUpdateResponseModel>> updateProfile(
    File? image,
    String name,
    String email,
    String phone,
  ) async {
    try {
      final FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
      });

      if (image != null && image.path.isNotEmpty) {
        final imageFile = File(image.path);
        if (await imageFile.exists()) {
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                image.path,
                filename: 'profile_image.jpg',
              ),
            ),
          );
        }
      }

      final response = await DioHelper.post<ProfileUpdateResponseModel>(
        EndPoints.updateProfile,
        data: formData,
        requiresAuth: true,
        fromJson: (json) =>
            ProfileUpdateResponseModel.fromJson(json as Map<String, dynamic>),
      );

      return response;
    } catch (e) {
      log('❌ auth services updateProfile failed: $e');
      return ApiResponse<ProfileUpdateResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<ChangePasswordResponseModel>> changePassword(
    ChangePasswordRequestModel request,
  ) async {
    try {
      final response = await DioHelper.post<ChangePasswordResponseModel>(
        EndPoints.changePassword,
        data: request.toJson(),
        requiresAuth: true,
        fromJson: (json) =>
            ChangePasswordResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ auth services changePassword failed: $e');
      return ApiResponse<ChangePasswordResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteAccount() async {
    try {
      final response = await DioHelper.delete(
        EndPoints.deleteAccount,
        requiresAuth: true,
      );
      return response;
    } catch (e) {
      log('❌ auth services deleteAccount failed: $e');
      return ApiResponse<dynamic>(status: false, message: e.toString());
    }
  }
}
