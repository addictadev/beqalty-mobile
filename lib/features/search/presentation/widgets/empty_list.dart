  import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

Widget BuildEmptyState(BuildContext context,{bool isSearchResult = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom search icon with purple background
     CustomImageAsset(assetName: isSearchResult?AppAssets.noResults:AppAssets.categoryIcon, width: 20.w, height: 20.w),
          SizedBox(height: 1.5.h),
          // Main message
          Text(
            isSearchResult ? "no_search_results".tr() : "no_results_found".tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: .5.h),
          // Suggestion message
          Text(
            isSearchResult ? "try_different_search_terms".tr() :"categories_will_appear_here".tr(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
