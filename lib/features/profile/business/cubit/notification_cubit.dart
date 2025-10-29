import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/features/profile/data/services/notification_service.dart';
import 'package:baqalty/features/profile/business/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService _notificationService;

  NotificationCubit(this._notificationService) : super(NotificationInitial());

  Future<void> getNotifications() async {
    try {
      emit(NotificationLoading());
      
      final response = await _notificationService.getNotifications();
      
      if (response.status) {
        emit(NotificationLoaded(notificationData: response.data!.data));
      } else {
        emit(NotificationError(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final response = await _notificationService.markAsRead(notificationId);
      
      if (response.status) {
        // Refresh notifications after marking as read
        await getNotifications();
      } else {
        emit(NotificationError(message: response.message ?? 'Failed to mark as read'));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _notificationService.markAllAsRead();
      
      if (response.status) {
        // Refresh notifications after marking all as read
        await getNotifications();
      } else {
        emit(NotificationError(message: response.message ?? 'Failed to mark all as read'));
      }
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
}
