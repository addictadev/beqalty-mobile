import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_asset_img.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/widgets/category_product_card.dart';
import 'package:baqalty/core/widgets/custom_appbar.dart' show CustomAppBar;
import 'package:baqalty/features/categories/presentation/widgets/category_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:baqalty/core/di/service_locator.dart';
import '../../business/cubit/product_details_cubit.dart';
import '../../data/models/product_details_response_model.dart';
import '../../data/services/product_details_service.dart';
import '../../../cart/business/cubit/cart_cubit.dart';
import '../../../cart/data/services/cart_service.dart';
import '../../../saved_carts/data/services/saved_carts_service.dart';
import '../../../saved_carts/data/models/saved_carts_response_model.dart';
import '../../../saved_carts/data/models/saved_cart_item_action_request_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  final String? sharedCartId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    this.sharedCartId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  String? selectedSize;
  String? selectedFlavor;
  int currentImageIndex = 0;
  
  // Saved carts state
  List<SavedCartDataModel> savedCarts = [];
  bool isLoadingSavedCarts = false;
  int? selectedSavedCartId;

  @override
  void initState() {
    super.initState();
    // Fetch saved carts when screen loads
    _fetchSavedCarts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh saved carts when returning to screen
    _fetchSavedCarts();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(ServiceLocator.get<CartService>()),
        ),
      ],
      child: BlocConsumer<CartCubit, CartState>(
          listener: (context, cartState) {
            if (cartState is CartItemAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(cartState.cartItem.message),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (cartState is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(cartState.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, cartState) {
            // We don't need to rebuild UI based on cart state, just listen for changes
            return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
              listener: (context, state) {
                if (state is ProductDetailsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                      action: SnackBarAction(
                        label: 'Retry',
                        textColor: AppColors.white,
                        onPressed: () {
                          context.read<ProductDetailsCubit>().getProductDetails(widget.productId);
                        },
                      ),
                    ),
                  );
                } else if (state is ProductLiked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('product_liked_successfully'.tr()),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (state is ProductUnliked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('product_unliked_successfully'.tr()),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProductDetailsLoaded) {
                } else if (state is ProductLiked) {
                } else if (state is ProductUnliked) {
                }
                
                // Trigger API call when state is initial
                if (state is ProductDetailsInitial) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<ProductDetailsCubit>().getProductDetails(widget.productId);
                  });
                  return _buildLoadingState();
                }
                
                if (state is ProductDetailsLoading) {
                  return _buildLoadingState();
                } else if (state is ProductDetailsLoaded) {
                  return _buildLoadedState(state.productDetails);
                } else if (state is ProductLiked) {
                  return _buildLoadedState(state.productDetails);
                } else if (state is ProductUnliked) {
                  return _buildLoadedState(state.productDetails);
                } else if (state is ProductDetailsError) {
                  return _buildErrorState(state.message);
                }
                return _buildLoadingState();
              },
            );
          },
        ),
      );
    
  }

  Widget _buildLoadingState() {
    return AuthBackgroundWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("product_details".tr()),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return AuthBackgroundWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("product_details".tr()),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<ProductDetailsCubit>().getProductDetails(widget.productId);
                },
                child: Text("retry".tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(ProductDetailsDataModel productDetails) {
    // Initialize selections if not set
    if (selectedSize == null && productDetails.attributes.isNotEmpty) {
      final sizeAttribute = productDetails.attributes.firstWhere(
        (attr) => attr.attributeName.toLowerCase().contains('size') ||
                   attr.attributeName.toLowerCase().contains('حجم'),
        orElse: () => productDetails.attributes.first,
      );
      if (sizeAttribute.products.isNotEmpty) {
        selectedSize = sizeAttribute.products.first.name;
      }
    }

    if (selectedFlavor == null && productDetails.attributes.length > 1) {
      final flavorAttribute = productDetails.attributes.firstWhere(
        (attr) => attr.attributeName.toLowerCase().contains('flavor') ||
                   attr.attributeName.toLowerCase().contains('نكهة'),
        orElse: () => productDetails.attributes.length > 1 ? productDetails.attributes[1] : productDetails.attributes.first,
      );
      if (flavorAttribute.products.isNotEmpty) {
        selectedFlavor = flavorAttribute.products.first.name;
      }
    }

    return AuthBackgroundWidget(
      child: Column(
        children: [
          CustomAppBar(
            title: "product_details".tr(), 
            onBackPressed: () => Navigator.of(context).pop(),
            actions: [
           if(widget.sharedCartId == null)   IconButton(
                onPressed: () => _showSavedCartDialog(context),
                icon: CustomSvgImage(
                  assetName: AppAssets.unSavedIcon,
                  width: context.responsiveIconSize * 2,
                  height: context.responsiveIconSize * 2,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProductImage(context, productDetails),
                  _buildProductInfo(context, productDetails),
                  _buildBottomSection(context, productDetails),
                  _buildMoreLikeThisSection(context, productDetails.relatedProducts),
                ],
              ),
            ),
          ),
          _buildActionButtons(context, productDetails),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, ProductDetailsDataModel productDetails) {
    return Container(
      width: context.responsiveWidth,
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
      ),
      child: Stack(
        children: [
          // Product Images Slider
          GestureDetector(
            onTap: () => _openImageGallery(context, productDetails.images, currentImageIndex),
            child: SizedBox(
              height: 30.h,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
                itemCount: productDetails.images.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: productDetails.images[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
          // Favorite Button positioned at top right
       
       if(widget.sharedCartId == null) 
          Positioned(
            top: context.responsiveMargin,
            right: context.responsivePadding,
            child: GestureDetector(
              onTap: () {
                context.read<ProductDetailsCubit>().toggleFavorite(productDetails);
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppColors.homeGradientWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  productDetails.isLiked ? Iconsax.heart5 : Iconsax.heart,
                  color: productDetails.isLiked ? AppColors.error : AppColors.grey,
                  size: 6.w,
                ),
              ),
            ),
          ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: _buildPaginationDots(context, productDetails.images)),
       
        ],
      ),
    );
  }

  Widget _buildPaginationDots(BuildContext context, List<String> images) {
    if (images.length <= 1) return const SizedBox.shrink();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        images.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: .5.w),
          width: index == currentImageIndex ? 5.w : 1.5.w,
          height: 1.5.w,
          decoration: BoxDecoration(
            color: index == currentImageIndex ? AppColors.primary : AppColors.grey.withOpacity(.4),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30.w),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, ProductDetailsDataModel productDetails) {
    // Check if there's a discount
    final double basePrice = _extractPrice(productDetails.basePrice);
    final double finalPrice = _extractPrice(productDetails.finalPrice);
    final bool hasDiscount = basePrice > finalPrice;
    
    return Container(
      width: context.responsiveWidth,
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
   
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productDetails.name,
            style: TextStyles.textViewBold18,
          ),
          if (productDetails.description.isNotEmpty) ...[
            SizedBox(height: context.responsiveMargin),
            Text(
              productDetails.description,
              style: TextStyles.textViewRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          // SizedBox(height: context.responsiveMargin),
          // Price display
          // _buildPriceDisplay(context, productDetails, hasDiscount),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, ProductDetailsDataModel productDetails) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuantitySelector(context),
          ...productDetails.attributes.map((attribute) => Column(
            children: [
              SizedBox(height:2.h),
              _buildAttributeOptions(context, attribute),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("quantity".tr(), style: TextStyles.textViewMedium16),
 
 SizedBox(height: 2.h),
   Row(children: [     GestureDetector(
          onTap: () {
            if (quantity > 1) {
              setState(() {
                quantity--;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(2.2.w),
            ),
            child: Icon(Icons.remove, color: AppColors.primary,size: 5.w,),
          ),
        ),
        SizedBox(width: 3.w),
        Text(quantity.toString(), style: TextStyles.textViewBold20),
        SizedBox(width: 3.w),
        GestureDetector(
          onTap: () {
            setState(() {
              quantity++;
            });
          },
          child: Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2.2.w),
            ),
            child: Icon(Icons.add, color: AppColors.white,size: 5.w,),
          ),
        ),
      ],)
      
      ],
    );
  }

  Widget _buildAttributeOptions(BuildContext context, ProductAttributeModel attribute) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          attribute.attributeName,
          style: TextStyles.textViewMedium16,
        ),
        SizedBox(height: 2.h),
        Wrap(
          
          spacing: context.responsiveMargin,
          children: attribute.products.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            return GestureDetector(
              onTap: () {
               
               if(!attribute.products[index].selected){
                Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider<ProductDetailsCubit>(
                              create: (context) => ProductDetailsCubit(
                                ServiceLocator.get<ProductDetailsService>(),
                              ),
                            ),
                            BlocProvider<CartCubit>(
                              create: (context) => CartCubit(ServiceLocator.get<CartService>()),
                            ),
                          ],
                          child: ProductDetailsScreen(productId: product.productId),
                        ),
                      ),
                    );
               }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.w,
                ),
                decoration: BoxDecoration(
                  color: product.selected ? AppColors.primary : AppColors.white,
                 
                 border: Border.all(color:
                  AppColors.primary),
                  borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
                ),
                child: Text(
                  '${product.name} \n${product.finalPrice}${'egp'.tr()}',
                  textAlign: TextAlign.center,
                  style: TextStyles.textViewMedium14.copyWith(
                    
                    color: product.selected ? AppColors.white : AppColors.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ProductDetailsDataModel productDetails) {
    // Calculate total price based on quantity
    final double unitPrice = _extractPrice(productDetails.finalPrice);
    final double totalPrice = unitPrice * quantity;
    
    return Container(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.w, bottom: 6.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.responsiveBorderRadius * 2)),
      ),
      child: Row(
        children: [
          _buildTotalPriceDisplay(context, productDetails, totalPrice),
          const Spacer(),
          SizedBox(
            width: 45.w,
            height: 7.h,
            child: BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                return PrimaryButton(
                  isLoading: cartState is CartLoading,
                  borderRadius: 20.w,
                  width: 40.w,
                  text: "add_to_cart".tr(),
                  onPressed: () {
                    // Handle place order with quantity
                    _handlePlaceOrder(context.read<CartCubit>(), productDetails, quantity, totalPrice);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Opens full-screen image gallery
  void _openImageGallery(BuildContext context, List<String> images, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageGalleryScreen(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  /// Extracts numeric price from price string (handles currency symbols and spaces)
  double _extractPrice(String priceString) {
    // Remove common currency symbols and extract numbers
    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    return double.tryParse(cleanPrice.replaceAll(',', '.')) ?? 0.0;
  }

  /// Builds price display widget with discount handling
  Widget _buildPriceDisplay(BuildContext context, ProductDetailsDataModel productDetails, bool hasDiscount) {
    if (hasDiscount) {
      // Show both original price (crossed out) and final price
      return Row(
        children: [
          // Original price (crossed out)
          Text(
            '${productDetails.basePrice} ${"egp".tr()}',
            style: TextStyles.textViewMedium16.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          SizedBox(width: 2.w),
          // Final price (highlighted)
          Text(
            '${productDetails.finalPrice} ${"egp".tr()}',
            style: TextStyles.textViewBold18.copyWith(
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 2.w),
          // Discount badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
            ),
            child: Text(
              '-${productDetails.dicount} ${"egp".tr()}',
              style: TextStyles.textViewMedium12.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    } else {
      // Show only final price
      return Text(
        '${productDetails.finalPrice} ${"egp".tr()}',
        style: TextStyles.textViewBold18.copyWith(
          color: AppColors.textPrimary,
        ),
      );
    }
  }

  /// Builds total price display for action buttons section
  Widget _buildTotalPriceDisplay(BuildContext context, ProductDetailsDataModel productDetails, double totalPrice) {
    // Check if there's a discount
    final double basePrice = _extractPrice(productDetails.basePrice);
    final double finalPrice = _extractPrice(productDetails.finalPrice);
    final bool hasDiscount = basePrice > finalPrice;
    
    if (hasDiscount) {
      // Calculate total original price and total final price
      final double totalOriginalPrice = basePrice * quantity;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original total price (crossed out)
          Text(
            '${totalOriginalPrice.toStringAsFixed(2)} ${"egp".tr()}',
            style: TextStyles.textViewMedium14.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          SizedBox(height: 0.2.h),
          // Final total price (highlighted)
          Text(
            '${totalPrice.toStringAsFixed(2)} ${"egp".tr()}',
            style: TextStyles.textViewBold18.copyWith(
              color: Colors.green,
            ),
          ),
        ],
      );
    } else {
      // Show only final total price
      return Text(
        '${totalPrice.toStringAsFixed(2)} ${"egp".tr()}',
        style: TextStyles.textViewBold18.copyWith(
          color: Colors.green,
        ),
      );
    }
  }

  void _handlePlaceOrder(CartCubit cartCubit, ProductDetailsDataModel productDetails, int quantity, double totalPrice) {
    // Add item to cart using the CartCubit
    cartCubit.addToCart(
      productId: productDetails.id,
      quantity: quantity,
      warehouseId: 1, // Default warehouse ID - you might want to get this from user location or settings
      sharedCartId: widget.sharedCartId != null ? int.tryParse(widget.sharedCartId!) : null,
    );
  }

  Widget _buildMoreLikeThisSection(BuildContext context, List<RelatedProductModel> relatedProducts) {
    if (relatedProducts.isEmpty) return const SizedBox.shrink();
    
    return Container(
      width: context.responsiveWidth,
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "more_like_this".tr(),
            style: TextStyles.textViewBold16.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                return CategoryProductCard(product: relatedProducts[index], categoryName: "");
                
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context).pushReplacement(
                //       MaterialPageRoute(
                //         builder: (context) => MultiBlocProvider(
                //           providers: [
                //             BlocProvider<ProductDetailsCubit>(
                //               create: (context) => ProductDetailsCubit(
                //                 ServiceLocator.get<ProductDetailsService>(),
                //               ),
                //             ),
                //             BlocProvider<CartCubit>(
                //               create: (context) => CartCubit(ServiceLocator.get<CartService>()),
                //             ),
                //           ],
                //           child: ProductDetailsScreen(productId: product.id),
                //         ),
                //       ),
                //     );
                //   },
                //   child: Container(
                //     width: 45.w,
                //     margin: EdgeInsets.only(left: 3.w),
                //     padding: EdgeInsets.all(3.w),
                //     decoration: BoxDecoration(
                //       color: AppColors.white,
                //       borderRadius: BorderRadius.circular(3.w),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.05),
                //           blurRadius: 8,
                //           offset: const Offset(0, 2),
                //         ),
                //       ],
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         // Product Image Container
                //         Expanded(
                //           flex: 5,
                //           child: 
                //           Center(
                //             child: Container(
                //             margin: EdgeInsets.only(bottom: 1.h),
                //             decoration: BoxDecoration(
                //               color: AppColors.homeGradientWhite,
                //               borderRadius: BorderRadius.circular(3.w),
                //             ),
                //             child: ClipRRect(
                //               borderRadius: BorderRadius.circular(3.w),
                //               child: CachedNetworkImage(
                //                 imageUrl: product.baseImage,
                //                 fit: BoxFit.contain,
                //                 placeholder: (context, url) => Container(
                //                   color: AppColors.homeGradientWhite,
                //                   child: const Center(
                //                     child: CircularProgressIndicator(),
                //                   ),
                //                 ),
                //                 errorWidget: (context, url, error) => Container(
                //                   color: AppColors.homeGradientWhite,
                //                   child: Icon(
                //                     Icons.image_not_supported,
                //                     color: AppColors.textSecondary,
                //                     size: 8.w,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )),
                //         ),
                //         // Product Info
                //         Expanded(
                //           flex: 2,
                //           child:  Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: [
                //                 Expanded(
                //                   child: Text(
                //                     product.name,
                //                     style: TextStyles.textViewMedium16.copyWith(
                //                       color: AppColors.textPrimary,
                //                     ),
                //                     maxLines: 2,
                //                     overflow: TextOverflow.ellipsis,
                //                   ),
                //                 ),
                          
                //                 Text(
                //                   '${product.finalPrice} ${"egp".tr()}',
                //                   style: TextStyles.textViewBold16.copyWith(
                //                     color: AppColors.textPrimary,
                //                   ),
                //                 ),
                //               ],
                            
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // );
          
          
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchSavedCarts() async {
    setState(() {
      isLoadingSavedCarts = true;
    });

    try {
      final savedCartsService = ServiceLocator.get<SavedCartsService>();
      final response = await savedCartsService.getAllSavedCarts();
      
      setState(() {
        savedCarts = response.data;
        isLoadingSavedCarts = false;
      });
    } catch (e) {
      setState(() {
        isLoadingSavedCarts = false;
      });
      debugPrint('Error fetching saved carts: $e');
    }
  }

  Future<void> _addProductToSavedCart(int cartId, int productId, int quantity) async {
    try {
      final savedCartsService = ServiceLocator.get<SavedCartsService>();
      
      // Use default warehouse_id since it's not available in the saved cart items
      final warehouseId = 1; // Default warehouse ID
      
      final request = SavedCartItemActionRequestModel(
        productId: productId,
        quantity: quantity,
        warehouseId: warehouseId,
      );
      
      await savedCartsService.plusItemFromSavedCart(
        cartId: cartId,
        request: request,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("product_added_to_saved_cart".tr()),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error adding product to saved cart: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("error_adding_product".tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showSavedCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(4.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
          
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 80.w,
                  maxHeight: 45.h,
                ),
             
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   Center(child: CustomImageAsset(assetName:AppAssets.saveCart,width: 18.w,height: 18.w,)),
                    SizedBox(height: 1.w),
                    Text(
                "add_to_saved_cart".tr(),
                style: TextStyles.textViewBold16.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.w),
                  if (isLoadingSavedCarts)
                    const CircularProgressIndicator()
                  else if (savedCarts.isEmpty)
                    Column(
                      children: [
                        Text(
                          "no_saved_carts_available".tr(),
                          style: TextStyles.textViewMedium14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
             
                      ],
                    )
                  else
                    DropdownButtonFormField<int>(
                      decoration: 
                      InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.borderLight),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      hint: Text("choose_saved_cart".tr()),
                      value: selectedSavedCartId,
                      items: savedCarts.map((cart) {
                        return DropdownMenuItem(
                          value: cart.id,
                          child: Text(cart.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedSavedCartId = value;
                        });
                      },
                    ),
                         PrimaryButton(
                          margin: EdgeInsets.only(top: 4.w),
                          width: 80.w,
                          height: 5.5.h,
                  text: "save".tr(),
                  onPressed: selectedSavedCartId != null ? () async {
                    Navigator.of(context).pop();
                    await _addProductToSavedCart(
                      selectedSavedCartId!,
                      widget.productId,
                      quantity,
                    );
                    setState(() {
                      selectedSavedCartId = null;
                    });
                  } : null,
                
              
                ),
              
                  ],
                ),
              ),
             );
          },
        );
      },
    );
  }


}

/// Full-screen image gallery for product images
class ImageGalleryScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageGalleryScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageGalleryScreen> createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Image viewer
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Bottom indicator dots
          if (widget.images.length > 1)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.black
                          : Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
      
      
        ],
      ),
    );
  }
}