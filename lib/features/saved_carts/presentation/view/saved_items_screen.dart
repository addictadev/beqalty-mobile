import 'package:baqalty/core/images_preview/app_assets.dart' show AppAssets;
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/saved_item_card.dart';
import 'package:baqalty/features/saved_carts/data/models/favorite_item_model.dart';
import 'package:baqalty/features/saved_carts/business/cubit/favorite_items_cubit.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:baqalty/features/product_details/data/services/product_details_service.dart';
import 'package:baqalty/features/product_details/data/models/like_product_request_model.dart';
import 'package:baqalty/features/product_details/business/cubit/product_details_cubit.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:baqalty/features/cart/data/services/cart_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

class SavedItemsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCategories;
  
  const SavedItemsScreen({
    super.key,
    this.onNavigateToCategories,
  });

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load favorite items when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteItemsCubit>().getAllFavoriteItems();
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Use the API to search for favorite items
    context.read<FavoriteItemsCubit>().getAllFavoriteItems(
      search: query.isEmpty ? null : query,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            CustomAppBar(title: "saved_items".tr()),

              // Search Bar - show if there are favorite items OR if we're searching
              BlocBuilder<FavoriteItemsCubit, FavoriteItemsState>(
                builder: (context, state) {
                  if (state is FavoriteItemsLoaded) {
                    // Show search bar if there are items OR if we have a search query
                    if (state.favoriteItems.isNotEmpty || _searchController.text.isNotEmpty) {
                      return _buildSearchBar(context);
                    }
                  } else if (state is FavoriteItemsLoading && _searchController.text.isNotEmpty) {
                    // Show search bar during loading if we have a search query
                    return _buildSearchBar(context);
                  }
                  return const SizedBox.shrink();
                },
              ),

            // Saved Items List
            Expanded(
              child: BlocBuilder<FavoriteItemsCubit, FavoriteItemsState>(
                builder: (context, state) {
                  
                  if (state is FavoriteItemsInitial) {
                    return _buildLoadingState();
                  } else if (state is FavoriteItemsLoading) {
                    return _buildLoadingState();
                  } else if (state is FavoriteItemsLoaded) {
                    return _buildFavoriteItemsList(context, state.favoriteItems, _searchController.text);
                  } else if (state is FavoriteItemsError) {
                    return _buildErrorState(state.message);
                  }
                  return _buildLoadingState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      child: CustomTextFormField(
        controller: _searchController,
        hint: "search_saved_items".tr(),
        prefixIcon: Icon(
          Iconsax.search_normal_1,
          color: AppColors.textSecondary,
          size: context.responsiveIconSize,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: AppColors.textSecondary,
                  size: context.responsiveIconSize,
                ),
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
              )
            : null,
        onChanged: _onSearchChanged,
        borderRadius: 25,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        fillColor: AppColors.white,
        borderColor: AppColors.borderLight,
        focusedBorderColor: AppColors.primary,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            "loading_saved_items".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    final bool isSearching = searchQuery.isNotEmpty;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageAsset(
            assetName:  AppAssets.emptyHeart, 
            width: 25.w, 
            height: 25.w
          ),

          SizedBox(height: context.responsiveMargin * 2),

          Text(
            isSearching ? "no_search_results".tr() : "no_saved_items_yet".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.responsivePadding * 3), 
            child: Text(
            "no_saved_items_description".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          )),

          SizedBox(height: context.responsiveMargin * 2),

           PrimaryButton(
             margin: EdgeInsets.symmetric(horizontal: context.responsivePadding * 2),
             text: "browse_products".tr(), onPressed: () {
             // Navigate back and go to categories tab
             Navigator.of(context).pop();
             if (widget.onNavigateToCategories != null) {
               widget.onNavigateToCategories!();
             }
           }),
        ],
      ),
    );
  }


  Widget _buildFavoriteItemsList(BuildContext context, List<FavoriteItemModel> favoriteItems, String searchQuery) {
    
    if (favoriteItems.isEmpty) {
      return _buildEmptyState(context, searchQuery);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FavoriteItemsCubit>().refreshFavoriteItems();
      },
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: favoriteItems.length,
          itemBuilder: (context, index) {
            final favoriteItem = favoriteItems[index];
            return Padding(
              padding: EdgeInsets.only(bottom: context.responsiveMargin),
              child: SavedItemCard(
                productName: favoriteItem.name,
                productCategory: favoriteItem.subcategoryName,
                productPrice: double.tryParse(favoriteItem.finalPrice) ?? 0.0,
                productImage: favoriteItem.baseImage,
                showFavoriteButton: true,
                showAddToCartButton: false,
                isFavorite: true,
                onTap: () async {
                  final cubit = context.read<FavoriteItemsCubit>();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<ProductDetailsCubit>(
                            create: (context) => ProductDetailsCubit(
                              ServiceLocator.get<ProductDetailsService>(),
                            ),
                          ),
                          BlocProvider<CartCubit>(
                            create: (context) => CartCubit(ServiceLocator.get<CartService>()),
                          ),
                        ],
                        child: ProductDetailsScreen(productId: favoriteItem.id),
                      ),
                    ),
                  );
                  // Refresh favorite items when returning from product details
                  if (mounted) {
                    cubit.getAllFavoriteItems();
                  }
                },
                onFavorite: () => _onRemoveFavoriteItem(context, favoriteItem, index),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              context.read<FavoriteItemsCubit>().getAllFavoriteItems();
            },
            child: Text('retry'.tr()),
          ),
        ],
      ),
    );
  }

  void _onRemoveFavoriteItem(BuildContext context, FavoriteItemModel favoriteItem, int index) async {
    // Store context reference before async operation
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final cubit = context.read<FavoriteItemsCubit>();
    
    try {


      // Call the unlike API
      final productDetailsService = ServiceLocator.get<ProductDetailsService>();
      final request = LikeProductRequestModel(productId: favoriteItem.id);
      final response = await productDetailsService.unlikeProduct(request);

      if (response.status && response.data != null) {
        // Success - remove item from the list immediately
        cubit.removeItem(index);

        // Show success message
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('removed_from_favorites'.tr()),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Error - show error message
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'failed_to_remove_from_favorites'.tr()),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Error - show error message
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

