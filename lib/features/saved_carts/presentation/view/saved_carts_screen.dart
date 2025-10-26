import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/saved_carts/business/models/saved_cart_model.dart';
import 'package:baqalty/features/saved_carts/presentation/widgets/saved_cart_card.dart';
import 'package:baqalty/features/saved_carts/business/cubit/saved_carts_cubit.dart';
import 'package:baqalty/features/saved_carts/data/models/saved_carts_response_model.dart';
import 'package:baqalty/core/di/service_locator.dart';
import 'package:baqalty/features/saved_carts/data/services/saved_carts_service.dart';
import 'package:baqalty/features/saved_carts/presentation/view/saved_cart_details_screen.dart';
import 'package:baqalty/features/checkout/presentation/view/checkout_screen.dart';
import 'package:baqalty/features/checkout/business/cubit/checkout_cubit.dart';
import 'package:baqalty/features/checkout/data/services/checkout_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class SavedCartsScreen extends StatelessWidget {
  const SavedCartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedCartsCubit(ServiceLocator.get<SavedCartsService>()),
      child: const SavedCartsScreenBody(),
    );
  }
}

class SavedCartsScreenBody extends StatefulWidget {
  const SavedCartsScreenBody({super.key});

  @override
  State<SavedCartsScreenBody> createState() => _SavedCartsScreenBodyState();
}

