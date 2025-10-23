import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/product_details_response_model.dart';
import '../../data/models/like_product_request_model.dart';
import '../../data/services/product_details_service.dart';

part 'product_details_state.dart';

/// Cubit for managing product details state
/// Handles loading, displaying, and error states for product details
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsService _productDetailsService;

  ProductDetailsCubit(this._productDetailsService) : super(ProductDetailsInitial());

  /// Fetches product details by product ID
  /// 
  /// [productId] - The unique identifier of the product to fetch
  /// 
  /// Emits [ProductDetailsLoading] while fetching
  /// Emits [ProductDetailsLoaded] on success with product data
  /// Emits [ProductDetailsError] on failure with error message
  Future<void> getProductDetails(int productId) async {
    try {
      emit(ProductDetailsLoading());

      final response = await _productDetailsService.getProductDetails(productId);

      if (response.status && response.data != null) {
        emit(ProductDetailsLoaded(productDetails: response.data!.data));
      } else {
        emit(ProductDetailsError(
          message: response.message ?? 'Failed to load product details',
        ));
      }
    } catch (e) {
      emit(ProductDetailsError(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Likes a product by making API call
  /// 
  /// [productId] - The unique identifier of the product to like
  /// 
  /// Emits [ProductFavoriteLoading] while processing
  /// Emits [ProductDetailsLoaded] with updated product data on success
  /// Emits [ProductDetailsError] on failure with error message
  Future<void> likeProduct(int productId) async {
    try {
      final request = LikeProductRequestModel(productId: productId);
      final response = await _productDetailsService.likeProduct(request);

      if (response.status && response.data != null) {
        // Store current product details before emitting success state
        ProductDetailsDataModel? currentProduct;
        if (state is ProductDetailsLoaded) {
          currentProduct = (state as ProductDetailsLoaded).productDetails;
        } else if (state is ProductLiked) {
          currentProduct = (state as ProductLiked).productDetails;
        } else if (state is ProductUnliked) {
          currentProduct = (state as ProductUnliked).productDetails;
        } else {
        }
        
        // Update the product details with new favorite status
        if (currentProduct != null) {
          final updatedProduct = ProductDetailsDataModel(
            id: currentProduct.id,
            name: currentProduct.name,
            description: currentProduct.description,
            baseImage: currentProduct.baseImage,
            images: currentProduct.images,
            basePrice: currentProduct.basePrice,
            dicount: currentProduct.dicount,
            finalPrice: currentProduct.finalPrice,
            quantity: currentProduct.quantity,
            isLiked: true, // Update to liked
            attributes: currentProduct.attributes,
            relatedProducts: currentProduct.relatedProducts,
          );
          // Emit ProductDetailsLoaded with updated data first
          emit(ProductDetailsLoaded(productDetails: updatedProduct));
          // Then emit success message
          emit(ProductLiked(message: response.data!.message, productDetails: updatedProduct));
        }
      } else {
        emit(ProductDetailsError(
          message: response.message ?? 'Failed to like product',
        ));
      }
    } catch (e) {
      emit(ProductDetailsError(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Unlikes a product by making API call
  /// 
  /// [productId] - The unique identifier of the product to unlike
  /// 
  /// Emits [ProductFavoriteLoading] while processing
  /// Emits [ProductDetailsLoaded] with updated product data on success
  /// Emits [ProductDetailsError] on failure with error message
  Future<void> unlikeProduct(int productId) async {
    try {
      final request = LikeProductRequestModel(productId: productId);
      final response = await _productDetailsService.unlikeProduct(request);

      if (response.status && response.data != null) {
        // Store current product details before emitting success state
        ProductDetailsDataModel? currentProduct;
        if (state is ProductDetailsLoaded) {
          currentProduct = (state as ProductDetailsLoaded).productDetails;
        } else if (state is ProductLiked) {
          currentProduct = (state as ProductLiked).productDetails;
        } else if (state is ProductUnliked) {
          currentProduct = (state as ProductUnliked).productDetails;
        } else {
        }
        
        // Update the product details with new favorite status
        if (currentProduct != null) {
          final updatedProduct = ProductDetailsDataModel(
            id: currentProduct.id,
            name: currentProduct.name,
            description: currentProduct.description,
            baseImage: currentProduct.baseImage,
            images: currentProduct.images,
            basePrice: currentProduct.basePrice,
            dicount: currentProduct.dicount,
            finalPrice: currentProduct.finalPrice,
            quantity: currentProduct.quantity,
            isLiked: false, // Update to unliked
            attributes: currentProduct.attributes,
            relatedProducts: currentProduct.relatedProducts,
          );
          // Emit ProductDetailsLoaded with updated data first
          emit(ProductDetailsLoaded(productDetails: updatedProduct));
          // Then emit success message
          emit(ProductUnliked(message: response.data!.message, productDetails: updatedProduct));
        }
      } else {
        emit(ProductDetailsError(
          message: response.message ?? 'Failed to unlike product',
        ));
      }
    } catch (e) {
      emit(ProductDetailsError(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Toggles the favorite status of the current product
  /// 
  /// [productDetails] - The current product details
  /// 
  /// Calls likeProduct or unlikeProduct based on current favorite status
  Future<void> toggleFavorite(ProductDetailsDataModel productDetails) async {
    if (productDetails.isLiked) {
      await unlikeProduct(productDetails.id);
    } else {
      await likeProduct(productDetails.id);
    }
  }

  /// Resets the state to initial
  void reset() {
    emit(ProductDetailsInitial());
  }
}
