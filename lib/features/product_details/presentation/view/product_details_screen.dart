import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

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
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          // Background Image
          _buildBackgroundImage(),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                _buildAppBar(context),
                
                // Product Content
                Expanded(
                  child: _buildProductContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.productImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.black.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      child: Row(
        children: [
          // Back Button
          CustomBackButton(),
          
          const Spacer(),
          
          // Favorite Button
          Container(
            width: context.responsiveIconSize * 2.5,
            height: context.responsiveIconSize * 2.5,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Iconsax.heart,
              color: AppColors.primary,
              size: context.responsiveIconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.responsiveMargin * 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.responsiveBorderRadius * 3),
          topRight: Radius.circular(context.responsiveBorderRadius * 3),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(context),
            
            SizedBox(height: context.responsiveMargin * 2),
            
            // Product Info
            _buildProductInfo(context),
            
            SizedBox(height: context.responsiveMargin * 2),
            
            // Quantity Selector
            _buildQuantitySelector(context),
            
            SizedBox(height: context.responsiveMargin * 2),
            
            // Description
            _buildDescription(context),
            
            const Spacer(),
            
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Center(
      child: Container(
        width: context.responsiveWidth * 0.6,
        height: context.responsiveWidth * 0.6,
        decoration: BoxDecoration(
          color: AppColors.borderLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
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

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          widget.productName,
          style: TextStyles.textViewBold24.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        
        SizedBox(height: context.responsiveMargin * 0.5),
        
        // Category
        Text(
          widget.productCategory,
          style: TextStyles.textViewRegular14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        
        SizedBox(height: context.responsiveMargin),
        
        // Price
        Row(
          children: [
            Text(
              "${widget.productPrice.toStringAsFixed(2)} ${"egp".tr()}",
              style: TextStyles.textViewBold26.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            
            SizedBox(width: context.responsiveMargin),
            
            // Original Price (if on sale)
            Text(
              "${(widget.productPrice * 1.2).toStringAsFixed(2)} ${"egp".tr()}",
              style: TextStyles.textViewRegular16.copyWith(
                color: AppColors.textSecondary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Row(
      children: [
        Text(
          "quantity".tr(),
          style: TextStyles.textViewMedium16.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const Spacer(),
        
        // Quantity Controls
        Container(
          decoration: BoxDecoration(
            color: AppColors.borderLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          ),
          child: Row(
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
                  width: context.responsiveIconSize * 2.5,
                  height: context.responsiveIconSize * 2.5,
                  decoration: BoxDecoration(
                    color: quantity > 1 ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(context.responsiveBorderRadius),
                      bottomLeft: Radius.circular(context.responsiveBorderRadius),
                    ),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: AppColors.white,
                    size: context.responsiveIconSize,
                  ),
                ),
              ),
              
              // Quantity Display
              Container(
                width: context.responsiveIconSize * 3,
                height: context.responsiveIconSize * 2.5,
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: TextStyles.textViewBold18.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              
              // Increase Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    quantity++;
                  });
                },
                child: Container(
                  width: context.responsiveIconSize * 2.5,
                  height: context.responsiveIconSize * 2.5,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(context.responsiveBorderRadius),
                      bottomRight: Radius.circular(context.responsiveBorderRadius),
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
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "description".tr(),
          style: TextStyles.textViewMedium16.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: context.responsiveMargin),
        
        Text(
          "product_description".tr(),
          style: TextStyles.textViewRegular14.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Add to Cart Button
        PrimaryButton(
          text: "add_to_cart".tr(),
          onPressed: () {
            // Handle add to cart
            debugPrint('Add to cart: ${widget.productName} x $quantity');
          },
          color: AppColors.primary,
          width: double.infinity,
        ),
        
        SizedBox(height: context.responsiveMargin),
        
        // Buy Now Button
        PrimaryButton(
          text: "buy_now".tr(),
          onPressed: () {
            // Handle buy now
            debugPrint('Buy now: ${widget.productName} x $quantity');
          },
          color: AppColors.white,
          textStyle: TextStyles.textViewMedium16.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          width: double.infinity,
        ),
      ],
    );
  }
}
