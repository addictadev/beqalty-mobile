import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/primary_button.dart' show PrimaryButton;
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/saved_carts/business/cubit/saved_cart_details_cubit.dart';
import 'package:baqalty/features/saved_carts/data/services/saved_carts_service.dart';
import 'package:baqalty/features/saved_carts/data/models/saved_cart_details_response_model.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:baqalty/features/product_details/business/cubit/product_details_cubit.dart';
import 'package:baqalty/features/product_details/data/services/product_details_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:sizer/sizer.dart';

import '../../../cart/presentation/widget/cart_item.dart';
import '../../../cart/presentation/widget/order_summary.dart';

class SavedCartDetailsScreen extends StatelessWidget {
  final int cartId;
  final String cartName;

  const SavedCartDetailsScreen({
    super.key,
    required this.cartId,
    required this.cartName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedCartDetailsCubit(SavedCartsService())
        ..getSavedCartDetails(cartId),
      child: SavedCartDetailsScreenBody(cartId: cartId, cartName: cartName),
    );
  }
}

class SavedCartDetailsScreenBody extends StatefulWidget {
  final int cartId;
  final String cartName;

  const SavedCartDetailsScreenBody({
    super.key,
    required this.cartId,
    required this.cartName,
  });

  @override
  State<SavedCartDetailsScreenBody> createState() => _SavedCartDetailsScreenBodyState();
}

