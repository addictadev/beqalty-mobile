import 'dart:async';
import 'dart:developer';

import 'package:baqalty/features/categories/data/models/subcategory_products_response_model.dart';
import 'package:baqalty/features/categories/data/services/subcategory_products_service.dart';
import 'package:baqalty/features/categories/data/services/subcategory_products_service_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subcategory_products_state.dart';

class SubcategoryProductsCubit extends Cubit<SubcategoryProductsState> {
  SubcategoryProductsCubit() : super(SubcategoryProductsInitial());
  
  final SubcategoryProductsService _subcategoryProductsService = SubcategoryProductsServiceImpl();
  
  Timer? _searchDebounceTimer;
  String _currentSubcategoryId = '';
  String _currentSearchQuery = '';
  int _currentPage = 1;
  bool _hasMoreProducts = true;
  final List<ProductModel> _allProducts = [];

  /// Loads products for a specific subcategory
  Future<void> loadSubcategoryProducts(String subcategoryId) async {
    try {
      _currentSubcategoryId = subcategoryId;
      _currentPage = 1;
      _hasMoreProducts = true;
      _allProducts.clear();
      
      emit(SubcategoryProductsLoading());
      
      final response = await _subcategoryProductsService.getSubcategoryProducts(
        subcategoryId,
        search: _currentSearchQuery,
        perPage: 15,
        page: _currentPage,
      );
      
      if (response.status && response.data != null) {
        _allProducts.addAll(response.data!.data.products);
        _hasMoreProducts = response.data!.data.meta.hasNextPage;
        
        emit(SubcategoryProductsLoaded(
          products: List.from(_allProducts),
          subcategoryData: response.data!.data,
          hasMoreProducts: _hasMoreProducts,
          searchQuery: _currentSearchQuery,
        ));
        
        log('✅ SubcategoryProductsCubit: Successfully loaded ${_allProducts.length} products');
      } else {
        emit(SubcategoryProductsError(message: response.message ?? 'Failed to load products'));
        log('❌ SubcategoryProductsCubit: Failed to load products: ${response.message}');
      }
    } catch (e) {
      emit(SubcategoryProductsError(message: e.toString()));
      log('❌ SubcategoryProductsCubit: loadSubcategoryProducts failed: $e');
    }
  }

  /// Loads more products (pagination)
  Future<void> loadMoreProducts() async {
    if (!_hasMoreProducts || state is SubcategoryProductsLoading) return;
    
    try {
      _currentPage++;
      
      final response = await _subcategoryProductsService.getSubcategoryProducts(
        _currentSubcategoryId,
        search: _currentSearchQuery,
        perPage: 15,
        page: _currentPage,
      );
      
      if (response.status && response.data != null) {
        _allProducts.addAll(response.data!.data.products);
        _hasMoreProducts = response.data!.data.meta.hasNextPage;
        
        emit(SubcategoryProductsLoaded(
          products: List.from(_allProducts),
          subcategoryData: response.data!.data,
          hasMoreProducts: _hasMoreProducts,
          searchQuery: _currentSearchQuery,
        ));
        
        log('✅ SubcategoryProductsCubit: Loaded ${response.data!.data.products.length} more products');
      }
    } catch (e) {
      _currentPage--; // Revert page increment on error
      log('❌ SubcategoryProductsCubit: loadMoreProducts failed: $e');
    }
  }

  /// Searches products with debouncing
  void searchProducts(String query) {
    _currentSearchQuery = query;
    
    // Cancel previous timer
    _searchDebounceTimer?.cancel();
    
    // Set new timer for debouncing
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  /// Performs the actual search
  Future<void> _performSearch() async {
    if (_currentSubcategoryId.isEmpty) return;
    
    try {
      _currentPage = 1;
      _hasMoreProducts = true;
      _allProducts.clear();
      
      emit(SubcategoryProductsLoading());
      
      final response = await _subcategoryProductsService.getSubcategoryProducts(
        _currentSubcategoryId,
        search: _currentSearchQuery,
        perPage: 15,
        page: _currentPage,
      );
      
      if (response.status && response.data != null) {
        _allProducts.addAll(response.data!.data.products);
        _hasMoreProducts = response.data!.data.meta.hasNextPage;
        
        emit(SubcategoryProductsLoaded(
          products: List.from(_allProducts),
          subcategoryData: response.data!.data,
          hasMoreProducts: _hasMoreProducts,
          searchQuery: _currentSearchQuery,
        ));
        
        log('✅ SubcategoryProductsCubit: Search completed with ${_allProducts.length} results');
      } else {
        emit(SubcategoryProductsError(message: response.message ?? 'Search failed'));
        log('❌ SubcategoryProductsCubit: Search failed: ${response.message}');
      }
    } catch (e) {
      emit(SubcategoryProductsError(message: e.toString()));
      log('❌ SubcategoryProductsCubit: _performSearch failed: $e');
    }
  }

  /// Clears search and reloads all products
  void clearSearch() {
    _currentSearchQuery = '';
    _searchDebounceTimer?.cancel();
    loadSubcategoryProducts(_currentSubcategoryId);
  }

  /// Refreshes the current products list
  Future<void> refreshProducts() async {
    if (_currentSubcategoryId.isEmpty) return;
    await loadSubcategoryProducts(_currentSubcategoryId);
  }

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }
}
