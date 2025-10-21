import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/core/services/shared_preferences_service.dart';
import 'package:baqalty/core/utils/shared_prefs_helper.dart';
import 'package:baqalty/features/checkout/data/models/checkout_response_model.dart';
import 'package:baqalty/features/checkout/data/models/create_order_request_model.dart';
import 'package:baqalty/features/checkout/data/models/create_order_response_model.dart';
import 'package:baqalty/features/checkout/data/models/apply_discount_request_model.dart';
import 'package:baqalty/features/checkout/data/models/apply_discount_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CheckoutService {
  CheckoutService();

  Future<CheckoutResponseModel> checkout({
    required int cartId,
  }) async {
    try {
      final response = await DioHelper.post<Map<String, dynamic>>(
        EndPoints.checkout,
        data: {
          'cart_id': cartId,
        },
      );

      if (response.status && response.data != null) {
        return CheckoutResponseModel.fromJson(response.data!);
      } else {
        throw Exception(response.message ?? 'Checkout failed');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<CreateOrderResponseModel> createOrder({
    required CreateOrderRequestModel request,
  }) async {
    try {
      // Create FormData for the request
      final formDataMap = request.toFormData();
      final formData = FormData.fromMap(formDataMap);
      
      // Debug logging
      debugPrint('🚀 Creating order with data: $formDataMap');
      debugPrint('📍 Endpoint: ${EndPoints.createOrder}');
      
      // Get user token for authorization
      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.post<Map<String, dynamic>>(
        EndPoints.createOrder,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Create order response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        return CreateOrderResponseModel.fromJson(response.data!);
      } else {
        final errorMessage = response.data?['message'] ?? 'Create order failed';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in createOrder: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Unexpected error in createOrder: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ApplyDiscountResponseModel> applyDiscount({
    required ApplyDiscountRequestModel request,
  }) async {
    try {
      // Create FormData for the request
      final formDataMap = request.toFormData();
      final formData = FormData.fromMap(formDataMap);
      
      // Debug logging
      debugPrint('🎟️ Applying discount with data: $formDataMap');
      debugPrint('📍 Endpoint: ${EndPoints.applyDiscount}');
      
      // Get user token for authorization
      final token = await SharedPrefsHelper.getUserToken();
      if (token == null || token.isEmpty) {
        throw Exception('User not authenticated');
      }

      final response = await DioHelper.dio.post<Map<String, dynamic>>(
        EndPoints.applyDiscount,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Accept-Language': ServiceLocator.get<SharedPreferencesService>().getLanguage(),
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('✅ Apply discount response: ${response.data}');
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.data != null) {
        try {
          // Parse the response regardless of status code
          final responseModel = ApplyDiscountResponseModel.fromJson(response.data!);
          
          // If success is false, throw exception with the specific error
          if (!responseModel.success) {
            String errorMessage = responseModel.message;
            if (responseModel.errors != null && responseModel.errors!.isNotEmpty) {
              errorMessage = responseModel.errors!.first;
            }
            debugPrint('🎯 Throwing specific error: $errorMessage');
            throw errorMessage;
          }
          
          return responseModel;
        } catch (e) {
          debugPrint('❌ Error parsing discount response: $e');
          debugPrint('❌ Response data: ${response.data}');
          // If parsing fails, try to extract error message manually
          if (response.data is Map<String, dynamic>) {
            final data = response.data as Map<String, dynamic>;
            final errors = data['errors'];
            if (errors != null && errors is List && errors.isNotEmpty) {
              debugPrint('🎯 Manual parsing - throwing error: ${errors.first}');
              throw errors.first.toString();
            }
            final message = data['message'];
            if (message != null) {
              debugPrint('🎯 Manual parsing - throwing message: $message');
              throw message.toString();
            }
          }
          throw Exception('Failed to parse response');
        }
      } else {
        throw Exception('No response data received');
      }
    } on DioException catch (e) {
      debugPrint('❌ DioException in applyDiscount: ${e.message}');
      debugPrint('❌ Response data: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('❌ Error in applyDiscount: $e');
      // If it's already a String (our custom error), re-throw it
      if (e is String) {
        rethrow;
      }
      // If it's already an Exception with a message, re-throw it
      if (e is Exception) {
        rethrow;
      }
      // Otherwise, wrap it in an Exception
      throw Exception(e.toString());
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        if (statusCode == 500) {
          return 'server_error'.tr();
        } else if (statusCode == 401) {
          return 'unauthorized_error'.tr();
        } else if (statusCode == 422) {
          // For 422 errors, try to get specific error message
          if (responseData != null && responseData is Map<String, dynamic>) {
            final errors = responseData['errors'];
            if (errors != null && errors is List && errors.isNotEmpty) {
              return errors.first.toString();
            }
            return responseData['message'] ?? 'invalid_data_error'.tr();
          }
          return 'invalid_data_error'.tr();
        }
        
        final message = responseData?['message'] ?? 'Server error occurred.';
        return 'Error $statusCode: $message';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badCertificate:
        return 'Certificate error. Please try again.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
