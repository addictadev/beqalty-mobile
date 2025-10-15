part of 'subcategory_products_cubit.dart';

sealed class SubcategoryProductsState extends Equatable {
  const SubcategoryProductsState();

  @override
  List<Object?> get props => [];
}

final class SubcategoryProductsInitial extends SubcategoryProductsState {}

final class SubcategoryProductsLoading extends SubcategoryProductsState {}

final class SubcategoryProductsLoaded extends SubcategoryProductsState {
  final List<ProductModel> products;
  final SubcategoryProductsData subcategoryData;
  final bool hasMoreProducts;
  final String searchQuery;

  const SubcategoryProductsLoaded({
    required this.products,
    required this.subcategoryData,
    required this.hasMoreProducts,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [products, subcategoryData, hasMoreProducts, searchQuery];

  SubcategoryProductsLoaded copyWith({
    List<ProductModel>? products,
    SubcategoryProductsData? subcategoryData,
    bool? hasMoreProducts,
    String? searchQuery,
  }) {
    return SubcategoryProductsLoaded(
      products: products ?? this.products,
      subcategoryData: subcategoryData ?? this.subcategoryData,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final class SubcategoryProductsError extends SubcategoryProductsState {
  final String message;

  const SubcategoryProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
