import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'saved_cart_item.dart';

class SavedCartsSection extends StatelessWidget {
  final VoidCallback? onViewAllTap;
  final Function(String)? onCartTap;
  final Function()? onCreateNewCart;
  final List<SavedCartModel> savedCarts;
  final VoidCallback? onRefreshNeeded;

  const SavedCartsSection({
    super.key, 
    this.onViewAllTap, 
    this.onCartTap,
    this.onCreateNewCart,
    required this.savedCarts,
    this.onRefreshNeeded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "saved_carts".tr(),
                style: TextStyles.textViewBold16.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onViewAllTap?.call();
                  // Refresh after returning from view all
                  onRefreshNeeded?.call();
                },
                child: Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: context.responsiveIconSize * 1.2,
                ),
              ),
            ],
          ),

          SizedBox(height: context.responsiveMargin * 1.5),

          // Saved Cart Items or Create New Cart Button
          _buildSavedCartsContent(context),
        ],
      ),
    );
  }

  Widget _buildSavedCartsContent(BuildContext context) {
    if (savedCarts.isEmpty) {
      // Show create new cart button if no saved carts
      return PrimaryButton(
        margin: EdgeInsets.symmetric(vertical: context.responsivePadding),
        text: "create_new_cart".tr(),
        onPressed: () async {
          await onCreateNewCart?.call();
          // Only refresh if we have a callback
          onRefreshNeeded?.call();
        },
        color: AppColors.primary,
        textStyle: TextStyles.textViewMedium16.copyWith(
          color: Colors.white,
        ),
      );
    } else {
      // Show first two saved carts
      final cartsToShow = savedCarts.take(2).toList();
      
      return Row(
        children: [
          for (int i = 0; i < cartsToShow.length; i++) ...[
            SavedCartItem(
              title: cartsToShow[i].name,
              onTap: () async {
                await onCartTap?.call("${cartsToShow[i].name}|${cartsToShow[i].id}");
                // Only refresh if we have a callback
                onRefreshNeeded?.call();
              },
             
            ),
            if (i < cartsToShow.length - 1) 
              SizedBox(width: context.responsiveMargin),
          ],
        ],
      );
    }
  }
}
