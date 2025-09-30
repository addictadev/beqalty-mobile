import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';

import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/orders/business/models/order_model.dart';
import 'package:baqalty/features/orders/presentation/widgets/order_card.dart';
import 'package:baqalty/features/orders/presentation/view/track_order_screen.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<OrderModel> _orders = [];
  List<OrderModel> _filteredOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    // Simulate loading orders
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _orders = _getMockOrders();
        _filteredOrders = _orders;
        _isLoading = false;
      });
    });
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
              child: _isLoading
                  ? _buildLoadingState()
                  : _buildOrdersList(context),
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

  List<OrderModel> _getMockOrders() {
    return [
      OrderModel(
        id: '1',
        orderNumber: '#BAQ10247',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        itemCount: 12,
        status: OrderStatus.outForDelivery,
        estimatedTime: '20 min',
        totalAmount: 253.0,
        items: [],
      ),
      OrderModel(
        id: '2',
        orderNumber: '#BAQ10246',
        orderDate: DateTime.now().subtract(
          const Duration(days: 1, hours: 18, minutes: 20),
        ),
        itemCount: 3,
        status: OrderStatus.delivered,
        totalAmount: 89.50,
        items: [],
      ),
      OrderModel(
        id: '3',
        orderNumber: '#BAQ10245',
        orderDate: DateTime.now().subtract(
          const Duration(days: 1, hours: 18, minutes: 20),
        ),
        itemCount: 3,
        status: OrderStatus.delivered,
        totalAmount: 67.25,
        items: [],
      ),
      OrderModel(
        id: '4',
        orderNumber: '#BAQ10244',
        orderDate: DateTime.now().subtract(
          const Duration(days: 1, hours: 18, minutes: 20),
        ),
        itemCount: 3,
        status: OrderStatus.delivered,
        totalAmount: 45.80,
        items: [],
      ),
      OrderModel(
        id: '5',
        orderNumber: '#BAQ10243',
        orderDate: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
        itemCount: 3,
        status: OrderStatus.failed,
        totalAmount: 32.15,
        items: [],
      ),
    ];
  }
}
