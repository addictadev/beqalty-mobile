import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart'
    show AuthBackgroundWidget;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/di/service_locator.dart';
import '../../business/cubit/search_cubit.dart';
import '../../data/services/search_service.dart';
import '../../data/models/search_response_model.dart';
import '../../../product_details/business/cubit/product_details_cubit.dart';
import '../../../product_details/data/services/product_details_service.dart';
import '../../../cart/business/cubit/cart_cubit.dart';
import '../../../cart/data/services/cart_service.dart';
import '../widgets/empty_list.dart';
import '../widgets/search_grid_view.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late SearchCubit _searchCubit;
  
  // Track favorite status locally for each product
  final Map<int, bool> _favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchCubit(searchService: SearchServiceImpl());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _searchCubit.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>(
          create: (context) => _searchCubit,
        ),
        BlocProvider<ProductDetailsCubit>(
          create: (context) => ProductDetailsCubit(
            ServiceLocator.get<ProductDetailsService>(),
          ),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(
            ServiceLocator.get<CartService>(),
          ),
        ),
      ],
      child: BlocListener<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocListener<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartItemAdded) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text("item_added_to_cart".tr()),
              //     backgroundColor: AppColors.success,
              //   ),
              // );
            } else if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: AuthBackgroundWidget(
              child: SafeArea(
                child: Column(
                  children: [
                    // Search Header
                    SizedBox(height: context.responsiveMargin),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsivePadding,
                        vertical: context.responsiveMargin,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "search".tr(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: context.responsiveMargin),
                          // Search Field
                          CustomTextFormField(
                            controller: _searchController,
                            hint: "search_products".tr(),
                            borderColor: AppColors.borderLight,
                            prefixIcon: Icon(
                              Iconsax.search_normal,
                              color: AppColors.textSecondary,
                            ),
                            onChanged: (value) {
                              if (value.trim().isNotEmpty) {
                                _searchCubit.searchProducts(query: value.trim());
                              } else {
                                _searchCubit.clearSearch();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Search Results
                    Expanded(child: _buildSearchResults(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return _buildInitialState(context);
        } else if (state is SearchLoading) {
          return _buildLoadingState(context);
        } else if (state is SearchLoadingMore) {
          return _buildLoadedState(
            context,
            state.products,
            state.warehouse,
            state.meta,
            isLoadingMore: true,
          );
        } else if (state is SearchLoaded) {
          return _buildLoadedState(
            context,
            state.products,
            state.warehouse,
            state.meta,
            query: state.query,
          );
        } else if (state is SearchEmpty) {
          return BuildEmptyState(context);
        } else if (state is SearchError) {
          return _buildErrorState(context, state.message);
        }
        return _buildInitialState(context);
      },
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageAsset(assetName: AppAssets.noResults, width: 22.w, height: 22.w),
          SizedBox(height: 1.5.h),
          Text(
            "start_searching".tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "enter_product_name".tr(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom loading icon with purple background
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Color(0xFFE8E0FF), // Light purple background
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: Color(0xFF6B46C1), // Dark purple
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "searching_products".tr(),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            "search_error".tr(),
            style: TextStyle(
              fontSize: 18,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveMargin),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.trim().isNotEmpty) {
                _searchCubit.searchProducts(query: _searchController.text.trim());
              }
            },
            child: Text("retry".tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    List<SearchProductModel> products,
    SearchWarehouseModel warehouse,
    SearchMetaModel meta, {
    String? query,
    bool isLoadingMore = false,
  }) {
    // If no products found, show empty state
    if (products.isEmpty) {
      return BuildEmptyState(context, isSearchResult: query != null);
    }
    
    return Column(
      children: [
        // Results header
        if (query != null)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsivePadding,
              vertical: 8,
            ),
            child: Row(
              children: [
                Text(
                  "${products.length} ${"results_for".tr()} \"$query\"",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Spacer(),
                if (meta.total > products.length)
                  Text(
                    "${meta.total} ${"total_results".tr()}",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        // Products grid
        Expanded(
          child: SearchGridView(
            products: products,
            onLoadMore: isLoadingMore ? null : () {
              // Trigger load more when user scrolls to bottom
              if (_scrollController.hasClients) {
                final maxScroll = _scrollController.position.maxScrollExtent;
                final currentScroll = _scrollController.position.pixels;
                if (currentScroll >= maxScroll * 0.8) {
                  _searchCubit.loadMoreProducts();
                }
              }
            },
            isLoadingMore: isLoadingMore,
          ),
        ),
      ],
    );
  }

  // /// Handles the favorite action for a product
  // void _handleFavoriteAction(BuildContext context, SearchProductModel product) {
  //   final productDetailsCubit = context.read<ProductDetailsCubit>();
  //   final currentFavoriteStatus = _favoriteStatus[product.id] ?? product.isLiked;
    
  //   // Optimistically update the UI
  //   setState(() {
  //     _favoriteStatus[product.id] = !currentFavoriteStatus;
  //   });
    
  //   // Show immediate feedback to user
  //   final scaffoldMessenger = ScaffoldMessenger.of(context);
  //   if (currentFavoriteStatus) {
  //     // Removing from favorites
  //     scaffoldMessenger.showSnackBar(
  //       SnackBar(
  //         content: Text('removed_from_favorites'.tr()),
  //         backgroundColor: AppColors.success,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     productDetailsCubit.unlikeProduct(product.id);
  //   } else {
  //     // Adding to favorites
  //     scaffoldMessenger.showSnackBar(
  //       SnackBar(
  //         content: Text('added_to_favorites'.tr()),
  //         backgroundColor: AppColors.success,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     productDetailsCubit.likeProduct(product.id);
  //   }
  // }

  // /// Handles the add to cart action for a product
  // void _handleAddToCartAction(BuildContext context, SearchProductModel product) {
  //   final cartCubit = context.read<CartCubit>();
    
  //   // Show immediate feedback to user
  //   final scaffoldMessenger = ScaffoldMessenger.of(context);
  //   scaffoldMessenger.showSnackBar(
  //     SnackBar(
  //       content: Text('added_to_cart'.tr()),
  //       backgroundColor: AppColors.success,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
    
  //   // Add product to cart with default quantity of 1
  //   // Using warehouse ID from the search results if available, otherwise default to 1
  //   cartCubit.addToCart(
  //     productId: product.id,
  //     quantity: 1,
  //     warehouseId: 1, // Default warehouse ID - you might want to get this from user location or settings
  //   );
  // }

}
