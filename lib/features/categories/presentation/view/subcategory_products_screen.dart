import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:baqalty/features/product_details/presentation/view/product_details_screen.dart'
    show ProductDetailsScreen;
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/saved_item_card.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../business/cubit/subcategory_products_cubit.dart';

class SubcategoryProductsScreen extends StatefulWidget {
  final String subcategoryName;
  final String categoryName;
  final String subcategoryId;

  const SubcategoryProductsScreen({
    super.key,
    required this.subcategoryName,
    required this.categoryName,
    required this.subcategoryId,
  });

  @override
  State<SubcategoryProductsScreen> createState() =>
      _SubcategoryProductsScreenState();
}

class SubcategoryProductsScreenBody extends StatefulWidget {
  final String subcategoryName;
  final String categoryName;
  final String subcategoryId;

  const SubcategoryProductsScreenBody({
    super.key,
    required this.subcategoryName,
    required this.categoryName,
    required this.subcategoryId,
  });

  @override
  State<SubcategoryProductsScreenBody> createState() =>
      _SubcategoryProductsScreenBodyState();
}

class _SubcategoryProductsScreenState extends State<SubcategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubcategoryProductsCubit()
        ..loadSubcategoryProducts(widget.subcategoryId),
      child: SubcategoryProductsScreenBody(
        subcategoryName: widget.subcategoryName,
        categoryName: widget.categoryName,
        subcategoryId: widget.subcategoryId,
      ),
    );
  }
}

class _SubcategoryProductsScreenBodyState extends State<SubcategoryProductsScreenBody>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late List<AnimationController> _itemAnimationControllers;
  late List<Animation<double>> _itemAnimations;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _itemAnimationControllers = List.generate(
      20, // Increased for more products
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _itemAnimations = _itemAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    }).toList();

    _startAnimations();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more products when near bottom
        context.read<SubcategoryProductsCubit>().loadMoreProducts();
      }
    });
  }

  void _startAnimations() {
    _animationController.forward();

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
    _scrollController.dispose();
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
                title: widget.subcategoryName,
                onBackPressed: () {
                  NavigationManager.pop();
                },
              ),
              SizedBox(height: context.responsiveMargin),

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
                    context.read<SubcategoryProductsCubit>().searchProducts(value);
                  },
                ),
              ),

              Expanded(child: _buildProductsList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return BlocBuilder<SubcategoryProductsCubit, SubcategoryProductsState>(
      builder: (context, state) {
        if (state is SubcategoryProductsLoading) {
          return _buildLoadingState(context);
        } else if (state is SubcategoryProductsError) {
          return _buildErrorState(context, state.message);
        } else if (state is SubcategoryProductsLoaded) {
          if (state.products.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildProductsListView(context, state);
        }
        return _buildLoadingState(context);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: context.responsiveMargin),
          Text(
            "loading_products".tr(),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: CustomErrorWidget(
        message: message,
        onRetry: () {
          context.read<SubcategoryProductsCubit>().refreshProducts();
        },
      ),
    );
  }

  Widget _buildProductsListView(BuildContext context, SubcategoryProductsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<SubcategoryProductsCubit>().refreshProducts();
      },
      child: Padding(
        padding: EdgeInsets.all(context.responsivePadding),
        child: ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: state.products.length + (state.hasMoreProducts ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.products.length) {
              // Loading indicator for pagination
              return Padding(
                padding: EdgeInsets.all(context.responsiveMargin),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            final product = state.products[index];
            final animationIndex = index % _itemAnimations.length;
            
            return AnimatedBuilder(
              animation: _itemAnimations[animationIndex],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - _itemAnimations[animationIndex].value)),
                  child: Opacity(
                    opacity: _itemAnimations[animationIndex].value.clamp(0.0, 1.0),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: context.responsiveMargin),
                      child: SavedItemCard(
                        productName: product.name,
                        productCategory: widget.subcategoryName,
                        productPrice: product.finalPriceDouble,
                        productImage: product.baseImage,
                        showFavoriteButton: false,
                        showAddToCartButton: false,
                        onTap: () {
                          if (animationIndex < _itemAnimationControllers.length) {
                            _itemAnimationControllers[animationIndex].reverse().then((_) {
                              _itemAnimationControllers[animationIndex].forward();
                            });
                          }

                          NavigationManager.navigateTo(
                            ProductDetailsScreen(
                              productName: product.name,
                              productImage: product.baseImage,
                              productPrice: product.finalPriceDouble,
                              productCategory: widget.subcategoryName,
                            ),
                          );
                        },
                        onFavorite: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} added to favorites',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
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
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
