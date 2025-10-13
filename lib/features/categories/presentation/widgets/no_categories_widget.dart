import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class NoCategoriesWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final bool isSearchResult;

  const NoCategoriesWidget({
    super.key,
    this.message,
    this.onRetry,
    this.isSearchResult = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding * 2,
        vertical: context.responsivePadding * 3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Illustration Container
          Container(
            width: 80.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isSearchResult ? Icons.search_off : Icons.category_outlined,
              size: 60,
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),

          SizedBox(height: context.responsiveMargin * 2),

          // Title
          Text(
            isSearchResult
                ? "no_search_results".tr()
                : "no_categories_found".tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin),

          // Description
          Text(
            message ??
                (isSearchResult
                    ? "try_different_search_terms".tr()
                    : "categories_will_appear_here".tr()),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          if (onRetry != null && !isSearchResult) ...[
            SizedBox(height: context.responsiveMargin * 2),

            // Retry Button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 18, color: AppColors.white),
              label: Text(
                "retry".tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],

          if (isSearchResult) ...[
            SizedBox(height: context.responsiveMargin * 2),

            // Search Tips
            Container(
              padding: EdgeInsets.all(context.responsivePadding),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "search_tips".tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "check_spelling_or_try_general_terms".tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
