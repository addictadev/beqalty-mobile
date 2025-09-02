import 'package:equatable/equatable.dart';

class RewardOffer extends Equatable {
  final String id;
  final String title;
  final int pointsRequired;
  final String description;
  final String iconPath;
  final bool isActive;

  const RewardOffer({
    required this.id,
    required this.title,
    required this.pointsRequired,
    required this.description,
    required this.iconPath,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    pointsRequired,
    description,
    iconPath,
    isActive,
  ];

  RewardOffer copyWith({
    String? id,
    String? title,
    int? pointsRequired,
    String? description,
    String? iconPath,
    bool? isActive,
  }) {
    return RewardOffer(
      id: id ?? this.id,
      title: title ?? this.title,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'pointsRequired': pointsRequired,
      'description': description,
      'iconPath': iconPath,
      'isActive': isActive,
    };
  }

  factory RewardOffer.fromJson(Map<String, dynamic> json) {
    return RewardOffer(
      id: json['id'] as String,
      title: json['title'] as String,
      pointsRequired: json['pointsRequired'] as int,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
