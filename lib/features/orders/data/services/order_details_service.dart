import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/features/orders/data/models/order_details_response_model.dart';

class OrderDetailsService {
  Future<OrderDetailsResponseModel> getOrderDetails(int orderId) async {
    try {

      final response = await DioHelper.get<OrderDetailsResponseModel>(
        EndPoints.orderDetails(orderId),
        requiresAuth: true,
        fromJson: (json) => OrderDetailsResponseModel.fromJson(json as Map<String, dynamic>),
      );
            return response.data!;
    } catch (e) {
      rethrow;
    }
  }
}