class _SavedCartsScreenBodyState extends State<SavedCartsScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _cartNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load saved carts when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavedCartsCubit>().getAllSavedCarts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cartNameController.dispose();
    super.dispose();
  }

  void _onCartDetails(SavedCartModel savedCart) {
    NavigationManager.navigateTo(
      SavedCartDetailsScreen(
        cartId: int.parse(savedCart.id),
        cartName: savedCart.name,
      ),
    );
  }

  void _onOrderAgain(SavedCartModel savedCart) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("processing_order".tr()),
          backgroundColor: AppColors.primary,
        ),
      );

      // Navigate to checkout screen with the saved cart ID
      await NavigationManager.navigateTo(
        BlocProvider<CheckoutCubit>(
          create: (context) => CheckoutCubit(ServiceLocator.get<CheckoutService>()),
          child: CheckoutScreen(
            cartId: int.parse(savedCart.id),
          ),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error_processing_order".tr()),
          backgroundColor: AppColors.error,
        ),
      );
      debugPrint('Error in _onOrderAgain: $e');
    }
  }

  void _onSearchChanged(String query) {
    // Use the API to search for saved carts
    context.read<SavedCartsCubit>().getAllSavedCarts(
      search: query.isEmpty ? null : query,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedCartsCubit, SavedCartsState>(
      listener: (context, state) {
        if (state is DeleteSavedCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("cart_deleted_successfully".tr()),
              backgroundColor: AppColors.success,
            ),
          );
          // Refresh the list after successful deletion
          context.read<SavedCartsCubit>().getAllSavedCarts();
        } else if (state is DeleteSavedCartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("cart_deletion_failed".tr()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: AuthBackgroundWidget(
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
              child: BlocBuilder<SavedCartsCubit, SavedCartsState>(
                builder: (context, state) {
                  if (state is SavedCartsInitial || state is SavedCartsLoading) {
                    return _buildLoadingState();
                  } else if (state is SavedCartsLoaded) {
                    return _buildSavedCartsList(context, state.savedCarts, _searchController.text);
                  } else if (state is SavedCartsError) {
                    return _buildErrorState(state.message);
                  }
                  return _buildLoadingState();
                },
              ),
            ),

            // Create New Cart Button
            // _buildCreateNewCartButton(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      child: Row(
        children: [
          Container(
            width: context.responsiveIconSize * 1.5,
            height: context.responsiveIconSize * 1.5,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                NavigationManager.pop();
              },
              icon: Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: context.responsiveIconSize,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
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
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
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

  Widget _buildSavedCartsList(BuildContext context, List<SavedCartDataModel> savedCarts, String searchQuery) {
    if (savedCarts.isEmpty) {
      return _buildEmptyState(context, searchQuery);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: savedCarts.length,
      itemBuilder: (context, index) {
        final savedCart = savedCarts[index];
        final savedCartModel = _convertToSavedCartModel(savedCart);
        return SavedCartCard(
          savedCart: savedCartModel,
          onCartDetails: () => _onCartDetails(savedCartModel),
          onOrderAgain: () => _onOrderAgain(savedCartModel),
          onDelete: () => _showDeleteConfirmationDialog(context, savedCart.id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery) {
    final bool isSearching = searchQuery.isNotEmpty;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Iconsax.search_normal_1 : Iconsax.shopping_bag,
            size: context.responsiveIconSize * 4,
            color: AppColors.textSecondary,
          ),

          SizedBox(height: context.responsiveMargin * 2),

          Text(
            isSearching ? "no_search_results".tr() : "no_saved_carts_found".tr(),
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: context.responsiveMargin),

          Text(
            isSearching ? "try_different_search".tr() : "start_shopping_message".tr(),
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  SavedCartModel _convertToSavedCartModel(SavedCartDataModel data) {
    return SavedCartModel(
      id: data.id.toString(),
      name: data.name,
      itemCount: data.items.length,
      lastModified: DateTime.parse(data.updatedAt),
      totalAmount: data.cartTotal.toDouble(),
      items: data.items.map((item) => SavedCartItemModel(
        id: item.id.toString(),
        name: item.productName,
        image: item.productImage,
        quantity: item.quantity,
        price: item.price,
      )).toList(),
    );
  }

  Widget _buildCreateNewCartButton(BuildContext context) {
    return BlocListener<SavedCartsCubit, SavedCartsState>(
      listener: (context, state) {
        if (state is CreateSavedCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("cart_created_successfully".tr()),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
          // Refresh the saved carts list
          context.read<SavedCartsCubit>().getAllSavedCarts();
        } else if (state is CreateSavedCartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("cart_creation_failed".tr()),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        height: 6.5.h,
        child: ElevatedButton.icon(
          onPressed: () => _showCreateCartDialog(context),
          icon: const Icon(Icons.add),
          label: Text("create_new_cart".tr(), style: TextStyles.textViewMedium16.copyWith(color: AppColors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            
            padding: EdgeInsets.symmetric(
              vertical: context.responsiveMargin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20.w,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateCartDialog(BuildContext context) {
    _cartNameController.clear();
    final savedCartsCubit = context.read<SavedCartsCubit>();
    
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: savedCartsCubit,
          child: BlocBuilder<SavedCartsCubit, SavedCartsState>(
            builder: (context, state) {
              final isLoading = state is CreateSavedCartLoading;
              
              return AlertDialog(
                title: Text("create_new_cart".tr()),
                contentPadding:  EdgeInsets.all(4.w),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 10.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      TextField(
                        controller: _cartNameController,
                        decoration: InputDecoration(
                          labelText: "cart_name".tr(),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(),
                    child: Text("cancel".tr()),
                  ),
                  ElevatedButton(
                    
                    onPressed: isLoading ? null : () {
                      final name = _cartNameController.text.trim();
                      if (name.isNotEmpty) {
                        savedCartsCubit.createSavedCart(name: name);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text("save".tr()),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int cartId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("delete_cart".tr()),
          content: Text("delete_cart_confirmation".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text("cancel".tr()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<SavedCartsCubit>().deleteSavedCart(cartId: cartId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              child: Text("delete".tr()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: context.responsiveIconSize * 4,
            color: AppColors.error,
          ),
          SizedBox(height: context.responsiveMargin * 2),
          Text(
            message,
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.responsiveMargin),
          ElevatedButton(
            onPressed: () {
              context.read<SavedCartsCubit>().getAllSavedCarts();
            },
            child: Text("retry".tr()),
          ),
        ],
      ),
    );
  }
}
