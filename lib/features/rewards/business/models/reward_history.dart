import 'package:equatable/equatable.dart';

enum TransactionType { earned, redeemed }

class RewardHistory extends Equatable {
  final String id;
  final String title;
  final String description;
  final int points;
  final TransactionType type;
  final String iconPath;
  final DateTime date;
  final bool isCompleted;

  const RewardHistory({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.type,
    required this.iconPath,
    required this.date,
    this.isCompleted = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    points,
    type,
    iconPath,
    date,
    isCompleted,
  ];

  RewardHistory copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    TransactionType? type,
    String? iconPath,
    DateTime? date,
    bool? isCompleted,
  }) {
    return RewardHistory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      type: type ?? this.type,
      iconPath: iconPath ?? this.iconPath,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'type': type.name,
      'iconPath': iconPath,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory RewardHistory.fromJson(Map<String, dynamic> json) {
    return RewardHistory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: json['points'] as int,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.earned,
      ),
      iconPath: json['iconPath'] as String,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool? ?? true,
    );
  }
}
