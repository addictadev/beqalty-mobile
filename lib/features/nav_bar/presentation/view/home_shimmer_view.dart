import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/shimmer_widget.dart';
import 'package:sizer/sizer.dart';

class HomeShimmerView extends StatelessWidget {
  const HomeShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          SizedBox(height: 6.h),
          // Header Shimmer
          _buildHeaderShimmer(context),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 3.h),

                    // Promotional Slider Shimmer
                    _buildPromotionalSliderShimmer(context),

                    SizedBox(height: 3.h),

                    // Categories Section Shimmer
                    _buildCategoriesShimmer(context),

                    SizedBox(height: 1.h),

                    // Points Card Shimmer
                    _buildPointsCardShimmer(context),

                    SizedBox(height: 2.h),

                    // Special Offers Title Shimmer
                    _buildSpecialOffersTitleShimmer(context),

                    SizedBox(height: 2.h),

                    // Special Offers Section Shimmer
                    _buildSpecialOffersShimmer(context),

                    SizedBox(height: 2.h),

                    // Saved Carts Section Shimmer
                    _buildSavedCartsShimmer(context),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderShimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      child: Row(
        children: [
          // Profile Avatar
          ShimmerWidget(isLoading: true, child: ShimmerCircle(size: 12.w)),

          SizedBox(width: context.responsiveMargin),

          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  isLoading: true,
                  child: ShimmerText(
                    width: 40.w,
                    height: 2.h,
                    margin: EdgeInsets.only(bottom: 0.5.h),
                  ),
                ),
                ShimmerWidget(
                  isLoading: true,
                  child: ShimmerText(width: 25.w, height: 1.5.h),
                ),
              ],
            ),
          ),

          // Search Icon
          ShimmerWidget(
            isLoading: true,
            child: ShimmerBox(width: 10.w, height: 10.w, borderRadius: 8.w),
          ),

          SizedBox(width: context.responsiveMargin),

          // Notification Icon
          ShimmerWidget(
            isLoading: true,
            child: ShimmerBox(width: 10.w, height: 10.w, borderRadius: 8.w),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalSliderShimmer(BuildContext context) {
    return ShimmerWidget(
      isLoading: true,
      child: ShimmerBox(
        width: double.infinity * 0.9,
        height: context.responsiveContainerHeight * 0.85,
        borderRadius: context.responsiveBorderRadius * 2,
      ),
    );
  }

  Widget _buildCategoriesShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 30.w, height: 2.h),
            ),
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 15.w, height: 1.5.h),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Categories Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: context.responsiveMargin,
            mainAxisSpacing: context.responsiveMargin,
            childAspectRatio: 0.8,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return ShimmerWidget(
              isLoading: true,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.shadowLight,
                  borderRadius: BorderRadius.circular(
                    context.responsiveBorderRadius,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerCircle(size: 8.w),
                    SizedBox(height: 1.h),
                    ShimmerText(width: 20.w, height: 1.h),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPointsCardShimmer(BuildContext context) {
    return ShimmerWidget(
      isLoading: true,
      child: Container(
        width: double.infinity,
        height: 12.h,
        decoration: BoxDecoration(
          color: AppColors.shadowLight,
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Row(
            children: [
              ShimmerCircle(size: 8.w),
              SizedBox(width: context.responsiveMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerText(
                      width: 25.w,
                      height: 1.5.h,
                      margin: EdgeInsets.only(bottom: 0.5.h),
                    ),
                    ShimmerText(width: 15.w, height: 1.h),
                  ],
                ),
              ),
              ShimmerBox(width: 20.w, height: 4.h, borderRadius: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOffersTitleShimmer(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ShimmerWidget(
        isLoading: true,
        child: ShimmerText(width: 25.w, height: 2.h),
      ),
    );
  }

  Widget _buildSpecialOffersShimmer(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 40.w,
            margin: EdgeInsets.only(right: context.responsiveMargin),
            child: ShimmerWidget(
              isLoading: true,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.shadowLight,
                  borderRadius: BorderRadius.circular(
                    context.responsiveBorderRadius,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ShimmerBox(
                      width: double.infinity,
                      height: 15.h,
                      borderRadius: context.responsiveBorderRadius,
                    ),
                    Padding(
                      padding: EdgeInsets.all(context.responsivePadding * 0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerText(
                            width: double.infinity,
                            height: 1.5.h,
                            margin: EdgeInsets.only(bottom: 0.5.h),
                          ),
                          ShimmerText(
                            width: 60.w,
                            height: 1.h,
                            margin: EdgeInsets.only(bottom: 0.5.h),
                          ),
                          ShimmerText(width: 20.w, height: 1.5.h),
                        ],
                      ),
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

  Widget _buildSavedCartsShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 30.w, height: 2.h),
            ),
            ShimmerWidget(
              isLoading: true,
              child: ShimmerText(width: 15.w, height: 1.5.h),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Saved Carts List
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 60.w,
                margin: EdgeInsets.only(right: context.responsiveMargin),
                child: ShimmerWidget(
                  isLoading: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.shadowLight,
                      borderRadius: BorderRadius.circular(
                        context.responsiveBorderRadius,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(context.responsivePadding),
                      child: Row(
                        children: [
                          ShimmerBox(
                            width: 8.w,
                            height: 8.w,
                            borderRadius: 4.w,
                          ),
                          SizedBox(width: context.responsiveMargin),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShimmerText(
                                  width: double.infinity,
                                  height: 1.5.h,
                                  margin: EdgeInsets.only(bottom: 0.5.h),
                                ),
                                ShimmerText(width: 40.w, height: 1.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
