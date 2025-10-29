import '../../../../core/network/dio/dio_helper.dart';
import '../../../../core/network/end points/end_points.dart';
import '../models/favorite_items_response_model.dart';
import 'favorite_items_service.dart';

/// Implementation of FavoriteItemsService
class FavoriteItemsServiceImpl implements FavoriteItemsService {
  @override
  Future<ApiResponse<FavoriteItemsResponseModel>> getAllFavoriteItems({String? search}) async {
    try {
      // Build query parameters
      Map<String, dynamic> queryParams = {};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      // Make API call
      final response = await DioHelper.get(
        EndPoints.getAllFavoriteItems,
        queryParameters: queryParams,
        requiresAuth: true,
      );

      // Parse response
      if (response.status && response.data != null) {
        final favoriteItemsResponse = FavoriteItemsResponseModel.fromJson(response.data!);
        return ApiResponse<FavoriteItemsResponseModel>(
          status: true,
          message: favoriteItemsResponse.message,
          data: favoriteItemsResponse,
        );
      } else {
        return ApiResponse<FavoriteItemsResponseModel>(
          status: false,
          message: response.message ?? 'Failed to load favorite items',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<FavoriteItemsResponseModel>(
        status: false,
        message: 'An unexpected error occurred: ${e.toString()}',
        data: null,
      );
    }
  }
}
