import 'favorite_item_model.dart';

/// Response model for favorite items API
class FavoriteItemsResponseModel {
  final bool success;
  final String message;
  final List<FavoriteItemModel> data;
  final int code;
  final String timestamp;

  FavoriteItemsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
    required this.timestamp,
  });

  /// Creates a FavoriteItemsResponseModel from JSON data
  factory FavoriteItemsResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => FavoriteItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      code: json['code'] as int? ?? 0,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  /// Converts FavoriteItemsResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'code': code,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'FavoriteItemsResponseModel(success: $success, message: $message, data: ${data.length} items, code: $code, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteItemsResponseModel &&
        other.success == success &&
        other.message == message &&
        other.data == data &&
        other.code == code &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      success.hashCode ^
      message.hashCode ^
      data.hashCode ^
      code.hashCode ^
      timestamp.hashCode;
}
