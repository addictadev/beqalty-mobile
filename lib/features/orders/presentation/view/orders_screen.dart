import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/nav_bar/business/cubit/nav_bar_cubit/nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/orders/business/models/order_model.dart';
import 'package:baqalty/features/orders/business/cubit/orders_cubit.dart';
import 'package:baqalty/features/orders/data/services/orders_service.dart';
import 'package:baqalty/features/orders/presentation/widgets/order_card.dart';
import 'package:baqalty/features/orders/presentation/view/track_order_screen.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class OrdersScreen extends StatelessWidget {
  final VoidCallback? onNavigateToCategories;
  final VoidCallback? onNavigateToCart;
  const OrdersScreen({super.key, this.onNavigateToCategories, this.onNavigateToCart});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(ServiceLocator.get<OrdersService>())
        ..getAllOrders(),
      child: OrdersScreenBody(
        onNavigateToCategories: onNavigateToCategories,
        onNavigateToCart: onNavigateToCart,
      ),
    );
  }
}

class OrdersScreenBody extends StatefulWidget {
  final VoidCallback? onNavigateToCategories;
  final VoidCallback? onNavigateToCart;
  
  const OrdersScreenBody({super.key, this.onNavigateToCategories, this.onNavigateToCart});

  @override
  State<OrdersScreenBody> createState() => _OrdersScreenBodyState();
}

class _OrdersScreenBodyState extends State<OrdersScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  List<OrderModel> _filteredOrders = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTrackOrder(OrderModel order) {
    NavigationManager.navigateTo(TrackOrderScreen(order: order));
  }

  void _onOrderAgain(OrderModel order) {
    _showReorderDialog(order);
  }

  void _showReorderDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "reorder_dialog_title".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            "reorder_dialog_message".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "cancel".tr(),
                style: TextStyles.textViewMedium14.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleReorder(order);
              },
              child: Text(
                "clear_basket".tr(),
                style: TextStyles.textViewMedium14.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleReorder(OrderModel order) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        },
      );

      // Call the reorder API
      final ordersService = ServiceLocator.get<OrdersService>();
      final response = await ordersService.reorder(int.parse(order.id));

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (response.status && context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Order added to cart successfully'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to cart screen
        _navigateToCartScreen();
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Failed to reorder'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _navigateToCartScreen() {
    // Navigate back to main navigation with cart tab selected
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<NavBarCubit>(
              create: (context) {
                final cubit = NavBarCubit();
                // Set cart tab as active immediately
                cubit.changeTab(1);
                return cubit;
              },
            ),
          ],
          child: const MainNavigationScreen(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      backgroundHeight: MediaQuery.of(context).size.height * 0.25,
      overlayOpacity: 0.3,
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            CustomAppBar(title: "my_orders".tr()),

            // Search Bar (only show when there are orders)
            if (_filteredOrders.isNotEmpty) _buildSearchBar(context),

            // Orders List
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return _buildLoadingState();
                  } else if (state is OrdersLoaded) {
                    _filteredOrders = _convertToOrderModels(state.orders);
                    return _buildOrdersList(context);
                  } else if (state is OrdersError) {
                    return _buildErrorState(context, state.message);
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: CustomTextFormField(
        controller: _searchController,
        hint: "search_orders".tr(),
        prefixIcon: Icon(Iconsax.search_normal_1),
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
            "loading_orders".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    if (_filteredOrders.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return OrderCard(
          order: order,
          onTrackOrder: () => _onTrackOrder(order),
          onOrderAgain: () => _onOrderAgain(order),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty orders illustration
     CustomImageAsset(assetName: AppAssets.noOrders, width: 20.w, height: 20.w),

            SizedBox(height: context.responsiveMargin * 3),

            // Main heading
            Text(
              "no_orders_found".tr().isEmpty ? "لا توجد طلبات" : "no_orders_found".tr(),
              style: TextStyles.textViewBold20.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.responsiveMargin),

            // Description
            Text(
              "start_shopping_n".tr(),
              style: TextStyles.textViewRegular16.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.responsiveMargin * 3),

            // Start shopping button
            PrimaryButton(
              onPressed: () {
               Navigator.of(context).pop();
             if (widget.onNavigateToCategories != null) {
               widget.onNavigateToCategories!();
             }
              },
              text: "browse_products".tr(),
            ),
          ],
        ),
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
            size: context.responsiveIconSize * 4,
            color: AppColors.error,
          ),

          SizedBox(height: context.responsiveMargin * 2),

          Text(
            "error_loading_orders".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin),

          Text(
            message,
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin * 2),

          ElevatedButton(
            onPressed: () {
              context.read<OrdersCubit>().getAllOrders();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text("retry".tr()),
          ),
        ],
      ),
    );
  }

  List<OrderModel> _convertToOrderModels(List<dynamic> ordersData) {
    return ordersData.map((orderData) {
      return OrderModel.fromOrderData(
        id: orderData.id.toString(),
        code: orderData.code,
        status: orderData.status,
        totalPrice: orderData.totalPrice,
        itemsCount: orderData.itemsCount,
      );
    }).toList();
  }

}
