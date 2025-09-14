import 'package:equatable/equatable.dart';

class SavedItemModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final String image;
  final double price;
  final String currency;
  final DateTime savedAt;

  const SavedItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    this.currency = 'EGP',
    required this.savedAt,
  });

  String get formattedPrice {
    return '${price.toStringAsFixed(2)} $currency';
  }

  String get formattedSavedAt {
    final now = DateTime.now();
    final difference = now.difference(savedAt);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${savedAt.day}/${savedAt.month}/${savedAt.year}';
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    image,
    price,
    currency,
    savedAt,
  ];
}
