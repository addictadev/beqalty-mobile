import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final bool showVisibilityToggle;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.inputFormatters,
    this.focusNode,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius = 12,
    this.borderWidth,
    this.contentPadding,
    this.filled = true,
    this.showVisibilityToggle = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              style:
                  widget.labelStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
        TextFormField(
          onTapOutside: (event) => _focusNode.unfocus(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          obscuringCharacter: '*',
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          focusNode: _focusNode,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          style:
              widget.textStyle ??
              theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            filled: widget.filled,
            fillColor: widget.fillColor ?? AppColors.inputBackground,
            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintStyle:
                widget.hintStyle ??
                theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 16,
                ),
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(
              color: widget.focusedBorderColor ?? AppColors.primary,
              width: 1.5,
            ),
            errorBorder: _buildBorder(
              color: widget.errorBorderColor ?? AppColors.error,
            ),
            focusedErrorBorder: _buildBorder(
              color: widget.errorBorderColor ?? AppColors.error,
              width: 1.5,
            ),
            disabledBorder: _buildBorder(color: AppColors.borderLight),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showVisibilityToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textTertiary,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  OutlineInputBorder _buildBorder({Color? color, double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(
        color: color ?? widget.borderColor ?? AppColors.borderLight,
        width: width ?? widget.borderWidth ?? 1.0,
      ),
    );
  }
}
