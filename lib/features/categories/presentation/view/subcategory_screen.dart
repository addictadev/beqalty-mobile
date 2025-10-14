import 'package:baqalty/core/widgets/custom_appbar.dart' show CustomAppBar;
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart'
    show AuthBackgroundWidget;
import 'package:baqalty/features/categories/business/cubit/category_cubit.dart';
import 'package:baqalty/features/categories/data/models/categories_response_model.dart';
import 'package:baqalty/core/widgets/custom_error_widget.dart';
import 'package:baqalty/core/images_preview/custom_cashed_network_image.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/features/categories/presentation/widgets/debounced_search_field.dart';
import 'package:baqalty/features/categories/presentation/widgets/no_categories_widget.dart';
import 'package:baqalty/features/categories/presentation/view/categories_shimmer_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'subcategory_products_screen.dart';

class SubcategoryScreen extends StatelessWidget {
  final String categoryName;
  final String categoryId;

  const SubcategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..getSubcategories(categoryId),
      child: SubcategoryScreenBody(
        categoryName: categoryName,
        categoryId: categoryId,
      ),
    );
  }
}

class SubcategoryScreenBody extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const SubcategoryScreenBody({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<SubcategoryScreenBody> createState() => _SubcategoryScreenBodyState();
}

class _SubcategoryScreenBodyState extends State<SubcategoryScreenBody>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _itemAnimationControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create staggered animations for each subcategory item
    _itemAnimationControllers = List.generate(
      12, // Maximum number of subcategories
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _itemAnimations = _itemAnimationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
    }).toList();
  }

  void _startAnimations() {
    _animationController.forward();

    // Stagger the item animations
    for (int i = 0; i < _itemAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          _itemAnimationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
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
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is SubCategoryLoading) {
            return _buildLoadingState(context);
          }

          if (state is SubCategoryError) {
            return _buildErrorState(context, state.message);
          }

          if (state is SubCategoryLoaded) {
            return _buildLoadedState(context, state);
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
              child: DebouncedSearchField(
                hint: "search_subcategories".tr(),
                onSearch: (query) {},
                debounceDuration: const Duration(milliseconds: 300),
                showClearButton: false,
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
              child: DebouncedSearchField(
                hint: "search_subcategories".tr(),
                onSearch: (query) {},
                debounceDuration: const Duration(milliseconds: 300),
                showClearButton: false,
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

  Widget _buildLoadedState(BuildContext context, SubCategoryLoaded state) {
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
              child: DebouncedSearchField(
                hint: "search_subcategories".tr(),
                onSearch: (query) {
                  context.read<CategoryCubit>().searchSubcategories(query);
                },
                debounceDuration: const Duration(milliseconds: 300),
                showClearButton: true,
              ),
            ),
            SizedBox(height: context.responsiveMargin * 2),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<CategoryCubit>().getSubcategories(
                    widget.categoryId,
                  );
                },
                child: _buildSubcategoriesGrid(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoriesGrid(
    BuildContext context,
    SubCategoryLoaded state,
  ) {
    if (state.allSubcategories.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: NoCategoriesWidget(
          isSearchResult: state.searchQuery.isNotEmpty,
          onRetry: state.searchQuery.isEmpty
              ? () {
                  context.read<CategoryCubit>().getSubcategories(
                    widget.categoryId,
                  );
                }
              : null,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimations();
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(top: context.responsiveMargin * 2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: context.responsiveMargin,
                mainAxisSpacing: context.responsiveMargin,
                childAspectRatio: 0.9,
              ),
              itemCount: state.allSubcategories.length,
              itemBuilder: (context, index) {
                final subcategory = state.allSubcategories[index];
                final backgroundColor = _getRandomBackgroundColor(
                  subcategory.catId,
                );

                return AnimatedBuilder(
                  animation: index < _itemAnimations.length
                      ? _itemAnimations[index]
                      : _itemAnimations[0],
                  builder: (context, child) {
                    final animation = index < _itemAnimations.length
                        ? _itemAnimations[index]
                        : _itemAnimations[0];
                    return Transform.scale(
                      scale: animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - animation.value)),
                        child: Opacity(
                          opacity: animation.value.clamp(0.0, 1.0),
                          child: _buildSubcategoryCard(
                            context,
                            subcategory: subcategory,
                            backgroundColor: backgroundColor,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Load More Button
          if (state.hasMore)
            Padding(
              padding: EdgeInsets.all(context.responsivePadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CategoryCubit>().loadMoreSubcategories();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: context.responsivePadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.responsiveBorderRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    "load_more".tr(),
                    style: TextStyles.textViewMedium14.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubcategoryCard(
    BuildContext context, {
    required CategoryModel subcategory,
    required Color backgroundColor,
  }) {
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
            _onSubcategoryTap(context, subcategory);
          },
          child: Padding(
            padding: EdgeInsets.all(context.responsivePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.responsiveIconSize * 2,
                  height: context.responsiveIconSize * 2,
                  padding: EdgeInsets.all(context.responsivePadding / 2.5),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      context.responsiveBorderRadius,
                    ),
                    child: CustomCachedImage(
                      imageUrl: subcategory.displayImage,
                      width: context.responsiveIconSize * 2,
                      height: context.responsiveIconSize * 2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: context.responsiveMargin),
                Text(
                  subcategory.catName,
                  style: TextStyles.textViewMedium14.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRandomBackgroundColor(int categoryId) {
    final pastelColors = [
      const Color(0xFFFFE5E5),
      const Color(0xFFFFF8E1),
      const Color(0xFFE8F5E8),
      const Color(0xFFE3F2FD),
      const Color(0xFFFFF3E0),
      const Color(0xFFF3E5F5),
      const Color(0xFFE0F7FA),
      const Color(0xFFFCE4EC),
      const Color(0xFFF1F8E9),
      const Color(0xFFFFF9C4),
      const Color(0xFFE1BEE7),
      const Color(0xFFFFCCBC),
    ];

    final random = math.Random(categoryId);
    return pastelColors[random.nextInt(pastelColors.length)];
  }

  void _onSubcategoryTap(BuildContext context, CategoryModel subcategory) {
    NavigationManager.navigateTo(
      SubcategoryProductsScreen(
        subcategoryName: subcategory.catName,
        categoryName: widget.categoryName,
        subcategoryId: subcategory.catId.toString(),
      ),
    );
  }
}
