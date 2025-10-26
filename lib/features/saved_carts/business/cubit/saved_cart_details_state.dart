part of 'saved_cart_details_cubit.dart';

sealed class SavedCartDetailsState extends Equatable {
  const SavedCartDetailsState();

  @override
  List<Object?> get props => [];
}

final class SavedCartDetailsInitial extends SavedCartDetailsState {}

final class SavedCartDetailsLoading extends SavedCartDetailsState {}

final class SavedCartDetailsLoaded extends SavedCartDetailsState {
  final SavedCartDetailsDataModel cartDetails;

  const SavedCartDetailsLoaded({required this.cartDetails});

  @override
  List<Object?> get props => [cartDetails];
}

final class SavedCartDetailsError extends SavedCartDetailsState {
  final String message;

  const SavedCartDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SavedCartDetailsUpdated extends SavedCartDetailsState {
  final SavedCartDetailsResponseModel cartDetails;

  const SavedCartDetailsUpdated({required this.cartDetails});

  @override
  List<Object?> get props => [cartDetails];
}

final class SavedCartDetailsItemRemoved extends SavedCartDetailsState {
  final SavedCartDetailsResponseModel cartDetails;

  const SavedCartDetailsItemRemoved({required this.cartDetails});

  @override
  List<Object?> get props => [cartDetails];
}
