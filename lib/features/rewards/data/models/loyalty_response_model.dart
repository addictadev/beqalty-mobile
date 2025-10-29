import 'package:equatable/equatable.dart';

class LoyaltyResponseModel extends Equatable {
  final bool success;
  final String message;
  final LoyaltyDataModel data;
  final int code;

  const LoyaltyResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory LoyaltyResponseModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: LoyaltyDataModel.fromJson(json['data'] as Map<String, dynamic>),
      code: json['code'] as int,
    );
  }

  @override
  List<Object?> get props => [success, message, data, code];
}

class LoyaltyDataModel extends Equatable {
  final int balance;
  final List<LoyaltyTransactionModel> transactions;

  const LoyaltyDataModel({
    required this.balance,
    required this.transactions,
  });

  factory LoyaltyDataModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyDataModel(
      balance: json['balance'] as int,
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => LoyaltyTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [balance, transactions];
}

class LoyaltyTransactionModel extends Equatable {
  final int id;
  final String titleAr;
  final String titleEn;
  final String type;
  final String pricePoints;
  final String value;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LoyaltyTransactionModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.type,
    required this.pricePoints,
    required this.value,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransactionModel(
      id: json['id'] as int,
      titleAr: json['title_ar'] as String,
      titleEn: json['title_en'] as String,
      type: json['type'] as String,
      pricePoints: json['price_points'] as String,
      value: json['value'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleAr,
        titleEn,
        type,
        pricePoints,
        value,
        isActive,
        createdAt,
        updatedAt,
      ];
}
