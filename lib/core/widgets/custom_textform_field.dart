import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final TextStyle? placeholderStyle;
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
    this.placeholder,
    this.placeholderStyle,
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
    this.borderRadius = 25,
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
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = widget.controller?.text.isNotEmpty ?? false;

    // Listen to controller changes
    widget.controller?.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _onFocusChanged() {
    setState(() {
      // Trigger rebuild on focus change
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFocused = _focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Main TextFormField
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
                    fontWeight: FontWeight.w500,
                  ),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle:
                    widget.labelStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                hintText: widget.hint,
                helperText: widget.helperText,
                prefixIcon: widget.prefixIcon,
                suffixIcon: _buildSuffixIcon(),
                prefixText: widget.prefixText,
                suffixText: widget.suffixText,
                filled: widget.filled,
                fillColor: widget.fillColor ?? Colors.white,
                contentPadding:
                    widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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

            // Floating placeholder label
            if (widget.placeholder != null)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                top: (isFocused || _hasText) ? -2 : 18,
                left: (isFocused || _hasText) ? 16 : 20,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: (isFocused || _hasText)
                      ? (widget.placeholderStyle ??
                            theme.textTheme.bodySmall!.copyWith(
                              color: isFocused
                                  ? (widget.focusedBorderColor ??
                                        AppColors.primary)
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                              backgroundColor: widget.fillColor ?? Colors.white,
                            ))
                      : (widget.placeholderStyle ??
                            theme.textTheme.bodyMedium!.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            )),
                  child: Container(
                    padding: (isFocused || _hasText)
                        ? const EdgeInsets.symmetric(horizontal: 6)
                        : EdgeInsets.zero,
                    decoration: (isFocused || _hasText)
                        ? BoxDecoration(
                            color: widget.fillColor ?? Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          )
                        : null,
                    child: Text(widget.placeholder!),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showVisibilityToggle && widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textTertiary,
          size: 22,
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
        color:
            color ??
            widget.borderColor ??
            AppColors.borderLight.withValues(alpha: 0.3),
        width: width ?? widget.borderWidth ?? 1.0,
      ),
    );
  }
}
