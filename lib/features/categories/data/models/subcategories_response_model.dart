import 'categories_response_model.dart';

/// Model for subcategories API response data
/// Contains the complete response structure from the categories/parent/{id}/sublevels API endpoint
class SubcategoriesResponseModel {
  final bool success;
  final String message;
  final int code;
  final SubcategoriesData data;
  final String timestamp;

  SubcategoriesResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a SubcategoriesResponseModel from JSON data
  factory SubcategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return SubcategoriesResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      code: json['code'] as int? ?? 0,
      data: SubcategoriesData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  /// Converts SubcategoriesResponseModel to JSON data
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
  String toString() {
    return 'SubcategoriesResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubcategoriesResponseModel &&
        other.success == success &&
        other.message == message &&
        other.code == code &&
        other.data == data &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      success.hashCode ^
      message.hashCode ^
      code.hashCode ^
      data.hashCode ^
      timestamp.hashCode;
}

/// Model for subcategories data section
/// Contains the categories list and pagination metadata
class SubcategoriesData {
  final List<CategoryModel> categories;
  final PaginationMeta meta;

  SubcategoriesData({required this.categories, required this.meta});

  /// Creates a SubcategoriesData from JSON data
  factory SubcategoriesData.fromJson(Map<String, dynamic> json) {
    return SubcategoriesData(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (item) => CategoryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  /// Converts SubcategoriesData to JSON data
  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  String toString() {
    return 'SubcategoriesData(categories: $categories, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubcategoriesData &&
        other.categories == categories &&
        other.meta == meta;
  }

  @override
  int get hashCode => categories.hashCode ^ meta.hashCode;
}

/// Model for pagination metadata
/// Contains pagination information for API responses
class PaginationMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  /// Creates a PaginationMeta from JSON data
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
    );
  }

  /// Converts PaginationMeta to JSON data
  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
    };
  }

  /// Checks if there are more pages available
  bool get hasNextPage => currentPage < lastPage;

  /// Checks if there are previous pages available
  bool get hasPreviousPage => currentPage > 1;

  /// Gets the next page number, returns null if no next page
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  /// Gets the previous page number, returns null if no previous page
  int? get previousPage => hasPreviousPage ? currentPage - 1 : null;

  @override
  String toString() {
    return 'PaginationMeta(currentPage: $currentPage, perPage: $perPage, total: $total, lastPage: $lastPage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationMeta &&
        other.currentPage == currentPage &&
        other.perPage == perPage &&
        other.total == total &&
        other.lastPage == lastPage;
  }

  @override
  int get hashCode =>
      currentPage.hashCode ^
      perPage.hashCode ^
      total.hashCode ^
      lastPage.hashCode;
}
