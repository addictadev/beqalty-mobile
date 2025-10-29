import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:baqalty/features/categories/presentation/view/categories_screen.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/features/cart/business/cubit/shared_cart_cubit.dart';
import 'package:baqalty/features/cart/business/cubit/shared_cart_state.dart';
import 'package:baqalty/features/cart/data/services/shared_cart_service.dart';
import 'package:baqalty/features/cart/data/services/cart_service.dart';
import 'package:baqalty/features/cart/presentation/widget/cart_item.dart';
import 'package:baqalty/features/cart/presentation/widget/order_summary.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class SharedCartScreen extends StatelessWidget {
  final String sharedCartId;

  const SharedCartScreen({
    super.key,
    required this.sharedCartId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SharedCartCubit>(
          create: (context) => SharedCartCubit(ServiceLocator.get<SharedCartService>()),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(ServiceLocator.get<CartService>()),
        ),
      ],
      child: SharedCartScreenBody(sharedCartId: sharedCartId),
    );
  }
}

class SharedCartScreenBody extends StatefulWidget {
  final String sharedCartId;

  const SharedCartScreenBody({
    super.key,
    required this.sharedCartId,
  });

  @override
  State<SharedCartScreenBody> createState() => _SharedCartScreenBodyState();
}

class _SharedCartScreenBodyState extends State<SharedCartScreenBody> with WidgetsBindingObserver, RouteAware {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
    // Load shared cart when screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
    });
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Screen gained focus - refresh shared cart
      context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh shared cart when dependencies change (e.g., returning from another screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
    });
  }

  @override
  void didUpdateWidget(SharedCartScreenBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh shared cart when widget updates
    if (oldWidget.sharedCartId != widget.sharedCartId) {
      context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh shared cart when app comes back to foreground
      context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
    }
  }

  @override
  void didPopNext() {
    // Called when returning to this screen from another screen
    super.didPopNext();
    // Refresh shared cart when returning from categories
    context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
  }

  @override
  Widget build(BuildContext context) {
    // Register this screen with RouteObserver
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      // This will be handled by the parent widget
    }
    
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: "shared_cart".tr(),
          showBackButton: false,
        ),
      body: PopScope(
        onPopInvoked: (didPop) {
          // Refresh shared cart when returning from categories
          if (didPop) {
            context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
          }
        },
        child: BlocListener<CartCubit, CartState>(
          listener: (context, cartState) {
            // Refresh shared cart when cart operations complete
            if (cartState is CartLoaded || cartState is CartItemAdded) {
              context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
            }
          },
          child: BlocBuilder<SharedCartCubit, SharedCartState>(
          builder: (context, state) {
          if (state is SharedCartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SharedCartError) {
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
                    state.message,
                    style: TextStyles.textViewMedium16.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SharedCartCubit>().getSharedCart(widget.sharedCartId);
                    },
                    child: Text("retry".tr()),
                  ),
                ],
              ),
            );
          } else if (state is SharedCartLoaded) {
            final cartData = state.cartData;
            
          

            return Column(
              children: [
               
               SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      )
                    ],
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2.w),
                        child: CustomSvgImage(assetName: AppAssets.profilePerson, width: 12.w, height: 12.w,)),
                      SizedBox(width: 2.w),
                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Order From",
                              style: TextStyles.textViewMedium14.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                            Text(
                              cartData.data!.name ?? "Unknown User",
                              style: TextStyles.textViewMedium16.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add Items Button
                      GestureDetector(onTap: () {
                       NavigationManager.navigateTo(CategoriesScreen(sharedCartId: widget.sharedCartId));
                      }, child:
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 3.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              "add_items".tr(),
                              style: TextStyles.textViewMedium14.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  )],
                  
                  
                  ),
                ),
                
                Expanded(
                  child: 
                  cartData.data!.items.isEmpty?
                  _buildEmptyCartState(context):
                  
                  ListView.builder(
                    padding: EdgeInsets.all(3.w),
                    itemCount: cartData.data!.items.length,
                    itemBuilder: (context, index) {
                      final item = cartData.data!.items[index];
                      return CartItem(
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
                  sharedCartId: int.tryParse(widget.sharedCartId),
                ) : null,
                onDecrease: item.isAvailable ? () {
                  if (item.quantity > 1) {
                    context.read<CartCubit>().updateCartItem(
                      cartItemId: item.id,
                      productId: item.productId,
                      currentQuantity: item.quantity,
                      newQuantity: item.quantity - 1,
                      sharedCartId: int.tryParse(widget.sharedCartId),
                    );
                  }
                } : null,
                onRemove: () => context.read<CartCubit>().removeItem(
                  productId: item.productId,
                  sharedCartId: int.tryParse(widget.sharedCartId),
                ),
                  );},
                  ),
                ),
              if(cartData.data!.items.isNotEmpty)  OrderSummary(
                  isSharedCart: true,
                  discount: 0.0,
                  subTotal: cartData.data!.cartTotal.toDouble(),
                  deliveryFee: double.tryParse(cartData.data!.deliveryFee) ?? 0.0,
                  total: cartData.data!.cartFinalTotal.toDouble(),
                  cartId: cartData.data!.id,
                ),
                SizedBox(height: 2.h),
                // Home button
               
               
                Container(
                  width: double.infinity,
                  height: 6.5.h,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  margin: EdgeInsets.only(bottom: 3.h),
                  child: ElevatedButton(
                    onPressed: () {
                NavigationManager.navigateToAndFinish(MainNavigationScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                    ),
                    child: Text(
                      "go_to_home".tr().isEmpty ? "العودة للرئيسية" : "go_to_home".tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
          ),
        ),
      ),
      ),
    );
  }
    Widget _buildEmptyCartState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shopping bag icon with custom styling
              CustomImageAsset(assetName: AppAssets.emptyCart, width: 25.w, height: 25.w,color: AppColors.primary),
              SizedBox(height: 2.h),
              
              // Main heading
              Text(
                "your_cart_is_empty".tr(),
                style: TextStyles.textViewBold20.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              
              // Descriptive text
              Text(
                "looks_like_you_havent_added_anything_yet".tr(),
                style: TextStyles.textViewRegular16.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              
              // Browse products button
              PrimaryButton(
                text: "browse_products".tr(),
                onPressed: () {
               
                                      NavigationManager.navigateTo(CategoriesScreen(sharedCartId: widget.sharedCartId));

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

}
