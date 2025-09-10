import 'package:baqalty/core/widgets/custom_appbar.dart' show CustomAppBar;
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart' show AuthBackgroundWidget;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';

import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/core/widgets/food_doodles_background.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'subcategory_products_screen.dart';

class SubcategoryScreen extends StatefulWidget {
  final String categoryName;

  const SubcategoryScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen>
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

    // Create staggered animations for each subcategory item
    _itemAnimationControllers = List.generate(
      8, // Number of subcategories
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _itemAnimations = _itemAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    // Start animations with stagger
    _startAnimations();
  }

  void _startAnimations() {
    _animationController.forward();
    
    // Stagger the item animations
    for (int i = 0; i < _itemAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 80 * i), () {
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
      body: 
      
      AuthBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
CustomAppBar(
                title: widget.categoryName.tr(),
             
              ),  
                            SizedBox(height: context.responsiveMargin),
            
              // Search Bar
              _buildSearchBar(context),
              
              // Subcategories Grid
              Expanded(
                child: _buildSubcategoriesGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: CustomTextFormField(
        controller: _searchController,
        hint: "search_subcategories".tr(),
        prefixIcon: Icon(
          Iconsax.search_normal_1,
          color: AppColors.textSecondary,
        ),
        onChanged: (value) {
          // TODO: Implement search functionality
        },
      ),
    );
  }

  Widget _buildSubcategoriesGrid(BuildContext context) {
    final subcategories = _getSubcategoriesForCategory(widget.categoryName);

    if (subcategories.isEmpty) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: GridView.builder(
        padding: EdgeInsets.only(top: context.responsiveMargin * 2),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: context.responsiveMargin,
          mainAxisSpacing: context.responsiveMargin,
          childAspectRatio: 0.9,
        ),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return AnimatedBuilder(
            animation: _itemAnimations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _itemAnimations[index].value,
                child: Transform.translate(
                  offset: Offset(0, 40 * (1 - _itemAnimations[index].value)),
                  child: Opacity(
                    opacity: _itemAnimations[index].value.clamp(0.0, 1.0),
                    child: _buildSubcategoryCard(context, subcategory),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSubcategoryCard(BuildContext context, SubcategoryData subcategory) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
          onTap: () {
            // Add tap animation
            final subcategories = _getSubcategoriesForCategory(widget.categoryName);
            final index = subcategories.indexOf(subcategory);
            if (index >= 0 && index < _itemAnimationControllers.length) {
              _itemAnimationControllers[index].reverse().then((_) {
                _itemAnimationControllers[index].forward();
              });
            }
            _onSubcategoryTap(context, subcategory);
          },
          child: Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.responsiveIconSize * 2.5,
                  height: context.responsiveIconSize * 2.5,
                  padding: EdgeInsets.all(context.responsivePadding * 0.8),
                  decoration: BoxDecoration(
                    color: subcategory.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius,
                    ),
                  ),
                  child: Icon(
                    subcategory.icon,
                    color: subcategory.iconColor,
                    size: context.responsiveIconSize * 1.2,
                  ),
                ),
                SizedBox(height: context.responsiveMargin),
                Expanded(
                  child: Text(
                    subcategory.name.tr(),
                    style: TextStyles.textViewMedium14.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.category,
            size: context.responsiveIconSize * 4,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            "no_subcategories_found".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            "try_different_category".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<SubcategoryData> _getSubcategoriesForCategory(String categoryName) {
    // Mock data - in real app, this would come from API
    return [
       
          SubcategoryData(
            name: "healthy",
            icon: Icons.eco,
            iconBackgroundColor: const Color(0xFFE8F5E8),
            iconColor: const Color(0xFF4CAF50),
          ),
          SubcategoryData(
            name: "savory",
            icon: Icons.fastfood,
            iconBackgroundColor: const Color(0xFFF3E5F5),
            iconColor: const Color(0xFF9C27B0),
          ),
          SubcategoryData(
            name: "sweet",
            icon: Icons.cake,
            iconBackgroundColor: const Color(0xFFFFF8E1),
            iconColor: const Color(0xFFFFB300),
          ),
          SubcategoryData(
            name: "popcorn",
            icon: Icons.local_movies,
            iconBackgroundColor: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFF44336),
          ),
          SubcategoryData(
            name: "frozen",
            icon: Icons.ac_unit,
            iconBackgroundColor: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF2196F3),
          ),
          SubcategoryData(
            name: "ice_cream",
            icon: Icons.icecream,
            iconBackgroundColor: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFE91E63),
          ),
          SubcategoryData(
            name: "creamy",
            icon: Icons.auto_awesome,
            iconBackgroundColor: const Color(0xFFFFF3E0),
            iconColor: const Color(0xFFFF9800),
          ),
          SubcategoryData(
            name: "chilled",
            icon: Icons.wb_sunny,
            iconBackgroundColor: const Color(0xFFFFFDE7),
            iconColor: const Color(0xFFFFC107),
          ),
        ];
 
    }
  

  void _onSubcategoryTap(BuildContext context, SubcategoryData subcategory) {
    NavigationManager.navigateTo(
      SubcategoryProductsScreen(
        subcategoryName: subcategory.name,
        categoryName: widget.categoryName,
      ),
    );
  }
}

class SubcategoryData {
  final String name;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const SubcategoryData({
    required this.name,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });
}
