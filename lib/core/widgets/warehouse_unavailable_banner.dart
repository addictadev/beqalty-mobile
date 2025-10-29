import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/profile/presentation/view/addresses_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

/// Widget to display when warehouse is not available
/// Shows a banner with message and button to navigate to addresses screen
class WarehouseUnavailableBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onAddAddress;

  const WarehouseUnavailableBanner({
    super.key,
    required this.message,
    this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin * 0.5,
      ),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Iconsax.location,
                color: AppColors.warning,
                size: context.responsiveIconSize * 1.2,
              ),
              SizedBox(width: context.responsiveMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "no_default_address".tr(),
                      style: TextStyles.textViewBold14.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                    // Text(
                    //   message,
                    //   style: TextStyles.textViewRegular12.copyWith(
                    //     color: AppColors.textSecondary,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsiveMargin),
          PrimaryButton(
            text: "add_new_address".tr(),
            onPressed: onAddAddress ?? () {
              NavigationManager.navigateTo(const AddressesScreen());
            },
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
