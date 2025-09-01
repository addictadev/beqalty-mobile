part of 'nav_bar_cubit.dart';

sealed class NavBarState extends Equatable {
  const NavBarState();

  @override
  List<Object> get props => [];
}

final class NavBarInitial extends NavBarState {}

final class NavBarLoaded extends NavBarState {
  final List<NavItemModel> navItems;
  final int currentIndex;

  const NavBarLoaded({required this.navItems, required this.currentIndex});

  @override
  List<Object> get props => [navItems, currentIndex];
}
