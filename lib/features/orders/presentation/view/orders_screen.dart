import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
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
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(ServiceLocator.get<OrdersService>())
        ..getAllOrders(),
      child: const OrdersScreenBody(),
    );
  }
}

class OrdersScreenBody extends StatefulWidget {
  const OrdersScreenBody({super.key});

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reordering from ${order.orderNumber}'),
        backgroundColor: AppColors.success,
      ),
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

            // Search Bar
            _buildSearchBar(context),

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.box_1,
            size: context.responsiveIconSize * 4,
            color: AppColors.textSecondary,
          ),

          SizedBox(height: context.responsiveMargin * 2),

          Text(
            "no_orders_found".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin),

          Text(
            "start_shopping_message".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
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
