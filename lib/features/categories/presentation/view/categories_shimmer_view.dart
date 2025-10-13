import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/shimmer_widget.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:sizer/sizer.dart';

class CategoriesShimmerView extends StatelessWidget {
  const CategoriesShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: AuthBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: context.responsiveMargin * 2),

              // Title Shimmer
              ShimmerWidget(
                isLoading: true,
                child: ShimmerText(width: 40.w, height: 2.5.h),
              ),

              SizedBox(height: context.responsiveMargin),

              // Search Field Shimmer
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
                child: ShimmerWidget(
                  isLoading: true,
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.shadowLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: context.responsiveMargin * 2),

              // Categories Grid Shimmer
              Expanded(child: _buildCategoriesGridShimmer(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGridShimmer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: context.responsiveMargin,
          mainAxisSpacing: context.responsiveMargin,
          childAspectRatio: 0.9,
        ),
        itemCount: 12, // Show 12 shimmer items
        itemBuilder: (context, index) {
          return ShimmerWidget(
            isLoading: true,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  context.responsiveBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(context.responsivePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Container Shimmer
                    ShimmerWidget(
                      isLoading: true,
                      child: Container(
                        width: context.responsiveIconSize * 2,
                        height: context.responsiveIconSize * 2,
                        decoration: BoxDecoration(
                          color: AppColors.shadowLight,
                          borderRadius: BorderRadius.circular(
                            context.responsiveBorderRadius,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.responsiveMargin),

                    // Category Name Shimmer
                    ShimmerWidget(
                      isLoading: true,
                      child: ShimmerText(width: 25.w, height: 1.5.h),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
