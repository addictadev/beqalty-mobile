import 'package:equatable/equatable.dart';

class WalletTransactionsResponseModel extends Equatable {
  final bool success;
  final String message;
  final WalletTransactionsDataModel data;
  final int code;

  const WalletTransactionsResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.code,
  });

  factory WalletTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: WalletTransactionsDataModel.fromJson(json['data'] as Map<String, dynamic>),
      code: json['code'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'code': code,
    };
  }

  @override
  List<Object?> get props => [success, message, data, code];
}

class WalletTransactionsDataModel extends Equatable {
  final String balance;
  final List<WalletTransactionModel> transactions;

  const WalletTransactionsDataModel({
    required this.balance,
    required this.transactions,
  });

  factory WalletTransactionsDataModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionsDataModel(
      balance: json['balance'] as String,
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [balance, transactions];
}

class WalletTransactionModel extends Equatable {
  final int id;
  final int walletId;
  final int requestId;
  final String requestType;
  final String amount;
  final String type;
  final String reason;
  final String createdAt;
  final String updatedAt;

  const WalletTransactionModel({
    required this.id,
    required this.walletId,
    required this.requestId,
    required this.requestType,
    required this.amount,
    required this.type,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as int,
      walletId: json['wallet_id'] as int,
      requestId: json['request_id'] as int,
      requestType: json['request_type'] as String,
      amount: json['amount'] as String,
      type: json['type'] as String,
      reason: json['reason'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'request_id': requestId,
      'request_type': requestType,
      'amount': amount,
      'type': type,
      'reason': reason,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        walletId,
        requestId,
        requestType,
        amount,
        type,
        reason,
        createdAt,
        updatedAt,
      ];
}
