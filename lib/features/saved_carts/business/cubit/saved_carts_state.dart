part of 'saved_carts_cubit.dart';

/// Base state for saved carts
abstract class SavedCartsState extends Equatable {
  const SavedCartsState();

  @override
  List<Object> get props => [];
}

/// Initial state when the cubit is first created
final class SavedCartsInitial extends SavedCartsState {
  const SavedCartsInitial();
}

/// State when saved carts are being loaded
final class SavedCartsLoading extends SavedCartsState {
  const SavedCartsLoading();
}

/// State when saved carts are successfully loaded
final class SavedCartsLoaded extends SavedCartsState {
  final List<SavedCartDataModel> savedCarts;

  const SavedCartsLoaded({required this.savedCarts});

  @override
  List<Object> get props => [savedCarts];

  @override
  String toString() => 'SavedCartsLoaded(savedCarts: ${savedCarts.length} items)';
}

/// State when there's an error loading saved carts
final class SavedCartsError extends SavedCartsState {
  final String message;

  const SavedCartsError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SavedCartsError(message: $message)';
}

/// State when creating a new saved cart
final class CreateSavedCartLoading extends SavedCartsState {
  const CreateSavedCartLoading();
}

/// State when saved cart is successfully created
final class CreateSavedCartSuccess extends SavedCartsState {
  final CreateSavedCartDataModel cartData;

  const CreateSavedCartSuccess({required this.cartData});

  @override
  List<Object> get props => [cartData];

  @override
  String toString() => 'CreateSavedCartSuccess(cartData: $cartData)';
}

/// State when there's an error creating saved cart
final class CreateSavedCartError extends SavedCartsState {
  final String message;

  const CreateSavedCartError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CreateSavedCartError(message: $message)';
}

/// State when deleting a saved cart
final class DeleteSavedCartLoading extends SavedCartsState {
  const DeleteSavedCartLoading();
}

/// State when saved cart is successfully deleted
final class DeleteSavedCartSuccess extends SavedCartsState {
  final int deletedCartId;

  const DeleteSavedCartSuccess({required this.deletedCartId});

  @override
  List<Object> get props => [deletedCartId];

  @override
  String toString() => 'DeleteSavedCartSuccess(deletedCartId: $deletedCartId)';
}

/// State when there's an error deleting saved cart
final class DeleteSavedCartError extends SavedCartsState {
  final String message;

  const DeleteSavedCartError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteSavedCartError(message: $message)';
}
