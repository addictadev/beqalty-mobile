import 'package:equatable/equatable.dart';

class NotificationResponseModel extends Equatable {
  final bool success;
  final String message;
  final int code;
  final NotificationDataModel data;
  final String timestamp;

  const NotificationResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      code: json['code'] as int,
      data: NotificationDataModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }

  @override
  List<Object?> get props => [success, message, code, data, timestamp];
}

class NotificationDataModel extends Equatable {
  final List<NotificationModel> data;
  final NotificationMetaModel meta;

  const NotificationDataModel({
    required this.data,
    required this.meta,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: NotificationMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  List<Object?> get props => [data, meta];
}

class NotificationModel extends Equatable {
  final int id;
  final String? avatar;
  final String message;
  final String type;
  final int requestId;
  final bool isRead;
  final String? readAt;
  final AddedByModel addedBy;
  final String createdAt;
  final String timeAgo;

  const NotificationModel({
    required this.id,
    this.avatar,
    required this.message,
    required this.type,
    required this.requestId,
    required this.isRead,
    this.readAt,
    required this.addedBy,
    required this.createdAt,
    required this.timeAgo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      avatar: json['avatar'] as String?,
      message: json['message'] as String,
      type: json['type'] as String,
      requestId: json['request_id'] as int,
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] as String?,
      addedBy: AddedByModel.fromJson(json['added_by'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      timeAgo: json['time_ago'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'message': message,
      'type': type,
      'request_id': requestId,
      'is_read': isRead,
      'read_at': readAt,
      'added_by': addedBy.toJson(),
      'created_at': createdAt,
      'time_ago': timeAgo,
    };
  }

  @override
  List<Object?> get props => [
        id,
        avatar,
        message,
        type,
        requestId,
        isRead,
        readAt,
        addedBy,
        createdAt,
        timeAgo,
      ];
}

class AddedByModel extends Equatable {
  final int? id;
  final String? type;

  const AddedByModel({
    this.id,
    this.type,
  });

  factory AddedByModel.fromJson(Map<String, dynamic> json) {
    return AddedByModel(
      id: json['id'] as int?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, type];
}

class NotificationMetaModel extends Equatable {
  final int unreadCount;
  final int total;
  final int currentPage;
  final int perPage;

  const NotificationMetaModel({
    required this.unreadCount,
    required this.total,
    required this.currentPage,
    required this.perPage,
  });

  factory NotificationMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationMetaModel(
      unreadCount: json['unread_count'] as int,
      total: json['total'] as int,
      currentPage: json['current_page'] as int,
      perPage: json['per_page'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unread_count': unreadCount,
      'total': total,
      'current_page': currentPage,
      'per_page': perPage,
    };
  }

  @override
  List<Object?> get props => [unreadCount, total, currentPage, perPage];
}
