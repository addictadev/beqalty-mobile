import 'package:dio/dio.dart';
import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/core/services/shared_preferences_service.dart';
import 'package:baqalty/features/saved_carts/data/models/saved_carts_response_model.dart';
import 'package:baqalty/features/saved_carts/data/models/create_saved_cart_request_model.dart';
import 'package:baqalty/features/saved_carts/data/models/create_saved_cart_response_model.dart';
import 'package:baqalty/features/saved_carts/data/models/saved_cart_details_response_model.dart';
import 'package:baqalty/features/saved_carts/data/models/saved_cart_add_response_model.dart';
import 'package:baqalty/features/saved_carts/data/models/saved_cart_item_action_request_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:baqalty/core/utils/shared_prefs_helper.dart';
import 'package:flutter/foundation.dart';

class SavedCartsService {
  /// Gets all saved carts
  /// 
  /// [search] - Optional search query to filter saved carts
  /// Returns [SavedCartsResponseModel] containing list of saved carts
  /// Throws [Exception] if request fails
  Future<SavedCartsResponseModel> getAllSavedCarts({String? search}) async {
    try {
      debugPrint('🚀 Getting all saved carts');
      debugPrint('📍 Endpoint: ${EndPoints.savedCarts}');

      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Build query parameters
      Map<String, dynamic> queryParams = {};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await DioHelper.dio.get<Map<String, dynamic>>(
        EndPoints.savedCarts,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Get saved carts response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        try {
          final responseModel = SavedCartsResponseModel.fromJson(response.data!);
          
          // If the API returns success: false, treat it as an empty list
          if (!responseModel.success) {
            return SavedCartsResponseModel(
              success: true, // Convert to success for the app
              message: responseModel.message,
              code: responseModel.code,
              data: [], // Empty list when no carts available
              timestamp: responseModel.timestamp,
            );
          }
          
          return responseModel;
        } catch (e) {
          debugPrint('❌ Error parsing saved carts response: $e');
          debugPrint('❌ Response data: ${response.data}');
          throw Exception('Failed to parse saved carts data: $e');
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to get saved carts';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in getAllSavedCarts: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in getAllSavedCarts: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Creates a new saved cart
  /// 
  /// [request] - The request model containing cart name
  /// Returns [CreateSavedCartResponseModel] containing created cart data
  /// Throws [Exception] if request fails
  Future<CreateSavedCartResponseModel> createSavedCart({
    required CreateSavedCartRequestModel request,
  }) async {
    try {
      debugPrint('🚀 Creating saved cart with name: ${request.name}');
      debugPrint('📍 Endpoint: ${EndPoints.createSavedCart}');

      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.post<Map<String, dynamic>>(
        EndPoints.createSavedCart,
        data: request.toJson(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Create saved cart response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          return CreateSavedCartResponseModel.fromJson(response.data!);
        } else {
          throw Exception('Empty response data');
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to create saved cart';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in createSavedCart: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in createSavedCart: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Deletes a saved cart by ID
  /// 
  /// [cartId] - The ID of the saved cart to delete
  /// Returns [Map<String, dynamic>] containing the response data
  /// Throws [Exception] if request fails
  Future<Map<String, dynamic>> deleteSavedCart({required int cartId}) async {
    try {
      debugPrint('🗑️ Deleting saved cart with ID: $cartId');
      debugPrint('📍 Endpoint: ${EndPoints.deleteSavedCart(cartId)}');

      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.delete<Map<String, dynamic>>(
        EndPoints.deleteSavedCart(cartId),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Delete saved cart response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.data != null) {
          return response.data!;
        } else {
          return {
            'success': true,
            'message': 'Cart deleted successfully',
            'code': response.statusCode,
          };
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to delete saved cart';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in deleteSavedCart: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in deleteSavedCart: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'connection_timeout_error'.tr();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error occurred.';

        if (statusCode == 500) {
          return 'server_error'.tr();
        } else if (statusCode == 401) {
          return 'unauthorized_error'.tr();
        } else if (statusCode == 422) {
          return 'invalid_data_error'.tr();
        }

        return 'Error $statusCode: $message';
      case DioExceptionType.cancel:
        return 'request_cancelled_error'.tr();
      case DioExceptionType.connectionError:
        return 'connection_error'.tr();
      case DioExceptionType.badCertificate:
        return 'certificate_error'.tr();
      case DioExceptionType.unknown:
        return 'unknown_error'.tr();
    }
  }

  /// Gets saved cart details by ID
  /// 
  /// [cartId] - The ID of the saved cart to retrieve
  /// Returns [SavedCartDetailsResponseModel] containing cart details
  /// Throws [Exception] if request fails
  Future<SavedCartDetailsResponseModel> getSavedCartDetails(int cartId) async {
    try {
      debugPrint('🚀 Getting saved cart details for ID: $cartId');
      debugPrint('📍 Endpoint: ${EndPoints.getSavedCartDetails(cartId)}');

      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.get<Map<String, dynamic>>(
        EndPoints.getSavedCartDetails(cartId),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Get saved cart details response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        try {
          return SavedCartDetailsResponseModel.fromJson(response.data!);
        } catch (e) {
          debugPrint('❌ Error parsing saved cart details response: $e');
          debugPrint('❌ Response data: ${response.data}');
          throw Exception('Failed to parse saved cart details data: $e');
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to get saved cart details';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in getSavedCartDetails: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in getSavedCartDetails: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Removes an item from saved cart
  /// 
  /// [cartId] - The ID of the saved cart
  /// [request] - The request model containing product ID
  /// Returns [SavedCartDetailsResponseModel] containing updated cart details
  /// Throws [Exception] if request fails
  Future<SavedCartDetailsResponseModel> removeItemFromSavedCart({
    required int cartId,
    required SavedCartItemActionRequestModel request,
  }) async {
    try {
      debugPrint('🚀 Removing item from saved cart ID: $cartId, Product ID: ${request.productId}');
      debugPrint('📍 Endpoint: ${EndPoints.removeItemFromSavedCart(cartId)}');

      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.post<Map<String, dynamic>>(
        EndPoints.removeItemFromSavedCart(cartId),
        data: request.toFormData(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Remove item from saved cart response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        try {
          return SavedCartDetailsResponseModel.fromJson(response.data!);
        } catch (e) {
          debugPrint('❌ Error parsing remove item response: $e');
          debugPrint('❌ Response data: ${response.data}');
          throw Exception('Failed to parse remove item response: $e');
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to remove item from saved cart';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in removeItemFromSavedCart: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in removeItemFromSavedCart: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Decreases quantity of an item in saved cart
  /// 
  /// [cartId] - The ID of the saved cart
  /// [request] - The request model containing product ID and quantity
  /// Returns [SavedCartDetailsResponseModel] containing updated cart details
  /// Throws [Exception] if request fails
  Future<SavedCartDetailsResponseModel> minusItemFromSavedCart({
    required int cartId,
    required SavedCartItemActionRequestModel request,
  }) async {
    try {
      debugPrint('🚀 Decreasing item quantity in saved cart ID: $cartId, Product ID: ${request.productId}');
      debugPrint('📍 Endpoint: ${EndPoints.minusItemFromSavedCart(cartId)}');

      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.post<Map<String, dynamic>>(
        EndPoints.minusItemFromSavedCart(cartId),
        data: request.toFormData(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Decrease item quantity response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        try {
          return SavedCartDetailsResponseModel.fromJson(response.data!);
        } catch (e) {
          debugPrint('❌ Error parsing decrease quantity response: $e');
          debugPrint('❌ Response data: ${response.data}');
          throw Exception('Failed to parse decrease quantity response: $e');
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to decrease item quantity';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in minusItemFromSavedCart: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in minusItemFromSavedCart: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  /// Increases the quantity of an item in a saved cart
  /// 
  /// [cartId] - The ID of the saved cart
  /// [request] - The request model containing product ID and quantity
  /// Returns [SavedCartAddResponseModel] with add operation result
  /// Throws [Exception] if request fails
  Future<SavedCartAddResponseModel> plusItemFromSavedCart({
    required int cartId,
    required SavedCartItemActionRequestModel request,
  }) async {
    try {
      debugPrint('🚀 Increasing item quantity in saved cart ID: $cartId, Product ID: ${request.productId}');
      debugPrint('📍 Endpoint: ${EndPoints.plusItemFromSavedCart(cartId)}');

      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.post<Map<String, dynamic>>(
        EndPoints.plusItemFromSavedCart(cartId),
        data: request.toFormData(),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Increase item quantity response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        try {
          return SavedCartAddResponseModel.fromJson(response.data!);
        } catch (e) {
          debugPrint('❌ Error parsing increase quantity response: $e');
          debugPrint('❌ Response data: ${response.data}');
          throw Exception('Failed to parse increase quantity response: $e');
        }
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to increase item quantity';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in plusItemFromSavedCart: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in plusItemFromSavedCart: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
