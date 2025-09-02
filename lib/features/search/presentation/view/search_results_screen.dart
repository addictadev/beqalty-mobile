import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart'
    show ProductDetailsScreen;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';

import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/search_product_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

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
      body: AuthBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: "search_products".tr(),
                onBackPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: context.responsiveMargin),
              // App Bar with Search
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
                child: CustomTextFormField(
                  controller: _searchController,
                  hint: "search_products".tr(),
                  fillColor: Colors.transparent,
                  borderColor: AppColors.borderLight,

                  prefixIcon: Icon(
                    Iconsax.search_normal,
                    color: AppColors.textSecondary,
                  ),
                  onChanged: (value) {
                    // Handle search
                  },
                ),
              ),
              // Search Results
              Expanded(child: _buildSearchResults(context)),
            ],
          ),
        ),
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
        'price': 48.75,
        'image': AppAssets.alMaraiMilk,
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
      {
        'name': 'juhayna_milk'.tr(),
        'category': 'milk_category'.tr(),
        'price': 25.50,
        'image': AppAssets.juhaynaMilk,
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
                // Navigate to product details
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      productName: product['name'],
                      productImage: product['image'],
                      productPrice: product['price'],
                      productCategory: product['category'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
