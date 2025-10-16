import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import '../models/product_details_response_model.dart';
import '../models/like_product_request_model.dart';
import '../models/like_product_response_model.dart';
import 'product_details_service.dart';

/// Implementation of ProductDetailsService
/// Handles actual API calls for product details operations
class ProductDetailsServiceImpl implements ProductDetailsService {
  @override
  Future<ApiResponse<ProductDetailsResponseModel>> getProductDetails(int productId) async {
    try {
      // Make GET request to product details endpoint
      final response = await DioHelper.get<ProductDetailsResponseModel>(
        EndPoints.productDetails(productId),
        requiresAuth: true, // Product details might be public
        fromJson: (json) => ProductDetailsResponseModel.fromJson(json as Map<String, dynamic>),
      );

      return response;
    } catch (e) {
      // Handle any unexpected errors
      return ApiResponse.error(
        'Failed to fetch product details: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResponse<LikeProductResponseModel>> likeProduct(LikeProductRequestModel request) async {
    try {
      final response = await DioHelper.post<LikeProductResponseModel>(
        EndPoints.likeProduct,
        requiresAuth: true,
        data: request.toJson(),
        fromJson: (json) => LikeProductResponseModel.fromJson(json as Map<String, dynamic>),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        'Failed to like product: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ApiResponse<LikeProductResponseModel>> unlikeProduct(LikeProductRequestModel request) async {
    try {
      final response = await DioHelper.post<LikeProductResponseModel>(
        EndPoints.unlikeProduct,
        requiresAuth: true,
        data: request.toJson(),
        fromJson: (json) => LikeProductResponseModel.fromJson(json as Map<String, dynamic>),
      );

      return response;
    } catch (e) {
      return ApiResponse.error(
        'Failed to unlike product: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}