class _SavedCartDetailsScreenBodyState extends State<SavedCartDetailsScreenBody> {
  @override
  void initState() {
    super.initState();
    // Load cart data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedCartDetailsCubit>().getSavedCartDetails(widget.cartId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocConsumer<SavedCartDetailsCubit, SavedCartDetailsState>(
        listener: (context, state) {
          if (state is SavedCartDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is SavedCartDetailsItemRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('item_removed_successfully'.tr()),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is SavedCartDetailsUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('quantity_updated_successfully'.tr()),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return AuthBackgroundWidget(
            child: Column(
              children: [
         
         
         Padding(padding: EdgeInsets.symmetric(horizontal: context.responsivePadding), child: CustomAppBar(title: widget.cartName, onBackPressed: () => Navigator.of(context).pop()),),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: context.responsiveMargin * 2),

                        // Cart Items Section
                        _buildCartItemsSection(context, state),

                        // Bottom spacing for safe area
                        SizedBox(height: context.responsiveMargin * 4),
                      ],
                    ),
                  ),
                ),
                _buildOrderSummary(context, state),
                                        SizedBox(height: context.responsiveMargin * 4),


              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItemsSection(BuildContext context, SavedCartDetailsState state) {
    if (state is SavedCartDetailsLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
              SizedBox(height: context.responsiveMargin * 2),
              Text(
                "loading_cart".tr(),
                style: TextStyles.textViewMedium16.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is SavedCartDetailsError) {
      return _buildEmptyCartState(context);
    }

    if (state is SavedCartDetailsLoaded) {
      if (state.cartDetails.items.isEmpty) {
        return _buildEmptyCartState(context);
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        child: Column(
          children: [
            ...state.cartDetails.items.map(
              (item) => 
              
              InkWell(
                onTap: () {
                  NavigationManager.navigateTo(
                    MultiBlocProvider(
                      providers: [
                        BlocProvider<ProductDetailsCubit>(
                          create: (context) => ProductDetailsCubit(
                            ServiceLocator.get<ProductDetailsService>(),
                          ),
                        ),
                      ],
                      child: ProductDetailsScreen(
                        productId: item.productId,
                      ),
                    ),
                  );
                },
                child: 
              CartItem(
                productName: item.productName,
                category: item.subcategoryName,
                productImage: item.baseImage,
                price: double.tryParse(item.finalPrice) ?? 0.0,
                quantity: item.quantity,
                isAvailable: item.isAvailable,
                statusMessage: item.statusMessage,
                onIncrease: item.isAvailable ? () => context.read<SavedCartDetailsCubit>().increaseItemQuantity(
                  cartId: widget.cartId,
                  productId: item.productId,
                  warehouseId: (state).cartDetails.warehouseId,
                ) : null,
                onDecrease: item.isAvailable ? () {
                  if (item.quantity > 1) {
                    context.read<SavedCartDetailsCubit>().decreaseItemQuantity(
                      cartId: widget.cartId,
                      productId: item.productId,
                      warehouseId: (state).cartDetails.warehouseId,
                    );
                  }
                } : null,
                onRemove: () => _showRemoveItemDialog(context, item, context.read<SavedCartDetailsCubit>(), (state).cartDetails.warehouseId),
              )),
            ),
          ],
        ),
      );
    }

    if (state is SavedCartDetailsUpdated || state is SavedCartDetailsItemRemoved) {
      // Handle updated/removed states by showing the updated cart
      final cartData = state is SavedCartDetailsUpdated 
          ? state.cartDetails.data 
          : (state as SavedCartDetailsItemRemoved).cartDetails.data;
      
      if (cartData.items.isEmpty) {
        return _buildEmptyCartState(context);
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        child: Column(
          children: [
            ...cartData.items.map(
              (item) => CartItem(
                productName: item.productName,
                category: item.subcategoryName,
                productImage: item.baseImage,
                price: double.tryParse(item.finalPrice) ?? 0.0,
                quantity: item.quantity,
                isAvailable: item.isAvailable,
                statusMessage: item.statusMessage,
                onIncrease: item.isAvailable ? () => context.read<SavedCartDetailsCubit>().increaseItemQuantity(
                  cartId: widget.cartId,
                  productId: item.productId,
                  warehouseId: (state as SavedCartDetailsLoaded).cartDetails.warehouseId,
                ) : null,
                onDecrease: item.isAvailable ? () {
                  if (item.quantity > 1) {
                    context.read<SavedCartDetailsCubit>().decreaseItemQuantity(
                      cartId: widget.cartId,
                      productId: item.productId,
                      warehouseId: (state as SavedCartDetailsLoaded).cartDetails.warehouseId,
                    );
                  }
                } : null,
                onRemove: () => _showRemoveItemDialog(context, item, context.read<SavedCartDetailsCubit>(), (state as SavedCartDetailsLoaded).cartDetails.warehouseId),
              ),
            ),
          ],
        ),
      );
    }

    return _buildEmptyCartState(context);
  }

  Widget _buildEmptyCartState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsivePadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shopping bag icon with custom styling
              CustomImageAsset(assetName: AppAssets.emptyCart, width: 25.w, height: 25.w,color: AppColors.primary),
              SizedBox(height: context.responsiveMargin * 2),
              
              // Main heading
              Text(
                "your_cart_is_empty".tr(),
                style: TextStyles.textViewBold20.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.responsiveMargin),
              
              // Descriptive text
              Text(
                "looks_like_you_havent_added_anything_yet".tr(),
                style: TextStyles.textViewRegular16.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.responsiveMargin * 2),
              
              // Browse products button
              PrimaryButton(
                text: "browse_products".tr(),
                onPressed: () {
                  // Navigate to categories screen
                  context.read<NavBarCubit>().changeTab(3);
                },
                width: 90.w,
                borderRadius: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, SavedCartDetailsState state) {
    SavedCartDetailsDataModel? cartData;
    
    if (state is SavedCartDetailsLoaded) {
      cartData = state.cartDetails;
    } else if (state is SavedCartDetailsUpdated) {
      cartData = state.cartDetails.data;
    } else if (state is SavedCartDetailsItemRemoved) {
      cartData = state.cartDetails.data;
    }

    if (cartData == null || cartData.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return OrderSummary(
      subTotal: cartData.cartTotal.toDouble(),
      deliveryFee: double.tryParse(cartData.deliveryFee) ?? 0.0,
      discount: 0.0, // Add discount if available in API response
      total: cartData.cartFinalTotal.toDouble(),
      cartId: cartData.id,
    );
  }

  void _showRemoveItemDialog(BuildContext context, SavedCartDetailsItemModel item, SavedCartDetailsCubit cubit, int warehouseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("remove_item".tr()),
          content: Text("are_you_sure_remove_item".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cubit.removeItem(cartId: widget.cartId, productId: item.productId, warehouseId: warehouseId);
              },
              child: Text(
                "remove".tr(),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}