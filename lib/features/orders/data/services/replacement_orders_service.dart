import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/features/orders/data/models/replacement_order_model.dart';
import 'package:baqalty/core/utils/shared_prefs_helper.dart';
import 'package:dio/dio.dart';

abstract class ReplacementOrdersService {
  Future<ApiResponse<ReplacementOrderResponseModel>> getReplacementOrders();
  Future<ApiResponse<Map<String, dynamic>>> selectReplacement({
    required int orderId,
    required int? replacementId, // Made nullable to support canceling
    required int orderItemId,
  });
  Future<ApiResponse<Map<String, dynamic>>> cancelReplacement({
    required int orderId,
    required int orderItemId,
  });
}

class ReplacementOrdersServiceImpl implements ReplacementOrdersService {
  @override
  Future<ApiResponse<ReplacementOrderResponseModel>> getReplacementOrders() async {
    try {
      // Use direct Dio call to bypass DioHelper's success check
      final dio = Dio();
      final token = await SharedPrefsHelper.getUserToken();
      
      final response = await dio.get(
        'https://baqalty-back.addictaco.website/api/v1/orders-replacement',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': 'ar',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final responseModel = ReplacementOrderResponseModel.fromJson(response.data);

      // For replacement orders, empty data is a valid response
      return ApiResponse<ReplacementOrderResponseModel>(
        data: responseModel,
        message: responseModel.message,
        status: true, // Always consider it successful for replacement orders
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to get replacement orders: $e');
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> selectReplacement({
    required int orderId,
    required int? replacementId, // Made nullable to support canceling
    required int orderItemId,
  }) async {
    try {
      final response = await DioHelper.post<Map<String, dynamic>>(
        EndPoints.selectReplacement(orderId),
        data: {
          'replacement_id': replacementId, // Can be null to cancel replacement
          'order_item_id': orderItemId,
        },
      );

      return ApiResponse<Map<String, dynamic>>(
        data: response.data!,
        message: response.data!['message'] as String? ?? 'Success',
        status: response.data!['success'] as bool? ?? true,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to select replacement: $e');
    }
  }

  /// Cancel replacement by sending null replacement_id
  @override
  Future<ApiResponse<Map<String, dynamic>>> cancelReplacement({
    required int orderId,
    required int orderItemId,
  }) async {
    return selectReplacement(
      orderId: orderId,
      replacementId: null, // Send null to cancel
      orderItemId: orderItemId,
    );
  }
}
