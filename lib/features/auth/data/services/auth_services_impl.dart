import 'dart:developer';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end%20points/end_points.dart';
import 'package:baqalty/features/auth/data/models/login_request_model.dart';
import 'package:baqalty/features/auth/data/models/login_response_model.dart';
import 'package:baqalty/features/auth/data/models/register_response_model.dart';
import 'package:baqalty/features/auth/data/models/registration_data_model.dart';
import 'package:baqalty/features/auth/data/models/user_profile_response_model.dart';
import 'package:baqalty/features/auth/data/services/auth_services.dart';

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
}
