import 'package:equatable/equatable.dart';

class SavedCartModel extends Equatable {
  final String id;
  final String name;
  final int itemCount;
  final DateTime lastModified;
  final double totalAmount;
  final List<SavedCartItemModel> items;

  const SavedCartModel({
    required this.id,
    required this.name,
    required this.itemCount,
    required this.lastModified,
    required this.totalAmount,
    required this.items,
  });

  String get formattedLastModified {
    final now = DateTime.now();
    final difference = now.difference(lastModified);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${lastModified.day}/${lastModified.month}/${lastModified.year}';
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    itemCount,
    lastModified,
    totalAmount,
    items,
  ];
}

class SavedCartItemModel extends Equatable {
  final String id;
  final String name;
  final String image;
  final int quantity;
  final double price;

  const SavedCartItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, image, quantity, price];
}
