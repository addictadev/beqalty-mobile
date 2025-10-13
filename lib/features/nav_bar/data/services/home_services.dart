import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';

abstract class HomeServices {
  Future<ApiResponse<HomeResponseModel>> getHomeData();
}