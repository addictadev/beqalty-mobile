import 'dart:developer';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end%20points/end_points.dart';
import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';
import 'package:baqalty/features/nav_bar/data/services/home_services.dart';

class HomeServicesImpl implements HomeServices {
  @override
  Future<ApiResponse<HomeResponseModel>> getHomeData() async {
    try {
      final response = await DioHelper.get<HomeResponseModel>(
        EndPoints.home,
        requiresAuth: true,
        fromJson: (json) =>
            HomeResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ home services getHomeData failed: $e');
      return ApiResponse<HomeResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }
}
