part of 'product_details_cubit.dart';

/// Base class for all product details states
/// Uses sealed class to ensure exhaustive pattern matching
sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

/// Initial state when the cubit is first created
/// No product data is loaded yet
final class ProductDetailsInitial extends ProductDetailsState {}

/// Loading state when fetching product details from API
/// Shows loading indicator to user
final class ProductDetailsLoading extends ProductDetailsState {}

/// Loading state when performing favorite operations (like/unlike)
/// Shows loading indicator on favorite button
final class ProductFavoriteLoading extends ProductDetailsState {}

/// Loaded state when product details are successfully fetched
/// Contains the product details data
final class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsDataModel productDetails;

  const ProductDetailsLoaded({required this.productDetails});

  @override
  List<Object> get props => [productDetails];

  @override
  String toString() => 'ProductDetailsLoaded(productDetails: $productDetails)';
}

/// Error state when product details fetch fails
/// Contains error message to display to user
final class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ProductDetailsError(message: $message)';
}

/// State when a product is successfully liked
/// Contains the success message from the API and updated product details
final class ProductLiked extends ProductDetailsState {
  final String message;
  final ProductDetailsDataModel productDetails;

  const ProductLiked({required this.message, required this.productDetails});

  @override
  List<Object> get props => [message, productDetails];

  @override
  String toString() => 'ProductLiked(message: $message, productDetails: $productDetails)';
}

/// State when a product is successfully unliked
/// Contains the success message from the API and updated product details
final class ProductUnliked extends ProductDetailsState {
  final String message;
  final ProductDetailsDataModel productDetails;

  const ProductUnliked({required this.message, required this.productDetails});

  @override
  List<Object> get props => [message, productDetails];

  @override
  String toString() => 'ProductUnliked(message: $message, productDetails: $productDetails)';
}
