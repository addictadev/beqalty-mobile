import 'package:baqalty/core/network/dio/dio_helper.dart';
import '../models/register_response_model.dart';
import '../models/registration_data_model.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class AuthService {
  Future<ApiResponse<RegisterResponseModel>> register(
    RegistrationDataModel request,
  );

  Future<ApiResponse<LoginResponseModel>> login(LoginRequestModel request);

  Future<ApiResponse<dynamic>> logout();
}
