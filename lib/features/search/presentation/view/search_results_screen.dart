import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/search_product_card.dart';

class SearchResultsScreen extends StatefulWidget {

  const SearchResultsScreen({
    super.key,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Search
            _buildSearchAppBar(context),
            
            // Search Results
            Expanded(
              child: _buildSearchResults(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          CustomBackButton(),
          
          SizedBox(width: context.responsiveMargin),
          
          // Search Bar
          Expanded(
            child: Container(
              height: context.responsiveButtonHeight / 2,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.search_normal,
                      color: AppColors.textSecondary,
                      size: context.responsiveIconSize,
                    ),
                    
                    SizedBox(width: context.responsiveMargin),
                    
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:'search_products'.tr(),
                          hintStyle: TextStyles.textViewRegular14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyles.textViewRegular14.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    // Sample milk products data
    final List<Map<String, dynamic>> milkProducts = [
      {
        'name': 'juhayna_milk'.tr(),
        'category': 'milk_category'.tr(),
        'price': 25.50,
        'image': AppAssets.juhaynaMilk,
      },
      {
        'name': 'juhayna_coconut_milk'.tr(),
        'category': 'milk_category'.tr(),
        'price': 75.00,
        'image': AppAssets.juhaynaCoconutMilk,
      },
      {
        'name': 'juhayna_cream_milk'.tr(),
        'category': 'milk_category'.tr(),
        'price': 64.25,
        'image': AppAssets.juhaynaCreamMilk,
      },
      {
        'name': 'chocolate_milk'.tr(),
        'category': 'milk_category'.tr(),
        'price': 48.00,
        'image': AppAssets.chocolateMilk,
      },
      {
        'name': 'al_marai_milk'.tr(),
        'category': 'milk_category'.tr(),
        'price': 48.75,
        'image': AppAssets.alMaraiMilk,
      },
    ];

    return Padding(
      padding: EdgeInsets.all(context.responsivePadding),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: milkProducts.length,
        itemBuilder: (context, index) {
          final product = milkProducts[index];
          return Padding(
            padding: EdgeInsets.only(bottom: context.responsiveMargin),
            child: SearchProductCard(
              productName: product['name'],
              productCategory: product['category'],
              productPrice: product['price'],
              productImage: product['image'],
              onTap: () {
                // Handle product tap
                debugPrint('Product tapped: ${product['name']}');
              },
            ),
          );
        },
      ),
    );
  }
}
