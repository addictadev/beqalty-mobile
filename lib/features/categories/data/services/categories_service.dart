import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/features/categories/data/models/categories_response_model.dart';

abstract class CategoriesService {
  Future<ApiResponse<CategoriesResponseModel>> getParentCategories();
}
