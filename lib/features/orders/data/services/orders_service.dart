import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/features/orders/data/models/orders_response_model.dart';

class OrdersService {
  Future<OrdersResponseModel> getAllOrders() async {
    try {
      final response = await DioHelper.get<OrdersResponseModel>(
        EndPoints.orders,
        requiresAuth: true,
        fromJson: (json) => OrdersResponseModel.fromJson(json as Map<String, dynamic>),
      );
      
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }
}
