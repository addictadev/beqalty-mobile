import '../../../../core/network/dio/dio_helper.dart';
import '../models/favorite_items_response_model.dart';

/// Service interface for favorite items operations
abstract class FavoriteItemsService {
  /// Gets all favorite items with optional search parameter
  /// 
  /// [search] - Optional search query to filter favorite items
  /// 
  /// Returns [ApiResponse<FavoriteItemsResponseModel>] containing the list of favorite items
  Future<ApiResponse<FavoriteItemsResponseModel>> getAllFavoriteItems({String? search});
}
