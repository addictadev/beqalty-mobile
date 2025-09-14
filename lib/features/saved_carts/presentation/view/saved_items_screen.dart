import 'package:baqalty/core/images_preview/app_assets.dart' show AppAssets;
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart' show ProductDetailsScreen;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/saved_carts/business/models/saved_item_model.dart';
import 'package:baqalty/core/widgets/saved_item_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SavedItemModel> _savedItems = [];
  List<SavedItemModel> _filteredItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSavedItems() {
    // Simulate loading saved items
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _savedItems = _getMockSavedItems();
        _filteredItems = _savedItems;
        _isLoading = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _savedItems;
      } else {
        _filteredItems = _savedItems.where((item) {
          return item.name.toLowerCase().contains(query.toLowerCase()) ||
                 item.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onItemTap(SavedItemModel savedItem) {
     NavigationManager.navigateTo(ProductDetailsScreen(
                productName: savedItem.name,
                productImage: savedItem.image,
                productPrice: savedItem.price,
                productCategory: savedItem.category,
              ));  
    
  }

  void _onRemoveFromSaved(SavedItemModel savedItem) {
    setState(() {
      _savedItems.remove(savedItem);
      _filteredItems.remove(savedItem);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${savedItem.name} removed from saved items'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _savedItems.add(savedItem);
              _filteredItems.add(savedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child:
            // Background Pattern
       
            
            // Main Content
            Column(
              children: [
                // App Bar
                CustomAppBar(
                  title: "saved_items".tr(),
                
                ),
                
                // Search Bar
                _buildSearchBar(context),
                
                // Saved Items List
                Expanded(
                  child: _isLoading
                      ? _buildLoadingState()
                      : _buildSavedItemsList(context),
                ),
              ],
            
          
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      child: CustomTextFormField(
        controller: _searchController,
        hint: "search_saved_items".tr(),
        prefixIcon: Icon(
          Iconsax.search_normal_1,
          color: AppColors.textSecondary,
          size: context.responsiveIconSize,
        ),
        onChanged: _onSearchChanged,
        borderRadius: 25,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        fillColor: AppColors.white,
        borderColor: AppColors.borderLight,
        focusedBorderColor: AppColors.primary,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            "Loading saved items...",
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedItemsList(BuildContext context) {
    if (_filteredItems.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final savedItem = _filteredItems[index];
        return SavedItemCard(
          productName: savedItem.name,
          productCategory: savedItem.category,
          productPrice: savedItem.price,
          productImage: savedItem.image,
          showFavoriteButton: true,
          showAddToCartButton: false,
          isFavorite: true,
          onTap: () => _onItemTap(savedItem),
          onFavorite: () => _onRemoveFromSaved(savedItem),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.heart,
            size: context.responsiveIconSize * 4,
            color: AppColors.textSecondary,
          ),
          
          SizedBox(height: context.responsiveMargin * 2),
          
          Text(
            "No saved items found",
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: context.responsiveMargin),
          
          Text(
            "Start shopping and save your favorite items",
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<SavedItemModel> _getMockSavedItems() {
    return [
      SavedItemModel(
        id: '1',
        name: 'Juhayna Milk',
        category: 'Milk Category',
        image: 'assets/images/juhayna_milk.png',
        price: 25.50,
        savedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      SavedItemModel(
        id: '2',
        name: 'Juhayna Coconut Milk',
        category: 'Milk Category',
        image: 'assets/images/juhayna_coconut_milk.png',
        price: 75.00,
        savedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      SavedItemModel(
        id: '3',
        name: 'Juhayna Cream Milk',
        category: 'Milk Category',
        image: AppAssets.alMaraiMilk,
        price: 64.25,
        savedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      SavedItemModel(
        id: '4',
        name: 'Chocolate Milk',
        category: 'Milk Category',
        image: 'assets/images/chocolate_milk.png',
        price: 48.00,
        savedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      SavedItemModel(
        id: '5',
        name: 'Al Marai Milk',
        category: 'Milk Category',
        image: 'assets/images/al_marai_milk.png',
        price: 48.75,
        savedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }
}

// Custom painter for background pattern
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.borderLight.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw subtle grid pattern
    final spacing = 40.0;
    
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
