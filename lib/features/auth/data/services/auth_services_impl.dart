import 'dart:developer';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end%20points/end_points.dart';
import 'package:baqalty/features/auth/data/models/register_response_model.dart';
import 'package:baqalty/features/auth/data/models/registration_data_model.dart';
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
}
