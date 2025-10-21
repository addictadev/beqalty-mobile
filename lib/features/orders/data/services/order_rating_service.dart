import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';

class OrderRatingService {
  Future<Map<String, dynamic>> submitOrderRating({
    required int orderId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await DioHelper.post<Map<String, dynamic>>(
        EndPoints.orderRating,
        data: {
          'order_id': orderId,
          'rating': rating,
          if (comment != null && comment.isNotEmpty) 'comment': comment,
        },
        requiresAuth: true,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }
}
