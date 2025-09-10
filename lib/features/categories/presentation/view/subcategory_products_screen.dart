import 'package:baqalty/core/navigation_services/navigation_manager.dart';
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
import '../../../../core/widgets/saved_item_card.dart';

class SubcategoryProductsScreen extends StatefulWidget {
  final String subcategoryName;
  final String categoryName;

  const SubcategoryProductsScreen({
    super.key,
    required this.subcategoryName,
    required this.categoryName,
  });

  @override
  State<SubcategoryProductsScreen> createState() => _SubcategoryProductsScreenState();
}

class _SubcategoryProductsScreenState extends State<SubcategoryProductsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late List<AnimationController> _itemAnimationControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create staggered animations for each product item
    _itemAnimationControllers = List.generate(
      10, // Maximum number of products
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _itemAnimations = _itemAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();

    // Start animations with stagger
    _startAnimations();
  }

  void _startAnimations() {
    _animationController.forward();
    
    // Stagger the item animations
    for (int i = 0; i < _itemAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 60 * i), () {
        if (mounted) {
          _itemAnimationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    for (var controller in _itemAnimationControllers) {
      controller.dispose();
    }
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
                title: widget.subcategoryName.tr(),
                onBackPressed: () {
                  NavigationManager.pop();
                },
              ),
              SizedBox(height: context.responsiveMargin),
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                ),
                child: CustomTextFormField(
                  controller: _searchController,
                  hint: "search_products".tr(),
        
                  prefixIcon: Icon(
                    Iconsax.search_normal,
                    color: AppColors.textSecondary,
                  ),
                  onChanged: (value) {
                    // TODO: Implement search functionality
                  },
                ),
              ),
              // Products List
              Expanded(child: _buildProductsList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    final products = _getProductsForSubcategory(widget.subcategoryName);

    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: EdgeInsets.all(context.responsivePadding),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return AnimatedBuilder(
            animation: _itemAnimations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - _itemAnimations[index].value)),
                child: Opacity(
                  opacity: _itemAnimations[index].value.clamp(0.0, 1.0),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: context.responsiveMargin),
                    child: SavedItemCard(
                      productName: product['name'],
                      productCategory: product['category'],
                      productPrice: product['price'],
                      productImage: product['image'],
                      showFavoriteButton: false,
                      showAddToCartButton: false,
                      onTap: () {
                        // Add tap animation
                        if (index < _itemAnimationControllers.length) {
                          _itemAnimationControllers[index].reverse().then((_) {
                            _itemAnimationControllers[index].forward();
                          });
                        }
                        
                        NavigationManager.navigateTo(ProductDetailsScreen(
                          productName: product['name'],
                          productImage: product['image'],
                          productPrice: product['price'],
                          productCategory: product['category'],
                        ));
                      },
                      onFavorite: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product['name']} added to favorites'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      onAddToCart: () {
                        // TODO: Implement add to cart functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product['name']} added to cart'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.shopping_bag,
            size: context.responsiveIconSize * 4,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            "no_products_found".tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            "try_different_subcategory".tr(),
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

  List<Map<String, dynamic>> _getProductsForSubcategory(String subcategoryName) {
    // Mock data - in real app, this would come from API
    switch (subcategoryName.toLowerCase()) {
      case 'healthy':
        return [
          {
            'name': 'organic_nuts_mix'.tr(),
            'category': 'healthy_snacks'.tr(),
            'price': 12.99,
            'image': AppAssets.juhaynaMilk, // Using placeholder image
          },
          {
            'name': 'dried_fruits'.tr(),
            'category': 'healthy_snacks'.tr(),
            'price': 8.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
          {
            'name': 'granola_bars'.tr(),
            'category': 'healthy_snacks'.tr(),
            'price': 6.99,
            'image': AppAssets.juhaynaCreamMilk,
          },
          {
            'name': 'protein_snacks'.tr(),
            'category': 'healthy_snacks'.tr(),
            'price': 15.99,
            'image': AppAssets.chocolateMilk,
          },
        ];
      case 'savory':
        return [
          {
            'name': 'chips_variety'.tr(),
            'category': 'savory_snacks'.tr(),
            'price': 4.99,
            'image': AppAssets.juhaynaMilk,
          },
          {
            'name': 'pretzels'.tr(),
            'category': 'savory_snacks'.tr(),
            'price': 3.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
          {
            'name': 'crackers'.tr(),
            'category': 'savory_snacks'.tr(),
            'price': 2.99,
            'image': AppAssets.juhaynaCreamMilk,
          },
          {
            'name': 'popcorn'.tr(),
            'category': 'savory_snacks'.tr(),
            'price': 5.99,
            'image': AppAssets.chocolateMilk,
          },
        ];
      case 'sweet':
        return [
          {
            'name': 'chocolate_bars'.tr(),
            'category': 'sweet_snacks'.tr(),
            'price': 7.99,
            'image': AppAssets.juhaynaMilk,
          },
          {
            'name': 'cookies'.tr(),
            'category': 'sweet_snacks'.tr(),
            'price': 4.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
          {
            'name': 'candy_mix'.tr(),
            'category': 'sweet_snacks'.tr(),
            'price': 6.99,
            'image': AppAssets.juhaynaCreamMilk,
          },
          {
            'name': 'gummy_bears'.tr(),
            'category': 'sweet_snacks'.tr(),
            'price': 3.99,
            'image': AppAssets.chocolateMilk,
          },
        ];
      case 'popcorn':
        return [
          {
            'name': 'butter_popcorn'.tr(),
            'category': 'popcorn'.tr(),
            'price': 5.99,
            'image': AppAssets.juhaynaMilk,
          },
          {
            'name': 'caramel_popcorn'.tr(),
            'category': 'popcorn'.tr(),
            'price': 6.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
          {
            'name': 'cheese_popcorn'.tr(),
            'category': 'popcorn'.tr(),
            'price': 7.99,
            'image': AppAssets.juhaynaCreamMilk,
          },
        ];
      case 'frozen':
        return [
          {
            'name': 'ice_cream_sandwich'.tr(),
            'category': 'frozen_treats'.tr(),
            'price': 8.99,
            'image': AppAssets.juhaynaMilk,
          },
          {
            'name': 'frozen_yogurt'.tr(),
            'category': 'frozen_treats'.tr(),
            'price': 6.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
          {
            'name': 'frozen_fruit_bars'.tr(),
            'category': 'frozen_treats'.tr(),
            'price': 4.99,
            'image': AppAssets.juhaynaCreamMilk,
          },
        ];
      case 'ice_cream':
        return [
          {
            'name': 'vanilla_ice_cream'.tr(),
            'category': 'ice_cream'.tr(),
            'price': 9.99,
            'image': AppAssets.juhaynaMilk,
          },
          {
            'name': 'chocolate_ice_cream'.tr(),
            'category': 'ice_cream'.tr(),
            'price': 10.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
          {
            'name': 'strawberry_ice_cream'.tr(),
            'category': 'ice_cream'.tr(),
            'price': 11.99,
            'image': AppAssets.juhaynaCreamMilk,
          },
        ];
      case 'creamy':
        return [
          {
            'name': 'cream_cookies'.tr(),
            'category': 'creamy_snacks'.tr(),
            'price': 5.99,
            'image': AppAssets.juhaynaMilk,
          },
          {
            'name': 'cream_cakes'.tr(),
            'category': 'creamy_snacks'.tr(),
            'price': 7.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
        ];
      case 'chilled':
        return [
          {
            'name': 'cold_drinks'.tr(),
            'category': 'chilled_beverages'.tr(),
            'price': 3.99,
            'image': AppAssets.juhaynaMilk,
          },
          {
            'name': 'chilled_yogurt'.tr(),
            'category': 'chilled_beverages'.tr(),
            'price': 4.99,
            'image': AppAssets.juhaynaCoconutMilk,
          },
        ];
      default:
        return [
          {
            'name': 'sample_product'.tr(),
            'category': 'general'.tr(),
            'price': 9.99,
            'image': AppAssets.juhaynaMilk,
          },
        ];
    }
  }
}
