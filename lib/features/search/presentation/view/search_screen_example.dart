import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/styles/styles.dart';
import '../widgets/search_grid_view.dart';
import '../../data/models/search_response_model.dart';

class SearchScreenExample extends StatefulWidget {
  const SearchScreenExample({super.key});

  @override
  State<SearchScreenExample> createState() => _SearchScreenExampleState();
}

class _SearchScreenExampleState extends State<SearchScreenExample> {
  final TextEditingController _searchController = TextEditingController();
  final   List<SearchProductModel> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Initialize search cubit if needed
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _products.clear();
    });

    // Here you would call your search service
    // For example: context.read<SearchCubit>().searchProducts(query);
    
    // Simulate search delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        // Add your search results here
        // _products = searchResults;
      });
    });
  }

  void _loadMore() {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });

    // Load more products
    // context.read<SearchCubit>().loadMoreProducts(_currentQuery, _currentPage);
    
    // Simulate loading more
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoadingMore = false;
        // Add more products to the list
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(
        title: "search".tr(),
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.all(4.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(3.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "search_hint".tr(),
                hintStyle: TextStyles.textViewRegular14.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 6.w,
                  ),
                  onPressed: () => _performSearch(_searchController.text),
                ),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          
          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 15.w,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "no_search_results".tr(),
                              style: TextStyles.textViewMedium16.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SearchGridView(
                        products: _products,
                        onLoadMore: _loadMore,
                        isLoadingMore: _isLoadingMore,
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
