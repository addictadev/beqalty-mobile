import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/shimmer_widget.dart';
import 'package:sizer/sizer.dart';

class AddressesShimmerView extends StatelessWidget {
  const AddressesShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Shimmer
            _buildAppBarShimmer(context),

            // Addresses List Shimmer
            Expanded(child: _buildAddressesListShimmer(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarShimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      child: Row(
        children: [
          // Back Button Shimmer
          ShimmerWidget(
            isLoading: true,
            child: ShimmerBox(width: 10.w, height: 10.w, borderRadius: 5.w),
          ),

          SizedBox(width: context.responsiveMargin),

          // Title Shimmer
          Expanded(
            child: ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 30.w, height: 2.5.h),
            ),
          ),

          SizedBox(width: context.responsiveMargin),

          // Add Button Shimmer
          ShimmerWidget(
            isLoading: true,
            child: ShimmerBox(width: 10.w, height: 10.w, borderRadius: 5.w),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesListShimmer(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(context.responsivePadding),
      itemCount: 6, // Show 6 shimmer address cards
      itemBuilder: (context, index) {
        return _buildAddressCardShimmer(context, index);
      },
    );
  }

  Widget _buildAddressCardShimmer(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: context.responsiveMargin),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
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
        child: Row(
          children: [
            // Address Type Icon Shimmer
            ShimmerWidget(
              isLoading: true,
              child: ShimmerBox(
                width: context.responsiveIconSize * 1.5,
                height: context.responsiveIconSize * 1.5,
                borderRadius: 8,
              ),
            ),

            SizedBox(width: context.responsiveMargin),

            // Address Details Shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row Shimmer
                  Row(
                    children: [
                      // Address Title Shimmer
                      ShimmerWidget(
                        isLoading: true,
                        child: ShimmerText(
                          width: _getRandomWidth(
                            20,
                            35,
                            index,
                          ), // Random width for variety
                          height: 1.8.h,
                        ),
                      ),

                      SizedBox(width: context.responsiveMargin * 0.5),

                      // Default Badge Shimmer (sometimes)
                      if (index % 3 == 0) ...[
                        ShimmerWidget(
                          isLoading: true,
                          child: ShimmerBox(
                            width: 8.w,
                            height: 2.h,
                            borderRadius: 4,
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: context.responsiveMargin * 0.5),

                  // Address Line 1 Shimmer
                  ShimmerWidget(
                    isLoading: true,
                    child: ShimmerText(
                      width: _getRandomWidth(60, 90, index),
                      height: 1.4.h,
                    ),
                  ),

                  SizedBox(height: context.responsiveMargin * 0.3),

                  // Address Line 2 Shimmer
                  ShimmerWidget(
                    isLoading: true,
                    child: ShimmerText(
                      width: _getRandomWidth(40, 70, index),
                      height: 1.4.h,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: context.responsiveMargin),

            // More Options Button Shimmer
            ShimmerWidget(
              isLoading: true,
              child: ShimmerBox(
                width: context.responsiveIconSize,
                height: context.responsiveIconSize,
                borderRadius: context.responsiveIconSize * 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generate random width for shimmer text to create variety
  double _getRandomWidth(int min, int max, int index) {
    final random = (min + (index * 7) % (max - min)).toDouble();
    return random.w;
  }
}

/// Alternative shimmer view for empty state
class AddressesEmptyShimmerView extends StatelessWidget {
  const AddressesEmptyShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar Shimmer
            _buildAppBarShimmer(context),

            // Empty State Shimmer
            Expanded(child: _buildEmptyStateShimmer(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarShimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      child: Row(
        children: [
          // Back Button Shimmer
          ShimmerWidget(
            isLoading: true,
            child: ShimmerBox(width: 10.w, height: 10.w, borderRadius: 5.w),
          ),

          SizedBox(width: context.responsiveMargin),

          // Title Shimmer
          Expanded(
            child: ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 30.w, height: 2.5.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateShimmer(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Icon Shimmer
            ShimmerWidget(isLoading: true, child: ShimmerCircle(size: 20.w)),

            SizedBox(height: context.responsiveMargin * 2),

            // Empty State Title Shimmer
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(
                width: 50.w,
                height: 2.5.h,
                margin: EdgeInsets.only(bottom: context.responsiveMargin),
              ),
            ),

            // Empty State Description Shimmer
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(
                width: 70.w,
                height: 1.8.h,
                margin: EdgeInsets.only(bottom: context.responsiveMargin * 3),
              ),
            ),

            // Add Address Button Shimmer
            ShimmerWidget(
              isLoading: true,
              child: ShimmerBox(
                width: double.infinity,
                height: 6.h,
                borderRadius: context.responsiveBorderRadius,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
