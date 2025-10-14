import 'package:baqalty/features/categories/data/models/categories_response_model.dart';
import 'package:baqalty/features/categories/data/models/subcategories_response_model.dart';
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

  List<CategoryModel> _allSubcategories = [];
  String _currentSubcategorySearchQuery = '';
  int _currentSubcategoryPage = 1;
  bool _hasMoreSubcategories = true;
  String? _currentParentId;

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
        emit(
          CategoryLoaded(
            categories: currentState.categories,
            filteredCategories: _allCategories,
            searchQuery: '',
          ),
        );
      } else {
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

  Future<void> getSubcategories(String parentId, {String search = ''}) async {
    try {
      emit(SubCategoryLoading());

      _currentParentId = parentId;
      _currentSubcategoryPage = 1;
      _currentSubcategorySearchQuery = search;
      _hasMoreSubcategories = true;

      final response = await _categoriesService.getSubcategories(
        parentId,
        page: _currentSubcategoryPage,
        perPage: 10,
        search: search,
      );

      if (response.status && response.data != null) {
        _allSubcategories = response.data!.data.categories;
        _hasMoreSubcategories = response.data!.data.meta.hasNextPage;

        emit(
          SubCategoryLoaded(
            subcategories: response.data!,
            allSubcategories: _allSubcategories,
            hasMore: _hasMoreSubcategories,
            currentPage: _currentSubcategoryPage,
            searchQuery: search,
          ),
        );
      } else {
        emit(
          SubCategoryError(
            message: response.message ?? 'Failed to load subcategories',
          ),
        );
      }
    } catch (e) {
      emit(SubCategoryError(message: e.toString()));
    }
  }

  Future<void> loadMoreSubcategories() async {
    if (!_hasMoreSubcategories || _currentParentId == null) return;

    try {
      _currentSubcategoryPage++;

      final response = await _categoriesService.getSubcategories(
        _currentParentId!,
        page: _currentSubcategoryPage,
        perPage: 10,
        search: _currentSubcategorySearchQuery,
      );

      if (response.status && response.data != null) {
        _allSubcategories.addAll(response.data!.data.categories);
        _hasMoreSubcategories = response.data!.data.meta.hasNextPage;

        final updatedResponse = SubcategoriesResponseModel(
          success: response.data!.success,
          message: response.data!.message,
          code: response.data!.code,
          data: SubcategoriesData(
            categories: _allSubcategories,
            meta: response.data!.data.meta,
          ),
          timestamp: response.data!.timestamp,
        );

        emit(
          SubCategoryLoaded(
            subcategories: updatedResponse,
            allSubcategories: _allSubcategories,
            hasMore: _hasMoreSubcategories,
            currentPage: _currentSubcategoryPage,
            searchQuery: _currentSubcategorySearchQuery,
          ),
        );
      } else {
        _currentSubcategoryPage--;
        emit(
          SubCategoryError(
            message: response.message ?? 'Failed to load more subcategories',
          ),
        );
      }
    } catch (e) {
      _currentSubcategoryPage--;
      emit(SubCategoryError(message: e.toString()));
    }
  }

  Future<void> searchSubcategories(String query) async {
    if (_currentParentId == null) return;

    _currentSubcategoryPage = 1;
    _currentSubcategorySearchQuery = query;
    _hasMoreSubcategories = true;

    await getSubcategories(_currentParentId!, search: query);
  }

  Future<void> clearSubcategorySearch() async {
    if (_currentParentId == null) return;
    await searchSubcategories('');
  }
}
