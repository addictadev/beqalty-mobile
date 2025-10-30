import 'package:baqalty/core/images_preview/app_assets.dart';
import 'package:baqalty/core/images_preview/custom_svg_img.dart';
import 'package:baqalty/core/navigation_services/navigation_manager.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:baqalty/features/nav_bar/presentation/view/main_navigation_screen.dart';
import 'package:baqalty/features/cart/business/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/features/checkout/business/cubit/checkout_cubit.dart';
import 'package:baqalty/features/checkout/data/models/checkout_response_model.dart';
import 'package:baqalty/features/checkout/data/models/create_order_request_model.dart';
import 'package:baqalty/features/checkout/data/models/apply_discount_request_model.dart';
import 'package:baqalty/features/checkout/data/models/apply_discount_response_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class CheckoutScreen extends StatefulWidget {
  final int cartId;

  const CheckoutScreen({
    super.key,
    required this.cartId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int? selectedPaymentMethodId;
  bool isItemsExpanded = true;
  bool orderCreatedSuccessfully = false;
  
  // Promo code related variables
  final TextEditingController _promoCodeController = TextEditingController();
  ApplyDiscountResponseModel? appliedDiscount;
  bool isApplyingDiscount = false;
  
  // Store checkout data to prevent multiple API calls
  CheckoutDataModel? _storedCheckoutData;

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          "checkout".tr(),
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          
          if (state is CreateOrderSuccess) {
            // Mark order as created successfully
            orderCreatedSuccessfully = true;
            // Clear stored checkout data
            _storedCheckoutData = null;
            // Hide loading dialog
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            // Refresh cart data - use try-catch to handle provider not found
            try {
              context.read<CartCubit>().getAllCart();
            } catch (e) {
            }
            // Show success popup dialog
            _showOrderSuccessDialog(context);
          } else if (state is CreateOrderError) {
            
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                duration: Duration(seconds: 4),
              ),
            );
          } else if (state is ApplyDiscountSuccess) {
            // Handle successful discount application
            setState(() {
              appliedDiscount = state.discountData;
              isApplyingDiscount = false;
            });
            
            // Clear any existing snackbars first
            ScaffoldMessenger.of(context).clearSnackBars();
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.discountData.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: AppColors.success,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is ApplyDiscountError) {
            // Handle discount application error
            setState(() {
              isApplyingDiscount = false;
            });
            
            // Clear any existing snackbars first
            ScaffoldMessenger.of(context).clearSnackBars();
            
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: AppColors.error,
                duration: Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is ApplyDiscountLoading) {
            setState(() {
              isApplyingDiscount = true;
            });
          }
        },
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            // Get the latest checkout data and store it
            CheckoutDataModel? checkoutData;
            if (state is CheckoutLoaded) {
              checkoutData = state.checkoutData;
              _storedCheckoutData = checkoutData; // Store the data
            } else if (_storedCheckoutData != null) {
              // Use stored data if available (for discount states)
              checkoutData = _storedCheckoutData;
            }

            // Build the main content
            Widget mainContent;
            if (state is CheckoutLoading) {
              mainContent = _buildLoadingState();
            } else if (state is CheckoutError) {
              mainContent = _buildErrorState(context, state.message);
            } else if (checkoutData != null) {
              mainContent = _buildLoadedState(context, checkoutData);
            } else {
              // If no data is loaded yet and order wasn't created successfully, try to load it
              if (!orderCreatedSuccessfully) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<CheckoutCubit>().checkout(cartId: widget.cartId);
                });
              }
              mainContent = _buildLoadingState();
            }

            // Add loading overlay if creating order
            if (state is CreateOrderLoading) {
              return Stack(
                children: [
                  mainContent,
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "loading_checkout".tr(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return mainContent;
          },
        ),
     
     
      ),
    );
  }



  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 2.h),
            Text(
              "checkout_error".tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            PrimaryButton(
              text: "retry".tr(),
              onPressed: () {
                context.read<CheckoutCubit>().checkout(cartId: widget.cartId);
              },
            ),
          ],
        ),
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
          SizedBox(height: 2.h),
          Text(
            "loading_checkout".tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, CheckoutDataModel? checkoutData) {
    // If checkoutData is null (during order creation), show loading state
    if (checkoutData == null) {
      return _buildLoadingState();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items List
          _buildItemsList(checkoutData.items),
                    
            Text(
            "payment_methods".tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPaymentMethods(checkoutData.paymentTypes),
          
          SizedBox(height: 2.h),
          
          // Promo Code Section
          _buildPromoCodeSection(checkoutData),
          
          SizedBox(height: 2.h),
          
          // Wallet Status
          if (checkoutData.walletStatus.message != null)
            _buildWalletStatus(checkoutData.walletStatus),
          
          SizedBox(height: 1.h),
          
          // Checkout Section with dark card design
          _buildCheckoutSection(context, checkoutData),
          
          SizedBox(height: 2.h),
        ],
      ),
    );
  }


  Widget _buildItemsList(List<CheckoutItemModel> items) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          GestureDetector(
            onTap: () {
              setState(() {
                isItemsExpanded = !isItemsExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Shopping bag icon
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  CustomSvgImage(
                assetName: AppAssets.shoppingBag,
                width: context.responsiveIconSize,
                height: context.responsiveIconSize,
                color: AppColors.primary,
              ),
                ),
                SizedBox(width: 2.w),
                // Title and items count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "order_items".tr(),
                        style: TextStyles.textViewBold18.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        "${items.length} ${"items".tr()}",
                        style: TextStyles.textViewRegular14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron icon (up/down based on expansion state)
                AnimatedRotation(
                  turns: isItemsExpanded ? 0 : 0.5,
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
       if(isItemsExpanded)   SizedBox(height: 2.h),
          
          // Divider line
      if(isItemsExpanded)    Container(
            height: 1,
            color: Colors.grey[200],
          ),
          
          // Animated expandable items list
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isItemsExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isItemsExpanded ? 1.0 : 0.0,
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  // Items list
                  ...items.map((item) => _buildSimpleItemRow(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleItemRow(CheckoutItemModel item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${item.quantity} ${item.productName}",
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${(item.quantity* double.parse(item.finalPrice)).toStringAsFixed(2)} ${"currency".tr()}",
            style: TextStyles.textViewRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPaymentMethods(List<PaymentTypeModel> paymentTypes) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          ...paymentTypes.map((paymentType) => _buildPaymentMethodCard(paymentType)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentTypeModel paymentType) {
    final isSelected = selectedPaymentMethodId == paymentType.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethodId = paymentType.id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color:  AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio button
      
            // Payment icon
            Icon(
              _getPaymentIcon(paymentType.id),
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20.sp,
            ),
            SizedBox(width: 3.w),
            // Payment name
            Expanded(
              child: Text(
                paymentType.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
                  Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(int paymentId) {
    switch (paymentId) {
      case 1: // بطاقة
        return Iconsax.card;
      case 2: // الدفع عند الاستلام
        return Iconsax.money_2;
      case 3: // محفظة بقلتى
        return Iconsax.wallet;
      default:
        return Icons.payment;
    }
  }

  Widget _buildPromoCodeSection(CheckoutDataModel checkoutData) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            "promo_code".tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          
          // Promo Code Input and Apply Button
          Row(
            children: [
              // Text Field
              Expanded(
                 child:CustomTextFormField(
                   controller: _promoCodeController,
                   hint: "enter_promo_code".tr(),
                   hintStyle: TextStyle(
                     color: AppColors.textSecondary,
                     fontSize: 14.sp,
                   ),
                   onChanged: (value) {
                     // Update button state
                     setState(() {});
                   },
                 ),
              ),
                
         
              SizedBox(width: 2.w),
              
              // Apply Button
              SizedBox(
                height: 5.5.h,
                child: ElevatedButton(
                  onPressed: isApplyingDiscount ? null : _applyPromoCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _promoCodeController.text.trim().isNotEmpty ? AppColors.primary : AppColors.primary.withOpacity(.3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                  ),
                  child: isApplyingDiscount
                      ? SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "apply".tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
          
          // Applied Discount Display
          if (appliedDiscount != null) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.success,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20.sp,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "discount_applied".tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                        if (appliedDiscount!.discountAmount != null)
                          Text(
                            "${appliedDiscount!.discountAmount} ${"currency".tr()} ${"discount".tr()}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.success,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Remove discount button
                  GestureDetector(
                    onTap: _removeDiscount,
                    child: Icon(
                      Icons.close,
                      color: AppColors.success,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletStatus(WalletStatusModel walletStatus) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: walletStatus.canOrder ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: walletStatus.canOrder ? AppColors.success : AppColors.error,
        ),
      ),
      child: Row(
        children: [
          Icon(
            walletStatus.canOrder ? Icons.check_circle : Icons.error,
            color: walletStatus.canOrder ? AppColors.success : AppColors.error,
            size: 20.sp,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              walletStatus.message ?? "",
              style: TextStyle(
                fontSize: 14.sp,
                color: walletStatus.canOrder ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyPromoCode() {
    final promoCode = _promoCodeController.text.trim();
    if (promoCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("please_enter_promo_code".tr()),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Use stored checkout data instead of current state
    if (_storedCheckoutData != null) {
      final request = ApplyDiscountRequestModel(
        code: promoCode,
        subtotal: _storedCheckoutData!.subtotal.toDouble(),
        shippingCost: double.parse(_storedCheckoutData!.deliveryFee),
      );
      
      context.read<CheckoutCubit>().applyDiscount(request: request);
    } else {
      // If no stored data, show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("checkout_data_not_available".tr()),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _removeDiscount() {
    setState(() {
      appliedDiscount = null;
      _promoCodeController.clear();
    });
  }

  Widget _buildCheckoutSection(BuildContext context, CheckoutDataModel checkoutData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.responsivePadding),
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        image: DecorationImage(
          image: AssetImage(AppAssets.promotionalCard),
                    colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.color),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(
          context.responsiveBorderRadius * 1.5,
        ),
      ),
      child: Column(
        children: [
          // Order Summary in dark card
          _buildOrderSummaryInCard(checkoutData),
          
          SizedBox(height: 2.h),
          
          // Checkout Button
          _buildCheckoutButton(context, checkoutData),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryInCard(CheckoutDataModel checkoutData) {
    // Calculate discount amount
    double discountAmount = 0.0;
    if (appliedDiscount != null && appliedDiscount!.discountAmount != null) {
      discountAmount = double.parse(appliedDiscount!.discountAmount!);
    }
    
    // Calculate new total with discount
    double originalTotal = checkoutData.total.toDouble();
    double newTotal = originalTotal - discountAmount;
    
    return Column(
      children: [
        _buildSummaryRowInCard("subtotal".tr(), "${checkoutData.subtotal} ${"currency".tr()}"),
        _buildSummaryRowInCard("delivery_fee".tr(), "${checkoutData.deliveryFee} ${"currency".tr()}"),
        
        // Show discount if applied
        if (appliedDiscount != null && appliedDiscount!.discountAmount != null)
          _buildSummaryRowInCard(
            "discount".tr(),
            "-${appliedDiscount!.discountAmount} ${"currency".tr()}",
            isDiscount: true,
          ),
        
        _buildSummaryRowInCard(
          "total".tr(),
          "${newTotal.toStringAsFixed(2)} ${"currency".tr()}",
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRowInCard(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green[300] : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CheckoutDataModel checkoutData) {
    return PrimaryButton(
      text: "complete_order".tr(),
      color: AppColors.white,
      textStyle: TextStyles.textViewBold16.copyWith(
        color: AppColors.textPrimary,
      ),
      onPressed: () {
        _completeOrder(context, checkoutData);
      },
    );
  }

  void _completeOrder(BuildContext context, CheckoutDataModel checkoutData) {
    if (selectedPaymentMethodId == null) {
      // Clear any existing snackbars first
      ScaffoldMessenger.of(context).clearSnackBars();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "please_select_payment_method".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    // Create order request
    final request = CreateOrderRequestModel(
      cartId: widget.cartId,
      addressId: checkoutData.addressId, // TODO: Get from user's selected address
      warehouseId: checkoutData.warehouseId, // TODO: Get from checkout data or user selection
      paymentTypeId: selectedPaymentMethodId!,
      shippingCost: double.parse(checkoutData.deliveryFee),
      discountCode: appliedDiscount != null ? _promoCodeController.text.trim() : null,
    );

    // Call create order
    context.read<CheckoutCubit>().createOrder(request: request);
  }

  void _showOrderSuccessDialog(BuildContext context) {
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 50,
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Title
                Text(
                  "order_success_title".tr(),
                  style: TextStyles.textViewBold20.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 16),
                
                // Message
                Text(
                  "order_success_message".tr(),
                  style: TextStyles.textViewRegular16.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 32),
                
                // Go to Home Button
                SizedBox(
                  width: double.infinity,
                  height: 6.5.h,
                  child: ElevatedButton(
                      onPressed: () {
                        // Close dialog
                        Navigator.of(dialogContext).pop();
                        // Change to home tab using saved reference if available
                     NavigationManager.navigateToAndFinish(MainNavigationScreen());

                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "go_to_home".tr(),
                      style: TextStyles.textViewMedium16.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
