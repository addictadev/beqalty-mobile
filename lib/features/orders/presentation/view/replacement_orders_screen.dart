import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/features/orders/business/cubit/replacement_orders_cubit.dart';
import 'package:baqalty/features/orders/business/cubit/replacement_orders_state.dart';
import 'package:baqalty/features/orders/data/models/replacement_order_model.dart';
import 'package:baqalty/features/orders/data/services/replacement_orders_service.dart';
import 'package:baqalty/core/di/service_locator.dart';

class ReplacementOrdersScreen extends StatelessWidget {
  const ReplacementOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReplacementOrdersCubit(
        ServiceLocator.get<ReplacementOrdersService>(),
      )..getReplacementOrders(),
      child: const ReplacementOrdersView(),
    );
  }
}

class ReplacementOrdersView extends StatefulWidget {
  const ReplacementOrdersView({super.key});

  @override
  State<ReplacementOrdersView> createState() => _ReplacementOrdersViewState();
}

class _ReplacementOrdersViewState extends State<ReplacementOrdersView> {
  // Local state to track selections
  final Map<String, int?> _localSelections = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: CustomAppBar(
        title: "replacement_orders".tr(),
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: BlocBuilder<ReplacementOrdersCubit, ReplacementOrdersState>(
        builder: (context, state) {
          if (state is ReplacementOrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (state is ReplacementOrdersError) {
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
                      context.read<ReplacementOrdersCubit>().getReplacementOrders();
                    },
                    child: Text("retry".tr()),
                  ),
                ],
              ),
            );
          } else if (state is ReplacementOrdersLoaded) {
            if (state.replacementOrders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.box,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "no_replacement_orders".tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
                return ListView.builder(
                  padding: EdgeInsets.all(context.responsivePadding),
                  itemCount: state.replacementOrders.length,
                  itemBuilder: (context, index) {
                    final order = state.replacementOrders[index];
                    return _buildReplacementOrderCard(context, order);
                  },
                );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReplacementOrderCard(BuildContext context, ReplacementOrderModel order) {
    return Card(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.code,
                  style: TextStyles.textViewBold16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                  ),
                  child: Text(
                    order.statusAr,
                    style: TextStyles.textViewMedium12.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            
            // Order Items
            ...order.items.map((item) => _buildOrderItem(context, order, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, ReplacementOrderModel order, ReplacementOrderItemModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original Item
          _buildOriginalItemCard(context, order, item),
          
          SizedBox(height: 1.h),
          
          // Select one from items label
          Text(
            "select_one_from_items".tr(),
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 0.5.h),
          
          // Replacement Items
          ...item.replacements.map((replacement) => 
            _buildReplacementItemCard(context, order, item, replacement)
          ),
          
          SizedBox(height: 1.h),
          
          // Replace Item Button for this specific item
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _handleReplaceItemForSpecificItem(context, order, item);
              },
              icon: const Icon(
                Icons.refresh,
                color: AppColors.white,
                size: 18,
              ),
              label: Text(
                _isItemSelected(order.id, item.orderProductId)
                  ? "${"replace_item".tr()} (1)"
                  : "replace_item".tr(),
                style: TextStyles.textViewBold14.copyWith(
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isItemSelected(order.id, item.orderProductId) 
                  ? AppColors.primary 
                  : AppColors.textSecondary,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalItemCard(BuildContext context, ReplacementOrderModel order, ReplacementOrderItemModel item) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
            child: CustomCachedImage(
              imageUrl: item.baseImage,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
          
          SizedBox(width: 3.w),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nameAr,
                  style: TextStyles.textViewBold16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                 "${"quantity".tr()} ${item.quantity.toString()}", // You might want to get this from API
                  style: TextStyles.textViewMedium12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${item.total} ${"egp".tr()}',
                  style: TextStyles.textViewBold14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // Cancel Replacement Icon
          IconButton(
            onPressed: () {
              _showCancelReplacementDialog(context, order, item);
            },
            icon: Container(
              padding: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
border: Border.all(color: AppColors.error),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child:  Icon(
                Iconsax.trash,
                color: AppColors.error,
                size: 4.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplacementItemCard(BuildContext context, ReplacementOrderModel order, ReplacementOrderItemModel item, ReplacementItemModel replacement) {
    final isSelected = _isLocallySelected(order.id, item.orderProductId, replacement.replacementId);
    
    return Container(
      margin: EdgeInsets.only(bottom: 0.5.h),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Just update the visual selection state locally
          _updateLocalSelection(context, order.id, item.orderProductId, replacement.replacementId);
        },
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
              child: CustomCachedImage(
                imageUrl: replacement.baseImage,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            ),
            
            SizedBox(width: 3.w),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    replacement.nameAr,
                    style: TextStyles.textViewBold16.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "${"quantity".tr()} ${replacement.quantity.toString()}",
                    style: TextStyles.textViewMedium12.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${replacement.totalPrice.toString()} ${"egp".tr()}',
                    style: TextStyles.textViewBold14.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection Indicator
            if (isSelected)
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleReplaceItemForSpecificItem(BuildContext context, ReplacementOrderModel order, ReplacementOrderItemModel item) {
    final key = '${order.id}_${item.orderProductId}';
    final selectedReplacementId = _localSelections[key];
    
    if (selectedReplacementId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("please_select_replacement".tr()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    final cubit = context.read<ReplacementOrdersCubit>();
    cubit.selectReplacement(
      orderId: order.id,
      replacementId: selectedReplacementId,
      orderItemId: item.orderProductId,
    );
    
    // Clear local selection for this specific item after successful processing
    setState(() {
      _localSelections[key] = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("replacement_processed".tr()),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _updateLocalSelection(BuildContext context, int orderId, int orderItemId, int replacementId) {
    final key = '${orderId}_$orderItemId';
    setState(() {
      // Toggle selection - if already selected, deselect
      if (_localSelections[key] == replacementId) {
        _localSelections[key] = null;
      } else {
        _localSelections[key] = replacementId;
      }
    });
  }

  bool _isLocallySelected(int orderId, int orderItemId, int replacementId) {
    final key = '${orderId}_$orderItemId';
    return _localSelections[key] == replacementId;
  }

  bool _isItemSelected(int orderId, int orderItemId) {
    final key = '${orderId}_$orderItemId';
    return _localSelections[key] != null;
  }

  void _showCancelReplacementDialog(BuildContext context, ReplacementOrderModel order, ReplacementOrderItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("cancel_replacement".tr()),
          content: Text("are_you_sure_cancel_replacement".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel".tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ReplacementOrdersCubit>().cancelReplacement(
                  orderId: order.id,
                  orderItemId: item.orderProductId,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("replacement_cancelled".tr()),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: Text(
                "confirm".tr(),
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
