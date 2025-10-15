import 'package:baqalty/core/network/dio/dio_helper.dart';
import '../models/subcategory_products_response_model.dart';

abstract class SubcategoryProductsService {
  /// Fetches products for a specific subcategory
  /// 
  /// [subcategoryId] - The ID of the subcategory
  /// [search] - Optional search query to filter products
  /// [perPage] - Number of products per page (default: 15)
  /// [page] - Page number for pagination (default: 1)
  Future<ApiResponse<SubcategoryProductsResponseModel>> getSubcategoryProducts(
    String subcategoryId, {
    String search = '',
    int perPage = 15,
    int page = 1,
  });
}
