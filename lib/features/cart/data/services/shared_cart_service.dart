import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/features/cart/data/models/cart_response_model.dart';

abstract class SharedCartService {
  Future<ApiResponse<CartResponseModel>> getSharedCart(String sharedCartId);
}

class SharedCartServiceImpl implements SharedCartService {
  @override
  Future<ApiResponse<CartResponseModel>> getSharedCart(String sharedCartId) async {
    try {
      final response = await DioHelper.get<Map<String, dynamic>>(
        EndPoints.getSharedCart(sharedCartId),
        requiresAuth: true,
      );

      final responseModel = CartResponseModel.fromJson(response.data!);
      
      return ApiResponse<CartResponseModel>(
        data: responseModel,
        message: responseModel.message,
        status: true,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to get shared cart: $e');
    }
  }
}
