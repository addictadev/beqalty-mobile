/// Model for categories API response data
/// Contains the complete response structure from the categories/parents API endpoint
class CategoriesResponseModel {
  final bool success;
  final String message;
  final int code;
  final List<CategoryModel> data;
  final String timestamp;

  CategoriesResponseModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
    required this.timestamp,
  });

  /// Creates a CategoriesResponseModel from JSON data
  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      code: json['code'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => CategoryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  /// Converts CategoriesResponseModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.map((item) => item.toJson()).toList(),
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'CategoriesResponseModel(success: $success, message: $message, code: $code, data: $data, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoriesResponseModel &&
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

/// Model for individual category data
/// Contains category information from the categories/parents API
class CategoryModel {
  final int catId;
  final String catName;
  final String? catImage;
  final String? catDescription;

  CategoryModel({
    required this.catId,
    required this.catName,
    this.catImage,
    this.catDescription,
  });

  /// Creates a CategoryModel from JSON data
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      catId: json['cat_id'] as int? ?? 0,
      catName: json['cat_name'] as String? ?? '',
      catImage: json['cat_image'] as String?,
      catDescription: json['cat_description'] as String?,
    );
  }

  /// Converts CategoryModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'cat_id': catId,
      'cat_name': catName,
      'cat_image': catImage,
      'cat_description': catDescription,
    };
  }

  /// Gets a placeholder image URL if catImage is null
  String get displayImage => catImage ?? '';

  /// Checks if the category has an image
  bool get hasImage => catImage != null && catImage!.isNotEmpty;

  @override
  String toString() {
    return 'CategoryModel(catId: $catId, catName: $catName, catImage: $catImage, catDescription: $catDescription)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel &&
        other.catId == catId &&
        other.catName == catName &&
        other.catImage == catImage &&
        other.catDescription == catDescription;
  }

  @override
  int get hashCode =>
      catId.hashCode ^
      catName.hashCode ^
      catImage.hashCode ^
      catDescription.hashCode;
}
