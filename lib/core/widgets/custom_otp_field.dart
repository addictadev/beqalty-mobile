import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class CustomOtpField extends StatefulWidget {
  final int length;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final List<String>? initialValue;
  final bool enabled;
  final double boxSize;
  final double spacing;
  final TextStyle? textStyle;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final double borderRadius;

  const CustomOtpField({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.initialValue,
    this.enabled = true,
    this.boxSize = 60,
    this.spacing = 12,
    this.textStyle,
    this.borderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.borderRadius = 12,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _otpValues;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _otpValues = List.filled(widget.length, '');

    // Set initial values if provided
    if (widget.initialValue != null) {
      for (
        int i = 0;
        i < widget.initialValue!.length && i < widget.length;
        i++
      ) {
        _controllers[i].text = widget.initialValue![i];
        _otpValues[i] = widget.initialValue![i];
      }
    }

    // Add listeners to controllers
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        _onOtpChanged(i);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index) {
    final value = _controllers[index].text;
    if (value.length > 1) {
      _controllers[index].text = value[0];
      _otpValues[index] = value[0];
    } else {
      _otpValues[index] = value;
    }

    // Move to next field if current field is filled
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Move to previous field if current field is empty and backspace is pressed
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otpString = _otpValues.join('');
    widget.onChanged?.call(otpString);

    if (otpString.length == widget.length) {
      widget.onCompleted?.call(otpString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) => _buildOtpBox(index)),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      margin: EdgeInsets.only(
        right: index < widget.length - 1 ? widget.spacing : 0,
      ),
      child: SizedBox(
        width: widget.boxSize,
        height: widget.boxSize,
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          enabled: widget.enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style:
              widget.textStyle ??
              const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor ?? AppColors.white,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.borderLight,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.borderLight,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? AppColors.primary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: AppColors.borderLight.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
