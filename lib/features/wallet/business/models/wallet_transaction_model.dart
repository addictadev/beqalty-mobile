import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum TransactionType { deposit, withdrawal, purchase, refund }

class WalletTransactionModel extends Equatable {
  final String id;
  final String transactionId;
  final TransactionType type;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final String? description;

  const WalletTransactionModel({
    required this.id,
    required this.transactionId,
    required this.type,
    required this.amount,
    this.currency = 'EGP',
    required this.timestamp,
    this.description,
  });

  String get formattedAmount {
    final sign = type == TransactionType.withdrawal || type == TransactionType.purchase ? '-' : '+';
    return '$sign${amount.toStringAsFixed(0)} $currency';
  }

  String get formattedTimestamp {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (transactionDate == today) {
      // Format as time for today
      final hour = timestamp.hour.toString().padLeft(2, '0');
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = timestamp.hour < 12 ? 'AM' : 'PM';
      final displayHour = timestamp.hour == 0 ? 12 : (timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour);
      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } else if (transactionDate == yesterday) {
      // Format as date for yesterday
      final day = timestamp.day.toString().padLeft(2, '0');
      final month = timestamp.month.toString().padLeft(2, '0');
      final year = timestamp.year;
      return '$day $month $year';
    } else {
      // Format as date for older transactions
      final day = timestamp.day.toString().padLeft(2, '0');
      final month = timestamp.month.toString().padLeft(2, '0');
      final year = timestamp.year;
      return '$day $month $year';
    }
  }

  bool get isPositive {
    return type == TransactionType.deposit || type == TransactionType.refund;
  }

  Color get amountColor {
    return isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
  }

  @override
  List<Object?> get props => [
        id,
        transactionId,
        type,
        amount,
        currency,
        timestamp,
        description,
      ];
}
