import 'dart:developer';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end%20points/end_points.dart';
import 'package:baqalty/features/categories/data/models/categories_response_model.dart';
import 'package:baqalty/features/categories/data/models/subcategories_response_model.dart';
import 'package:baqalty/features/categories/data/services/categories_service.dart';

class CategoriesServicesImpl implements CategoriesService {
  @override
  Future<ApiResponse<CategoriesResponseModel>> getParentCategories() async {
    try {
      final response = await DioHelper.get<CategoriesResponseModel>(
        EndPoints.categories,
        requiresAuth: true,
        fromJson: (json) =>
            CategoriesResponseModel.fromJson(json as Map<String, dynamic>),
      );
      return response;
    } catch (e) {
      log('❌ categories services getParentCategories failed: $e');
      return ApiResponse<CategoriesResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<SubcategoriesResponseModel>> getSubcategories(
    String parentId, {
    int page = 1,
    int perPage = 10,
    String search = '',
  }) async {
    try {
      log(
        '🔄 Fetching subcategories for parentId: $parentId, page: $page, perPage: $perPage, search: $search',
      );

      final response = await DioHelper.get<SubcategoriesResponseModel>(
        EndPoints.subcategories(parentId),
        requiresAuth: true,
        queryParameters: {'page': page, 'per_page': perPage, 'search': search},
        fromJson: (json) {
          log('📥 Raw JSON response: $json');
          try {
            return SubcategoriesResponseModel.fromJson(
              json as Map<String, dynamic>,
            );
          } catch (parseError) {
            log('❌ JSON parsing error: $parseError');
            log('❌ JSON data: $json');
            rethrow;
          }
        },
      );

      log(
        '✅ Subcategories fetched successfully: ${response.data?.data.categories.length} items',
      );
      return response;
    } catch (e, stackTrace) {
      log(
        '❌ categories services getSubcategories failed: $e',
        stackTrace: stackTrace,
      );
      return ApiResponse<SubcategoriesResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }
}
