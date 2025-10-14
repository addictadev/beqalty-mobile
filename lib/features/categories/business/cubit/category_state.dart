part of 'category_cubit.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final CategoriesResponseModel categories;
  final List<CategoryModel> filteredCategories;
  final String searchQuery;

  const CategoryLoaded({
    required this.categories,
    required this.filteredCategories,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [categories, filteredCategories, searchQuery];
}

final class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object> get props => [message];
}

final class SubCategoryLoading extends CategoryState {}

final class SubCategoryLoaded extends CategoryState {
  final SubcategoriesResponseModel subcategories;
  final List<CategoryModel> allSubcategories;
  final bool hasMore;
  final int currentPage;
  final String searchQuery;

  const SubCategoryLoaded({
    required this.subcategories,
    required this.allSubcategories,
    required this.hasMore,
    required this.currentPage,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [
    subcategories,
    allSubcategories,
    hasMore,
    currentPage,
    searchQuery,
  ];
}

final class SubCategoryError extends CategoryState {
  final String message;

  const SubCategoryError({required this.message});
}
