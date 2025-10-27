import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class PromotionalCard extends StatelessWidget {
  final VoidCallback? onPlaceOrderTap;
  final String? title;
  final String? buttonText;
  final String? image;

  const PromotionalCard({
    super.key,
    this.onPlaceOrderTap,
    this.title,
    this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: context.responsiveContainerHeight * 1.8,
      ),
      margin: EdgeInsets.only(right: context.responsivePadding / 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomCachedImage(
              imageUrl: image ?? '',
              width: double.infinity,
              height: context.responsiveContainerHeight * 1.8,
              fit: BoxFit.cover,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(context.responsivePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: context.responsivePadding * 5),
                  Spacer(),
                  // _buildCharacterIllustration(),
                  SizedBox(width: context.responsivePadding),

                  // Expanded(child: _buildContentSection(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }




}
