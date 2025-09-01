import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:sizer/sizer.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImagePath;
  final VoidCallback onEditProfileTap;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.profileImagePath,
    required this.onEditProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFF4A4E69), // Slightly lighter shade
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.responsivePadding),
          child: Column(
            children: [
              // Top row with title and edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: TextStyles.textViewBold24.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: onEditProfileTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsivePadding,
                        vertical: context.responsiveMargin,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          context.responsiveBorderRadius,
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyles.textViewMedium14.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: context.responsiveMargin * 3),
              
              // User profile information
              Row(
                children: [
                  // Profile image
                  Container(
                    width: context.responsiveIconSize * 2.5,
                    height: context.responsiveIconSize * 2.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.characterSkinTone,
                      border: Border.all(
                        color: AppColors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowMedium,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CustomImageAsset(
                        assetName: profileImagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: context.responsiveMargin * 2),
                  
                  // User details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyles.textViewBold20.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: context.responsiveMargin * 0.5),
                        Text(
                          userEmail,
                          style: TextStyles.textViewRegular14.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: context.responsiveMargin * 2),
            ],
          ),
        ),
      ),
    );
  }
}
