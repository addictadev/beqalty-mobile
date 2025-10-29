import 'package:equatable/equatable.dart';
import 'package:baqalty/features/profile/data/models/notification_response_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final NotificationDataModel notificationData;

  const NotificationLoaded({required this.notificationData});

  @override
  List<Object> get props => [notificationData];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object> get props => [message];
}
