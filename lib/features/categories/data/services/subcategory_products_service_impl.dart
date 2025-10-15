import 'dart:developer';

import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end%20points/end_points.dart';
import 'package:baqalty/features/categories/data/models/subcategory_products_response_model.dart';
import 'package:baqalty/features/categories/data/services/subcategory_products_service.dart';

class SubcategoryProductsServiceImpl implements SubcategoryProductsService {
  @override
  Future<ApiResponse<SubcategoryProductsResponseModel>> getSubcategoryProducts(
    String subcategoryId, {
    String search = '',
    int perPage = 15,
    int page = 1,
  }) async {
    try {
      log('🔄 SubcategoryProductsServiceImpl: Making API call to get products for subcategory: $subcategoryId');
      log('🔍 Search query: "$search", Per page: $perPage, Page: $page');

      final response = await DioHelper.get<SubcategoryProductsResponseModel>(
        EndPoints.subcategoryProducts(subcategoryId),
        requiresAuth: true,
        queryParameters: {
          'search': search,
          'per_page': perPage,
          'page': page,
        },
        fromJson: (json) {
          log('📥 SubcategoryProductsServiceImpl: Raw JSON response: $json');
          try {
            final parsedResponse = SubcategoryProductsResponseModel.fromJson(
              json as Map<String, dynamic>,
            );
            log(
              '✅ SubcategoryProductsServiceImpl: Successfully parsed response with ${parsedResponse.data.products.length} products',
            );
            return parsedResponse;
          } catch (parseError) {
            log('❌ SubcategoryProductsServiceImpl: JSON parsing error: $parseError');
            log('❌ SubcategoryProductsServiceImpl: JSON data: $json');
            rethrow;
          }
        },
      );

      log(
        '📥 SubcategoryProductsServiceImpl: DioHelper response status: ${response.status}',
      );
      log(
        '📥 SubcategoryProductsServiceImpl: DioHelper response message: ${response.message}',
      );

      return response;
    } catch (e, stackTrace) {
      log('❌ SubcategoryProductsServiceImpl: getSubcategoryProducts failed: $e');
      log('❌ SubcategoryProductsServiceImpl: Stack trace: $stackTrace');
      return ApiResponse<SubcategoryProductsResponseModel>(
        status: false,
        message: e.toString(),
      );
    }
  }
}
