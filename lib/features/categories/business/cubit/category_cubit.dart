import 'package:baqalty/features/categories/data/models/categories_response_model.dart';
import 'package:baqalty/features/categories/data/services/categories_service.dart';
import 'package:baqalty/features/categories/data/services/categories_services_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());
  final CategoriesService _categoriesService = CategoriesServicesImpl();

  List<CategoryModel> _allCategories = [];
  String _currentSearchQuery = '';

  Future<void> getParentCategories() async {
    try {
      emit(CategoryLoading());
      final response = await _categoriesService.getParentCategories();
      if (response.status) {
        _allCategories = response.data!.data;
        emit(
          CategoryLoaded(
            categories: response.data!,
            filteredCategories: _allCategories,
            searchQuery: _currentSearchQuery,
          ),
        );
      } else {
        emit(CategoryError(message: response.message!));
      }
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  void searchCategories(String query) {
    _currentSearchQuery = query;

    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;

      if (query.isEmpty) {
        // Show all categories when search is empty
        emit(
          CategoryLoaded(
            categories: currentState.categories,
            filteredCategories: _allCategories,
            searchQuery: '',
          ),
        );
      } else {
        // Filter categories based on search query
        final filteredCategories = _allCategories.where((category) {
          return category.catName.toLowerCase().contains(query.toLowerCase()) ||
              (category.catDescription?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false);
        }).toList();

        emit(
          CategoryLoaded(
            categories: currentState.categories,
            filteredCategories: filteredCategories,
            searchQuery: query,
          ),
        );
      }
    }
  }

  void clearSearch() {
    searchCategories('');
  }
}
