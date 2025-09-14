import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../theme/app_colors.dart';
import '../utils/responsive_utils.dart';
import '../utils/styles/styles.dart';
import '../utils/font_family_utils.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool showDivider;
  final String? titleFontFamily;
  final String? subtitleFontFamily;

  const CustomRadioTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
    this.titleFontFamily,
    this.subtitleFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(!value),
            borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
                vertical: context.responsiveMargin * 2,
              ),
              child: Row(
                children: [
                  // Radio Button
                  Container(
                    width: context.responsiveIconSize * 0.8,
                    height: context.responsiveIconSize * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: value
                            ? AppColors.primary
                            : AppColors.borderLight,
                        width: 2,
                      ),
                    ),
                    child: value
                        ? Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),

                  SizedBox(width: context.responsiveMargin * 1.5),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.textViewMedium16.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 15.sp,
                            fontFamily:
                                titleFontFamily ??
                                FontFamilyUtils.getCurrentFontFamily(),
                          ),
                        ),
                        SizedBox(height: context.responsiveMargin * 0.3),
                        Text(
                          subtitle,
                          style: TextStyles.textViewRegular14.copyWith(
                            color: AppColors.textLight,
                            fontSize: 13.sp,
                            fontFamily:
                                subtitleFontFamily ??
                                FontFamilyUtils.getCurrentFontFamily(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Divider
        if (showDivider)
          Container(
            margin: EdgeInsets.symmetric(horizontal: context.responsivePadding),
            height: 1,
            color: AppColors.borderLight,
          ),
      ],
    );
  }
}
