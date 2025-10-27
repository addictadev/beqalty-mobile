import 'package:equatable/equatable.dart';

class PointsTransactionsResponseModel extends Equatable {
  final bool success;
  final String message;
  final PointsTransactionsDataModel data;
  final int code;

  const PointsTransactionsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory PointsTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    return PointsTransactionsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: PointsTransactionsDataModel.fromJson(json['data'] as Map<String, dynamic>),
      code: json['code'] as int,
    );
  }

  @override
  List<Object?> get props => [success, message, data, code];
}

class PointsTransactionsDataModel extends Equatable {
  final int balance;
  final List<PointsTransactionModel> transactions;

  const PointsTransactionsDataModel({
    required this.balance,
    required this.transactions,
  });

  factory PointsTransactionsDataModel.fromJson(Map<String, dynamic> json) {
    return PointsTransactionsDataModel(
      balance: json['balance'] as int,
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => PointsTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [balance, transactions];
}

class PointsTransactionModel extends Equatable {
  final int id;
  final int pointId;
  final int requestId;
  final String requestType;
  final int points;
  final String pointStatus;
  final String? validUntil;
  final String type;
  final String reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PointsTransactionModel({
    required this.id,
    required this.pointId,
    required this.requestId,
    required this.requestType,
    required this.points,
    required this.pointStatus,
    this.validUntil,
    required this.type,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PointsTransactionModel.fromJson(Map<String, dynamic> json) {
    return PointsTransactionModel(
      id: json['id'] as int,
      pointId: json['point_id'] as int,
      requestId: json['request_id'] as int,
      requestType: json['request_type'] as String,
      points: json['points'] as int,
      pointStatus: json['point_status'] as String,
      validUntil: json['valid_until'] as String?,
      type: json['type'] as String,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        pointId,
        requestId,
        requestType,
        points,
        pointStatus,
        validUntil,
        type,
        reason,
        createdAt,
        updatedAt,
      ];
}
