import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/primary_button.dart' show PrimaryButton;
import 'package:baqalty/core/widgets/save_cart_dialog.dart';
import 'package:baqalty/core/utils/deep_link_helper.dart';
import 'package:baqalty/features/cart/data/services/cart_service_impl.dart';
import 'package:baqalty/features/cart/data/models/save_cart_request_model.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart';
import 'package:baqalty/features/product_details/business/cubit/product_details_cubit.dart';
import 'package:baqalty/features/product_details/data/services/product_details_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:sizer/sizer.dart';
import '../../data/models/cart_response_model.dart';
import '../../data/services/cart_service.dart';

import '../widget/cart_item.dart';
import '../widget/order_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(ServiceLocator.get<CartService>()),
      child: const CartScreenBody(),
    );
  }
}

class CartScreenBody extends StatefulWidget {
  const CartScreenBody({super.key});

  @override
  State<CartScreenBody> createState() => _CartScreenBodyState();
}

class _CartScreenBodyState extends State<CartScreenBody> {
  @override
  void initState() {
    super.initState();
    // Load cart data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().getAllCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is CartItemRemoved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('item_removed_successfully'.tr()),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CartUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('quantity_updated_successfully'.tr()),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CartCleared) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('cart_cleared_successfully'.tr()),
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
                SizedBox(height: context.responsiveMargin * 6),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsivePadding,
                    vertical: context.responsiveMargin,
                  ),
                  child: Row(
                    children: [
                  if (_shouldShowClearCartButton(state)) ...[
       IconButton(
                          onPressed: () {
                            _showSaveCartDialog();
                          }, 
                          icon: CustomSvgImage(assetName:AppAssets.unSavedIcon)
                        ),
                
                      ],

                      // Title
                      Expanded(
                        child: Center(
                          child: Text(
                            "my_cart".tr(),
                            style: TextStyles.textViewBold18.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      // Clear cart button - only show when cart has items
                      if (_shouldShowClearCartButton(state))
                        IconButton(
                          onPressed: () {
                            _showClearCartDialog(context, context.read<CartCubit>());
                          }, 
                          icon: Icon(Iconsax.trash, color: AppColors.error,size: context.responsiveIconSize * 1.1,)
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: context.responsiveMargin * 2),

                        // Share Cart Section
                        // if(state is CartLoaded && state.cartData.items.isNotEmpty) _buildShareCartSection(context),

                        // Cart Items Section
                        _buildCartItemsSection(context, state),

                        // Order Summary

                        // Bottom spacing for safe area
                        SizedBox(height: context.responsiveMargin * 4),
                      ],
                    ),
                  ),
                ),
                 _buildOrderSummary(context, state),

              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShareCartSection(BuildContext context) {
    return InkWell(
      onTap: () {
        _shareCart(context.read<CartCubit>().state);
      },
      child: 
    Container(
      margin: EdgeInsets.symmetric(vertical: context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Row(
        children: [
          Container(
            width: context.responsiveIconSize * 1.2,
            height: context.responsiveIconSize * 1.2,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                context.responsiveBorderRadius * 0.5,
              ),
            ),
            child: Icon(
              Iconsax.people,
              color: AppColors.primary,
              size: context.responsiveIconSize * 0.8,
            ),
          ),
          SizedBox(width: context.responsiveMargin),
          Expanded(
            child: Text(
              "${"share_your_cart".tr()} - ${"share_cart_description".tr()}",
              style: TextStyles.textViewMedium14.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.white,
            size: context.responsiveIconSize,
          ),
        ],
      ),
     ) );
  }

  Widget _buildCartItemsSection(BuildContext context, CartState state) {
    if (state is CartLoading) {
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

    if (state is CartEmpty) {
      return _buildEmptyCartState(context);
    }

    if (state is CartLoaded) {
      if (state.cartData.items.isEmpty) {
        return _buildEmptyCartState(context);
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        child: Column(
          children: [
            ...state.cartData.items.map(
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
                        BlocProvider<CartCubit>(
                          create: (context) => CartCubit(ServiceLocator.get<CartService>()),
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
                onIncrease: item.isAvailable ? () => context.read<CartCubit>().updateCartItem(
                  cartItemId: item.id,
                  productId: item.productId,
                  currentQuantity: item.quantity,
                  newQuantity: item.quantity + 1,
                ) : null,
                onDecrease: item.isAvailable ? () {
                  if (item.quantity > 1) {
                    context.read<CartCubit>().updateCartItem(
                      cartItemId: item.id,
                      productId: item.productId,
                      currentQuantity: item.quantity,
                      newQuantity: item.quantity - 1,
                    );
                  }
                } : null,
                onRemove: () => _showRemoveItemDialog(context, item, context.read<CartCubit>()),
              )),
            ),
          ],
        ),
      );
    }

    if (state is CartUpdated || state is CartItemRemoved) {
      // Handle updated/removed states by showing the updated cart
      final cartData = state is CartUpdated 
          ? state.cartData 
          : (state as CartItemRemoved).cartData;
      
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
                onIncrease: item.isAvailable ? () => context.read<CartCubit>().updateCartItem(
                  cartItemId: item.id,
                  productId: item.productId,
                  currentQuantity: item.quantity,
                  newQuantity: item.quantity + 1,
                ) : null,
                onDecrease: item.isAvailable ? () {
                  if (item.quantity > 1) {
                    context.read<CartCubit>().updateCartItem(
                      cartItemId: item.id,
                      productId: item.productId,
                      currentQuantity: item.quantity,
                      newQuantity: item.quantity - 1,
                    );
                  }
                } : null,
                onRemove: () => _showRemoveItemDialog(context, item, context.read<CartCubit>()),
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

  Widget _buildOrderSummary(BuildContext context, CartState state) {
    CartDataModel? cartData;
    
    if (state is CartLoaded) {
      cartData = state.cartData;
    } else if (state is CartUpdated) {
      cartData = state.cartData;
    } else if (state is CartItemRemoved) {
      cartData = state.cartData;
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

  void _showRemoveItemDialog(BuildContext context, CartItemModel item, CartCubit cartCubit) {
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
                cartCubit.removeItem(productId: item.productId);
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

  bool _shouldShowClearCartButton(CartState state) {
    if (state is CartLoaded) {
      return state.cartData.items.isNotEmpty;
    } else if (state is CartUpdated) {
      return state.cartData.items.isNotEmpty;
    } else if (state is CartItemRemoved) {
      return state.cartData.items.isNotEmpty;
    }
    return false;
  }

  void _showClearCartDialog(BuildContext context, CartCubit cartCubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("clear_cart".tr()),
          content: Text("are_you_sure_clear_cart".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cartCubit.clearCart();
              },
              child: Text(
                "clear_all".tr(),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSaveCartDialog() {
    showDialog(
      context: context,
      builder: (context) => SaveCartDialog(
        onSave: _saveCart,
      ),
    );
  }

  Future<void> _saveCart(String cartName) async {
    try {
      final cartService = CartServiceImpl();
      final request = SaveCartRequestModel(name: cartName);
      
      final response = await cartService.saveCart(request);
      
      if (response.status && response.data != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data!.message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        throw Exception(response.message ?? 'Failed to save cart');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void _shareCart(CartState state) {
    if (state is CartLoaded && state.cartData.items.isNotEmpty) {
      // Convert API URL to redirect URL
      final apiUrl = state.cartData.url_shared_cart;
      final sharedCartUrl = DeepLinkHelper.convertApiUrlToRedirectUrl(apiUrl);
      
      if (sharedCartUrl.isNotEmpty) {
        // Show options dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("choose_share_method".tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  DeepLinkHelper.shareCartViaWhatsApp(sharedCartUrl);
                },
                child: Text("WhatsApp",style: TextStyles.textViewBold14.copyWith(color: Colors.green),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  DeepLinkHelper.shareCart(sharedCartUrl);
                },
                child: Text("other".tr(),style: TextStyles.textViewBold14.copyWith(color: AppColors.textPrimary),),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("cancel".tr(),style: TextStyles.textViewMedium14.copyWith(color: AppColors.textPrimary),),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("shared_cart_not_available".tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("cart_is_empty".tr()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}