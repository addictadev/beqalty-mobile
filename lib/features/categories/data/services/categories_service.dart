import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/features/categories/data/models/categories_response_model.dart';
import 'package:baqalty/features/categories/data/models/subcategories_response_model.dart';

abstract class CategoriesService {
  Future<ApiResponse<CategoriesResponseModel>> getParentCategories();
  Future<ApiResponse<SubcategoriesResponseModel>> getSubcategories(
    String parentId, {
    int page = 1,
    int perPage = 10,
    String search = '',
  });
}
