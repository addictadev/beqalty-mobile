import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart' show CustomAppBar;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final double productPrice;
  final String productCategory;

  const ProductDetailsScreen({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productCategory,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 2;
  String selectedSize = "250 g";
  String selectedFlavor = "Original";

  final List<String> sizeOptions = ["250 g", "500 g", "700 g"];
  final List<String> flavorOptions = ["Original", "Spice"];

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      backgroundHeight: MediaQuery.of(context).size.height * 0.25,
      overlayOpacity: 0.3,
      child: SafeArea(
        child: Column(
          children: [
            // App Bar (Fixed)
            CustomAppBar(
              title: "product_details".tr(),
              onBackPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Image Section with Action Buttons
                    Container(
                      width: context.responsiveWidth,
                      padding: EdgeInsets.all(3.w),
                      margin: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          context.responsiveBorderRadius * 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Product Image Container with fixed height
                          SizedBox(
                            height: 30.h,
                            child: Stack(
                              children: [
                                // Product Image
                                _buildProductImage(context),

                                // Action Buttons (Share and Favorite)
                                Positioned(
                                  top: context.responsiveMargin,
                                  right: context.responsivePadding,
                                  child: Row(
                                    children: [
                                      // Share Button
                                      Container(
                                        padding: EdgeInsets.all(
                                          context.responsivePadding * .6,
                                        ),
                                        width: context.responsiveIconSize * 1.8,
                                        height:
                                            context.responsiveIconSize * 1.8,
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.shadowLight,
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CustomSvgImage(
                                          width: 12,
                                          assetName: AppAssets.share,
                                        ),
                                      ),

                                      SizedBox(width: context.responsiveMargin),
                                      // Favorite Button
                                      Container(
                                        padding: EdgeInsets.all(
                                          context.responsivePadding * .6,
                                        ),
                                        width: context.responsiveIconSize * 1.8,
                                        height:
                                            context.responsiveIconSize * 1.8,
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withOpacity(
                                            0.1,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [],
                                        ),
                                        child: CustomSvgImage(
                                          width: 12,
                                          assetName: AppAssets.heart,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Pagination Dots
                          _buildPaginationDots(context),
                        ],
                      ),
                    ),

                    _buildProductInfo(context),

                    SizedBox(height: context.responsiveMargin * 2),
                    // Bottom Section with Details (Scrollable)
                    _buildBottomSection(context),
                    SizedBox(
                      height: context.responsiveMargin * 2,
                    ), // More Like This Section
                    _buildMoreLikeThisSection(context),

                    SizedBox(height: context.responsiveMargin * 2),

                    // Extra space for bottom padding
                    SizedBox(height: context.responsiveMargin * 4),
                  ],
                ),
              ),
            ),

            // Fixed Action Buttons at Bottom
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }


  Widget _buildProductImage(BuildContext context) {
    return Center(
      child: Container(
        width: context.responsiveWidth,
        height: context.responsiveWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            context.responsiveBorderRadius * 2,
          ),
          child: Image.asset(
            widget.productImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.scaffoldBackground,
                child: Icon(
                  Icons.image_not_supported,
                  color: AppColors.textSecondary,
                  size: context.responsiveIconSize * 2,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationDots(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 1
                ? AppColors.textPrimary
                : AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        );
      }),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.responsiveBorderRadius * 3),
          topRight: Radius.circular(context.responsiveBorderRadius * 3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Title and Description

            // Quantity Selector
            _buildQuantitySelector(context),

            SizedBox(height: context.responsiveMargin * 2),

            // Size Options
            _buildSizeOptions(context),

            SizedBox(height: context.responsiveMargin * 2),

            // Flavor Options
            _buildFlavorOptions(context),

            SizedBox(height: context.responsiveMargin * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title
          Text(
            "crunchy_chicken_nuggets".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: context.responsiveMargin),

          // Description
          Text(
            "chicken_nuggets_description".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "quantity".tr(),
          style: TextStyles.textViewMedium16.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: context.responsiveMargin * 1.5),

        // Quantity Controls
        Row(
          children: [
            // Decrease Button
            GestureDetector(
              onTap: () {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                  });
                }
              },
              child: Container(
                width: context.responsiveIconSize * 1.2,
                height: context.responsiveIconSize * 1.2,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    context.responsiveBorderRadius * .8,
                  ),
                  border: Border.all(color: AppColors.textPrimary, width: 1.5),
                ),
                child: Icon(
                  Icons.remove,
                  color: AppColors.textPrimary,
                  size: context.responsiveIconSize,
                ),
              ),
            ),

            SizedBox(width: context.responsiveMargin),

            // Quantity Display
            Text(
              quantity.toString(),
              style: TextStyles.textViewBold18.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(width: context.responsiveMargin),

            // Increase Button
            GestureDetector(
              onTap: () {
                setState(() {
                  quantity++;
                });
              },
              child: Container(
                width: context.responsiveIconSize * 1.2,
                height: context.responsiveIconSize * 1.2,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(
                    context.responsiveBorderRadius * .8,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.white,
                  size: context.responsiveIconSize,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeOptions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "size".tr(),
          style: TextStyles.textViewMedium16.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: context.responsiveMargin),

        Row(
          children: sizeOptions.map((size) {
            final isSelected = selectedSize == size;
            return SizedBox(
              width: context.responsiveWidth * 0.25,
              height: 4.h,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = size;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: sizeOptions.last == size
                        ? 0
                        : context.responsiveMargin,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: context.responsiveMargin,
                    horizontal: context.responsivePadding,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.textPrimary : AppColors.white,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius * 2,
                    ),
                    border: Border.all(
                      color: AppColors.textPrimary,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    size,
                    textAlign: TextAlign.center,
                    style: TextStyles.textViewMedium14.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFlavorOptions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "flavor".tr(),
          style: TextStyles.textViewMedium16.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: context.responsiveMargin),

        Row(
          children: flavorOptions.map((flavor) {
            final isSelected = selectedFlavor == flavor;
            return SizedBox(
              width: context.responsiveWidth * 0.3,
              height: 4.h,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFlavor = flavor;
                  });
                },
                child: Container(
                  width: context.responsiveWidth * 0.3,
                  margin: EdgeInsets.only(
                    right: flavorOptions.last == flavor
                        ? 0
                        : context.responsiveMargin,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: context.responsiveMargin,
                    horizontal: context.responsivePadding * .5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.textPrimary : AppColors.white,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius * 2,
                    ),
                    border: Border.all(
                      color: AppColors.textPrimary,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    flavor,
                    textAlign: TextAlign.center,
                    style: TextStyles.textViewMedium14.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Add to Cart Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "253",
                style: TextStyles.textViewBold20.copyWith(color: Colors.green),
              ),
              Text(
                'EGP',
                style: TextStyles.textViewBold16.copyWith(color: Colors.green),
              ),
            ],
          ),

          PrimaryButton(
            text: "place_order".tr(),
            width: 45.w,
            onPressed: () {},
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMoreLikeThisSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "more_like_this".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: context.responsiveMargin),

          SizedBox(
            height:
                context.responsiveContainerHeight *
                1.1, // Made bigger as requested
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: context.responsiveWidth * 0.42,
                  margin: EdgeInsets.only(right: context.responsiveMargin),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius * 1.5,
                    ),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fix overflow
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          context.responsiveBorderRadius,
                        ),
                        child: Image.asset(
                          height: 13.h,
                          AppAssets.juhaynaCoconutMilk, // Placeholder image
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.borderLight,
                              child: Icon(
                                Icons.image_not_supported,
                                color: AppColors.textSecondary,
                                size: context.responsiveIconSize,
                              ),
                            );
                          },
                        ),
                      ),

                      // Product Info
                      Flexible(
                        // Changed from Expanded to Flexible to prevent overflow
                        child: Padding(
                          padding: EdgeInsets.all(context.responsivePadding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Fix overflow
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "juhayna_yogurt_plain".tr(),
                                style: TextStyles.textViewMedium14.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              SizedBox(height: context.responsiveMargin * 0.3),

                              Text(
                                "12.25 ${"egp".tr()}",
                                style: TextStyles.textViewBold16.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
