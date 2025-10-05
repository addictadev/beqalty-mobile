import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/features/auth/data/models/register_response_model.dart';
import 'package:baqalty/features/auth/data/models/registration_data_model.dart';

abstract class AuthRepository {
  Future<ApiResponse<RegisterResponseModel>> register(
    RegistrationDataModel request,
  );


}
