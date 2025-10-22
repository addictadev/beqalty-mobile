import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import '../../data/services/order_rating_service.dart';
import '../../../../core/di/service_locator.dart';

class RatingBottomSheet extends StatefulWidget {
  final int orderId;
  final String deliveryPersonName;
  final VoidCallback? onRatingSubmitted;

  const RatingBottomSheet({
    super.key,
    required this.orderId,
    required this.deliveryPersonName,
    this.onRatingSubmitted,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.responsiveBorderRadius * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: context.responsiveMargin),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: context.responsiveMargin * 2),

          // Delivery icon
        Center(child:CustomImageAsset(assetName: AppAssets.deliveryPerson,width: 25.w,height: 25.w,)),

          SizedBox(height: context.responsiveMargin * 2),

          // Rating question
          Center(
            child: Text(
              "how_was_delivery".tr().isEmpty 
                  ? "How was your delivery with ${widget.deliveryPersonName}?"
                  : "how_was_delivery".tr().replaceAll('{name}', widget.deliveryPersonName),
              style: TextStyles.textViewBold18.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: context.responsiveMargin * 2),

          // Star rating
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      size: 40,
                      color: index < _selectedRating 
                          ? Colors.amber 
                          : AppColors.borderLight,
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: context.responsiveMargin * 2),

          // Comment input
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "write_comment_optional".tr().isEmpty 
                  ? "Write a comment (optional)"
                  : "write_comment_optional".tr(),
              hintStyle: TextStyles.textViewRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                borderSide: BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              contentPadding: EdgeInsets.all(context.responsivePadding),
            ),
          ),

          SizedBox(height: context.responsiveMargin * 2),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedRating > 0 && !_isSubmitting ? _submitRating : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: context.responsiveMargin * 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.w),
                ),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "submit".tr().isEmpty ? "Submit" : "submit".tr(),
                      style: TextStyles.textViewBold16.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          SizedBox(height: context.responsiveMargin),

          // Not now button
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "not_now".tr().isEmpty ? "Not Now" : "not_now".tr(),
                style: TextStyles.textViewMedium14.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          SizedBox(height: context.responsiveMargin),
        ],
      ),
    );
  }

  void _submitRating() async {
    if (_selectedRating == 0) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final ratingService = ServiceLocator.get<OrderRatingService>();
      
      await ratingService.submitOrderRating(
        orderId: widget.orderId,
        rating: _selectedRating,
        comment: _commentController.text.trim().isNotEmpty 
            ? _commentController.text.trim() 
            : null,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("rating_submitted_successfully".tr().isEmpty 
                ? "Rating submitted successfully" 
                : "rating_submitted_successfully".tr()),
            backgroundColor: AppColors.success,
          ),
        );
        
        if (widget.onRatingSubmitted != null) {
          widget.onRatingSubmitted!();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("failed_to_submit_rating".tr().isEmpty 
                ? "Failed to submit rating" 
                : "failed_to_submit_rating".tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
