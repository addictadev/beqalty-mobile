import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/category_product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/styles/styles.dart';
import '../../data/models/subcategory_products_response_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CategoryGridView extends StatelessWidget {
  final List<dynamic> products;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;
  final bool showHeader;
  final String? headerText;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final String? sharedCartId;

  const CategoryGridView({
    super.key,
    required this.products,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.showHeader = false,
    this.headerText,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.crossAxisSpacing = 2.0,
    this.mainAxisSpacing = 2.0,
    this.sharedCartId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
     
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
                    return CategoryProductCard(
                      product: product,
                      width: double.infinity,
                      categoryName: headerText ?? "",
                      sharedCartId: sharedCartId,
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
            Icons.inventory_2_outlined,
            size: 15.w,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 4.h),
          Text(
            "no_products_available".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "check_back_later".tr(),
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
