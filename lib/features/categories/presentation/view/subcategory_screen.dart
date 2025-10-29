import 'package:baqalty/core/widgets/custom_appbar.dart' show CustomAppBar;
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart'
    show AuthBackgroundWidget;
import 'package:baqalty/features/categories/business/cubit/category_cubit.dart';
import 'package:baqalty/features/categories/business/cubit/subcategory_products_cubit.dart';
import 'package:baqalty/core/widgets/custom_error_widget.dart';
import 'package:baqalty/features/categories/presentation/widgets/category_grid_view.dart';
import 'package:baqalty/features/search/presentation/widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/features/categories/presentation/view/categories_shimmer_view.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:iconsax/iconsax.dart';

class SubcategoryScreen extends StatelessWidget {
  final String categoryName;
  final String categoryId;
  final String? sharedCartId;

  const SubcategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    this.sharedCartId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryCubit()..getSubcategories(categoryId),
        ),
        BlocProvider(
          create: (context) => SubcategoryProductsCubit(),
        ),
      ],
      child: SubcategoryScreenBody(
        categoryName: categoryName,
        categoryId: categoryId,
        sharedCartId: sharedCartId,
      ),
    );
  }
}

class SubcategoryScreenBody extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  final String? sharedCartId;

  const SubcategoryScreenBody({
    super.key,
    required this.categoryName,
    required this.categoryId,
    this.sharedCartId,
  });

  @override
  State<SubcategoryScreenBody> createState() => _SubcategoryScreenBodyState();
}

class _SubcategoryScreenBodyState extends State<SubcategoryScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSubcategoryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSubcategorySelected(String subcategoryId) {
    setState(() {
      _selectedSubcategoryId = subcategoryId;
    });

    // Load products for selected subcategory
    context.read<SubcategoryProductsCubit>().loadSubcategoryProducts(subcategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, categoryState) {
          if (categoryState is SubCategoryLoading) {
            return _buildLoadingState(context);
          }

          if (categoryState is SubCategoryError) {
            return _buildErrorState(context, categoryState.message);
          }

          if (categoryState is SubCategoryLoaded) {
            // Show empty state if no subcategories
            if (categoryState.allSubcategories.isEmpty) {
              return _buildEmptySubcategoriesState(context);
            }

            // Auto-select first subcategory on initial load
            if (_selectedSubcategoryId == null && categoryState.allSubcategories.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _onSubcategorySelected(
                  categoryState.allSubcategories.first.catId.toString(),
                );
              });
            }

            return _buildLoadedState(context, categoryState);
          }

          return _buildLoadingState(context);
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return AuthBackgroundWidget(
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: widget.categoryName),
            SizedBox(height: context.responsiveMargin),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              child: CustomTextFormField(
                controller: _searchController,
                hint: "search_products".tr(),
                prefixIcon: Icon(Iconsax.search_normal_1),
              ),
            ),
            SizedBox(height: context.responsiveMargin * 2),
            const Expanded(child: CategoriesShimmerView()),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return AuthBackgroundWidget(
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: widget.categoryName),
            SizedBox(height: context.responsiveMargin),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              child: CustomTextFormField(
                controller: _searchController,
                hint: "search_products".tr(),
                prefixIcon: Icon(Iconsax.search_normal_1),
              ),
            ),
            SizedBox(height: context.responsiveMargin * 2),
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomErrorWidget(
                      message: message,
                      onRetry: () {
                        context.read<CategoryCubit>().getSubcategories(
                          widget.categoryId,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, SubCategoryLoaded categoryState) {
    return AuthBackgroundWidget(
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: widget.categoryName),
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
                  Iconsax.search_normal_1,
                  color: AppColors.textSecondary,
                ),
                onChanged: (value) {
                  context.read<SubcategoryProductsCubit>().searchProducts(value);
                },
              ),
            ),
            
            SizedBox(height: context.responsiveMargin),
            
            // Subcategory Filter Tabs
            if (categoryState.allSubcategories.isNotEmpty)
              _buildSubcategoryTabs(context, categoryState),
            
            SizedBox(height: context.responsiveMargin),
            
            // Products Grid
            Expanded(
              child: BlocBuilder<SubcategoryProductsCubit, SubcategoryProductsState>(
                builder: (context, productsState) {
                  if (productsState is SubcategoryProductsLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: context.responsiveMargin),
                          Text(
                            "loading_products".tr(),
                            style: TextStyles.textViewMedium14.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (productsState is SubcategoryProductsError) {
                    return Center(
                      child: CustomErrorWidget(
                        message: productsState.message,
                        onRetry: () {
                          if (_selectedSubcategoryId != null) {
                            context.read<SubcategoryProductsCubit>().loadSubcategoryProducts(_selectedSubcategoryId!);
                          }
                        },
                      ),
                    );
                  } else if (productsState is SubcategoryProductsLoaded) {
                    if (productsState.products.isEmpty) {
                      return BuildEmptyState(
                        context,
                        isSearchResult: productsState.searchQuery.isNotEmpty,
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        if (_selectedSubcategoryId != null) {
                          await context.read<SubcategoryProductsCubit>().refreshProducts();
                        }
                      },
                      child: CategoryGridView(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        mainAxisSpacing: 2.w,
                        products: productsState.products,
                        onLoadMore: productsState.hasMoreProducts
                            ? () {
                                context.read<SubcategoryProductsCubit>().loadMoreProducts();
                              }
                            : null,
                        isLoadingMore: false,
                        sharedCartId: widget.sharedCartId,
                        showHeader: false,
                      ),
                    );
                  }
                  // Show empty state if no subcategory selected yet
                  if (_selectedSubcategoryId == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.category,
                            size: 20.w,
                            color: AppColors.textSecondary.withOpacity(0.5),
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
                            "categories_will_appear_here".tr(),
                            style: TextStyles.textViewRegular14.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySubcategoriesState(BuildContext context) {
    return AuthBackgroundWidget(
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: widget.categoryName),
            SizedBox(height: context.responsiveMargin),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsivePadding,
              ),
              child: CustomTextFormField(
                controller: _searchController,
                hint: "search_products".tr(),
                prefixIcon: Icon(Iconsax.search_normal_1),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.responsivePadding * 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.category,
                        size: 20.w,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      SizedBox(height: context.responsiveMargin * 2),
                      Text(
                        "no_subcategories_found".tr().isEmpty 
                            ? "لا توجد أقسام فرعية" 
                            : "no_subcategories_found".tr(),
                        style: TextStyles.textViewBold18.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.responsiveMargin),
                      Text(
                        "categories_will_appear_here".tr(),
                        style: TextStyles.textViewRegular14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryTabs(BuildContext context, SubCategoryLoaded state) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
        itemCount: state.allSubcategories.length,
        itemBuilder: (context, index) {
          final subcategory = state.allSubcategories[index];
          final isSelected = _selectedSubcategoryId == subcategory.catId.toString();
          
          return _buildTabButton(
            context: context,
            label: subcategory.catName,
            isSelected: isSelected,
            onTap: () => _onSubcategorySelected(
              subcategory.catId.toString(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: context.responsiveMargin),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsivePadding * 1.5,
              vertical: context.responsivePadding * 0.8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.grey.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyles.textViewMedium14.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
