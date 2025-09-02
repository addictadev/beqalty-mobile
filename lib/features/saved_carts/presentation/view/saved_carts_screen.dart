import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_back_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/saved_carts/business/models/saved_cart_model.dart';
import 'package:baqalty/features/saved_carts/presentation/widgets/saved_cart_card.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';

class SavedCartsScreen extends StatefulWidget {
  const SavedCartsScreen({super.key});

  @override
  State<SavedCartsScreen> createState() => _SavedCartsScreenState();
}

class _SavedCartsScreenState extends State<SavedCartsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SavedCartModel> _savedCarts = [];
  List<SavedCartModel> _filteredCarts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCarts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadSavedCarts() {
    // Simulate loading saved carts
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _savedCarts = _getMockSavedCarts();
        _filteredCarts = _savedCarts;
        _isLoading = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCarts = _savedCarts;
      } else {
        _filteredCarts = _savedCarts.where((cart) {
          return cart.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onCartDetails(SavedCartModel savedCart) {
    // TODO: Implement cart details view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${savedCart.name}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _onOrderAgain(SavedCartModel savedCart) {
    // TODO: Implement reorder functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reordering from ${savedCart.name}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundWidget(
      backgroundHeight: MediaQuery.of(context).size.height * 0.25,
      overlayOpacity: 0.3,
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(context),
            
            // Search Bar
            _buildSearchBar(context),
            
            // Saved Carts List
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _buildSavedCartsList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      child: Row(
        children: [
          CustomBackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          
          Expanded(
            child: Center(
              child: Text(
                "saved_carts".tr(),
                style: TextStyles.textViewBold18.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          
          // Placeholder for balance
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: CustomTextFormField(
        controller: _searchController,
        hint: "search_saved_carts".tr(),
        prefixIcon: Icon(Iconsax.search_normal_1),
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
            "loading_saved_carts".tr(),
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCartsList(BuildContext context) {
    if (_filteredCarts.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredCarts.length,
      itemBuilder: (context, index) {
        final savedCart = _filteredCarts[index];
        return SavedCartCard(
          savedCart: savedCart,
          onCartDetails: () => _onCartDetails(savedCart),
          onOrderAgain: () => _onOrderAgain(savedCart),
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
            Iconsax.shopping_bag,
            size: context.responsiveIconSize * 4,
            color: AppColors.textSecondary,
          ),
          
          SizedBox(height: context.responsiveMargin * 2),
          
          Text(
            "no_saved_carts_found".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: context.responsiveMargin),
          
          Text(
            "start_shopping_message".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<SavedCartModel> _getMockSavedCarts() {
    return [
      SavedCartModel(
        id: '1',
        name: 'Breakfast Cart',
        itemCount: 12,
        lastModified: DateTime.now().subtract(const Duration(hours: 2)),
        totalAmount: 89.50,
        items: [],
      ),
      SavedCartModel(
        id: '2',
        name: 'Snacks Cart',
        itemCount: 10,
        lastModified: DateTime.now().subtract(const Duration(days: 1)),
        totalAmount: 67.25,
        items: [],
      ),
      SavedCartModel(
        id: '3',
        name: 'Snacks Cart',
        itemCount: 10,
        lastModified: DateTime.now().subtract(const Duration(days: 2)),
        totalAmount: 45.80,
        items: [],
      ),
      SavedCartModel(
        id: '4',
        name: 'Dinner Cart',
        itemCount: 15,
        lastModified: DateTime.now().subtract(const Duration(days: 3)),
        totalAmount: 120.15,
        items: [],
      ),
    ];
  }
}
