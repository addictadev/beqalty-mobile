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
