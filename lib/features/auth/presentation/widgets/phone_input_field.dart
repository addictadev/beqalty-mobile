import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';

class PhoneInputField extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String countryCode;
  final String? initialValue;
  final bool enabled;

  const PhoneInputField({
    super.key,
    this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.countryCode = '+20',
    this.initialValue,
    this.enabled = true,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: EdgeInsets.only(
              bottom: 8,
              right: isRTL ? 4 : 0,
              left: isRTL ? 0 : 4,
            ),
            child: Text(
              widget.label!,
              style: ResponsiveUtils.getResponsiveTextStyle(
                context,
                fontSize: ResponsiveUtils.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(context.responsiveBorderRadius),
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          child: Row(
            children: [
              // Country Code Container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(context.responsiveBorderRadius),
                    bottomLeft: Radius.circular(context.responsiveBorderRadius),
                  ),
                ),
                child: Text(
                  widget.countryCode,
                  style: ResponsiveUtils.getResponsiveTextStyle(
                    context,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              // Vertical Divider
              Container(height: 6.h, width: 1, color: AppColors.borderLight),

              // Phone Number Input
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: widget.validator,
                  onChanged: widget.onChanged,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: ResponsiveUtils.getResponsiveTextStyle(
                    context,
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 4.w,
                    ),
                    hintText: '1026329736',
                    hintStyle: ResponsiveUtils.getResponsiveTextStyle(
                      context,
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                      color: AppColors.textTertiary,
                    ),
                  ),
                  onTapOutside: (event) => _focusNode.unfocus(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
