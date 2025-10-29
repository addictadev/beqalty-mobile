import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/search_response_model.dart';
import '../../data/services/search_service.dart';

/// Cubit for managing search state and operations
/// Handles search functionality with pagination support
class SearchCubit extends Cubit<SearchState> {
  final SearchService _searchService;

  SearchCubit({required SearchService searchService})
      : _searchService = searchService,
        super(SearchInitial());

  /// Search for products with the given query
  /// 
  /// [query] - The search term
  /// [page] - The page number for pagination (default: 1)
  /// [perPage] - Number of items per page (default: 15)
  Future<void> searchProducts({
    required String query,
    int page = 1,
    int perPage = 15,
  }) async {
    if (query.trim().isEmpty) {
      emit(SearchEmpty());
      return;
    }

    try {
      if (page == 1) {
        emit(SearchLoading());
      } else {
        // For pagination, keep existing data and show loading for more items
        if (state is SearchLoaded) {
          final currentState = state as SearchLoaded;
          emit(SearchLoadingMore(
            products: currentState.products,
            warehouse: currentState.warehouse,
            meta: currentState.meta,
          ));
        } else {
          emit(SearchLoading());
        }
      }

      final response = await _searchService.searchProducts(
        searchQuery: query,
        page: page,
        perPage: perPage,
      );

      if (page == 1) {
        // First page - replace all data
        if (response.data.products.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchLoaded(
            products: response.data.products,
            warehouse: response.data.warehouse,
            meta: response.data.meta,
            query: query,
          ));
        }
        } else {
          // Pagination - append new products to existing ones
          if (state is SearchLoaded) {
            final currentState = state as SearchLoaded;
            
            final allProducts = List<SearchProductModel>.from(currentState.products)
              ..addAll(response.data.products);
            
            emit(SearchLoaded(
              products: allProducts,
              warehouse: response.data.warehouse,
              meta: response.data.meta,
              query: query,
            ));
          } else if (state is SearchLoadingMore) {
            final currentState = state as SearchLoadingMore;
            
            final allProducts = List<SearchProductModel>.from(currentState.products)
              ..addAll(response.data.products);
            
            emit(SearchLoaded(
              products: allProducts,
              warehouse: response.data.warehouse,
              meta: response.data.meta,
              query: query,
            ));
          }
        }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  /// Load more products for pagination
  /// 
  /// [perPage] - Number of items per page (default: 15)
  Future<void> loadMoreProducts({int perPage = 15}) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      if (currentState.meta.hasNextPage) {
        await searchProducts(
          query: currentState.query,
          page: currentState.meta.currentPage + 1,
          perPage: perPage,
        );
      }
    }
  }

  /// Clear search results
  void clearSearch() {
    emit(SearchInitial());
  }

  /// Reset search to initial state
  void resetSearch() {
    emit(SearchInitial());
  }
}

/// Base state class for search functionality
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no search has been performed
class SearchInitial extends SearchState {}

/// State when search is loading (first page)
class SearchLoading extends SearchState {}

/// State when loading more items for pagination
class SearchLoadingMore extends SearchState {
  final List<SearchProductModel> products;
  final SearchWarehouseModel warehouse;
  final SearchMetaModel meta;

  const SearchLoadingMore({
    required this.products,
    required this.warehouse,
    required this.meta,
  });

  @override
  List<Object?> get props => [products, warehouse, meta];
}

/// State when search results are successfully loaded
class SearchLoaded extends SearchState {
  final List<SearchProductModel> products;
  final SearchWarehouseModel warehouse;
  final SearchMetaModel meta;
  final String query;

  const SearchLoaded({
    required this.products,
    required this.warehouse,
    required this.meta,
    required this.query,
  });

  @override
  List<Object?> get props => [products, warehouse, meta, query];
}

/// State when search returns no results
class SearchEmpty extends SearchState {}

/// State when search encounters an error
class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
