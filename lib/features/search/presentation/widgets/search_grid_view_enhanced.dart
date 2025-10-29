import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/styles/styles.dart';
import '../../data/models/search_response_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchGridViewEnhanced extends StatelessWidget {
  final List<SearchProductModel> products;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool showHeader;
  final String? headerText;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const SearchGridViewEnhanced({
    super.key,
    required this.products,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.showHeader = false,
    this.headerText,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.crossAxisSpacing = 4.0,
    this.mainAxisSpacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Optional header
        if (showHeader && headerText != null)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            child: Row(
              children: [
                Text(
                  headerText!,
                  style: TextStyles.textViewMedium16.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Spacer(),
                if (products.isNotEmpty)
                  Text(
                    "${products.length} ${"items".tr()}",
                    style: TextStyles.textViewRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        
        // Grid view
        Expanded(
          child: products.isEmpty
              ? _buildEmptyState(context)
              : GridView.builder(
                  padding: EdgeInsets.all(4.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: crossAxisSpacing.w,
                    mainAxisSpacing: mainAxisSpacing.w,
                  ),
                  itemCount: products.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      // Loading indicator for pagination
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(3.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final product = products[index];
                    return ProductCard(
                      product: product,
                      width: double.infinity,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 15.w,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 4.h),
          Text(
            "no_products_found".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "try_different_search".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
