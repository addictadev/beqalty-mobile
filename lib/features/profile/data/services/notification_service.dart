import 'package:baqalty/core/network/dio/dio_helper.dart';
import 'package:baqalty/core/network/end points/end_points.dart';
import 'package:baqalty/features/profile/data/models/notification_response_model.dart';

abstract class NotificationService {
  Future<ApiResponse<NotificationResponseModel>> getNotifications();
  Future<ApiResponse<Map<String, dynamic>>> markAsRead(int notificationId);
  Future<ApiResponse<Map<String, dynamic>>> markAllAsRead();
}

class NotificationServiceImpl implements NotificationService {
  @override
  Future<ApiResponse<NotificationResponseModel>> getNotifications() async {
    try {
      final response = await DioHelper.get<Map<String, dynamic>>(
        EndPoints.notifications,
        requiresAuth: true,
      );

      final responseModel = NotificationResponseModel.fromJson(response.data!);

      return ApiResponse<NotificationResponseModel>(
        data: responseModel,
        message: responseModel.message,
        status: responseModel.success,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> markAsRead(int notificationId) async {
    try {
      final response = await DioHelper.post<Map<String, dynamic>>(
        EndPoints.markNotificationAsRead(notificationId),
        requiresAuth: true,
      );

      return ApiResponse<Map<String, dynamic>>(
        data: response.data!,
        message: response.data!['message'] as String? ?? 'Success',
        status: response.data!['success'] as bool? ?? true,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> markAllAsRead() async {
    try {
      final response = await DioHelper.post<Map<String, dynamic>>(
        EndPoints.markAllNotificationsAsRead,
        requiresAuth: true,
      );

      return ApiResponse<Map<String, dynamic>>(
        data: response.data!,
        message: response.data!['message'] as String? ?? 'Success',
        status: response.data!['success'] as bool? ?? true,
        statusCode: response.statusCode ?? 200,
      );
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }
}
