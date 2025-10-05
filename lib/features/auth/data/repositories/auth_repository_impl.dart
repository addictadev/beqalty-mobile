import 'dart:developer';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/features/auth/data/models/register_response_model.dart';
import 'package:baqalty/features/auth/data/models/registration_data_model.dart';
import 'package:baqalty/features/auth/data/repositories/auth_repository.dart';
import 'package:baqalty/features/auth/data/services/auth_services.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<ApiResponse<RegisterResponseModel>> register(
    RegistrationDataModel request,
  ) async {
    try {
      log('🔄 Starting registration process');

      final response = await _authService.register(request);

      // if (response.status && response.data != null) {

      //   final user = response.data!.data.user;
      //   await SharedPrefsHelper.setUserId(user.id);
      //   await SharedPrefsHelper.setUserName(user.name);
      //   await SharedPrefsHelper.setUserEmail(user.email);
      //   await SharedPrefsHelper.setUserPhone(user.phone);

      //   if (user.avatar != null) {
      //     await SharedPrefsHelper.setUserAvatar(user.avatar!);
      //   }

      //   await SharedPrefsHelper.setEmailVerified(user.emailVerifiedAt != null);

      //   // Set login state
      //   await SharedPrefsHelper.setLoginState(true);

      
      // }

      return response;
    } catch (e) {
      log('❌ auth repository register failed: $e');
      return ApiResponse<RegisterResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }


}
