import 'package:baqalty/core/network/dio/dio_helper.dart';
import '../models/product_details_response_model.dart';
import '../models/like_product_request_model.dart';
import '../models/like_product_response_model.dart';

/// Abstract service interface for product details operations
/// Defines the contract for product details API calls
abstract class ProductDetailsService {
  /// Fetches detailed product information by product ID
  /// 
  /// [productId] - The unique identifier of the product
  /// 
  /// Returns [ApiResponse<ProductDetailsResponseModel>] containing:
  /// - Success status
  /// - Product details data
  /// - Error information if request fails
  Future<ApiResponse<ProductDetailsResponseModel>> getProductDetails(int productId);

  /// Likes a product by product ID
  /// 
  /// [request] - The like product request containing product ID
  /// 
  /// Returns [ApiResponse<LikeProductResponseModel>] containing:
  /// - Success status
  /// - Success/error message
  /// - Response data
  Future<ApiResponse<LikeProductResponseModel>> likeProduct(LikeProductRequestModel request);

  /// Unlikes a product by product ID
  /// 
  /// [request] - The like product request containing product ID
  /// 
  /// Returns [ApiResponse<LikeProductResponseModel>] containing:
  /// - Success status
  /// - Success/error message
  /// - Response data
  Future<ApiResponse<LikeProductResponseModel>> unlikeProduct(LikeProductRequestModel request);
}
