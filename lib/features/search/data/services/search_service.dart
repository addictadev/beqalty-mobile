import '../../../../core/network/dio/dio_helper.dart';
import '../../../../core/network/end points/end_points.dart';
import '../models/search_response_model.dart';

/// Abstract service interface for search functionality
/// Defines the contract for search-related API operations
abstract class SearchService {
  /// Search for products with pagination support
  /// 
  /// [searchQuery] - The search term to look for
  /// [page] - The page number for pagination (default: 1)
  /// [perPage] - Number of items per page (default: 15)
  /// 
  /// Returns a [SearchResponseModel] containing products, warehouse info, and pagination metadata
  Future<SearchResponseModel> searchProducts({
    required String searchQuery,
    int page = 1,
    int perPage = 15,
  });
}

/// Implementation of SearchService
/// Handles actual API calls for search functionality
class SearchServiceImpl implements SearchService {
  @override
  Future<SearchResponseModel> searchProducts({
    required String searchQuery,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await DioHelper.get<SearchResponseModel>(
        EndPoints.searchProducts,
        queryParameters: {
          'search': searchQuery,
          'page': page,
          'per_page': perPage,
        },
        requiresAuth: true,
        fromJson: (json) => SearchResponseModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.status) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Failed to search products');
      }
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }
}
