import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  failed,
  cancelled,
}

class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final int itemCount;
  final OrderStatus status;
  final String? estimatedTime;
  final double totalAmount;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.itemCount,
    required this.status,
    this.estimatedTime,
    required this.totalAmount,
    required this.items,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.failed:
        return 'failed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFC107); // Warning yellow
      case OrderStatus.confirmed:
        return const Color(0xFF3B82F6); // Info blue
      case OrderStatus.preparing:
        return const Color(0xFF8B5CF6); // Purple
      case OrderStatus.outForDelivery:
        return const Color(0xFF3B82F6); // Blue
      case OrderStatus.delivered:
        return const Color(0xFF10B981); // Success green
      case OrderStatus.failed:
        return const Color(0xFFEF4444); // Error red
      case OrderStatus.cancelled:
        return const Color(0xFF6B7280); // Gray
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(orderDate);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    }
  }

  String get formattedTime {
    return '${orderDate.hour.toString().padLeft(2, '0')}:${orderDate.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        orderDate,
        itemCount,
        status,
        estimatedTime,
        totalAmount,
        items,
      ];
}

class OrderItemModel extends Equatable {
  final String id;
  final String name;
  final String image;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, image, quantity, price];
}
