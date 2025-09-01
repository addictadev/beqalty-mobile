import 'package:equatable/equatable.dart';

class NavItemModel extends Equatable {
  final int index;
  final String icon;
  final String activeIcon;
  final String label;
  final bool isActive;

  const NavItemModel({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isActive = false,
  });

  NavItemModel copyWith({
    int? index,
    String? icon,
    String? activeIcon,
    String? label,
    bool? isActive,
  }) {
    return NavItemModel(
      index: index ?? this.index,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [index, icon, activeIcon, label, isActive];
}
