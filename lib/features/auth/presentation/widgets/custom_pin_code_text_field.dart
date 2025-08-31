// ignore_for_file: must_be_immutable

import 'package:baqalty/core/theme/app_colors.dart' show AppColors;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField(
      {super.key,
      required this.context,
      required this.onChanged,
      this.alignment,
      this.controller,
      this.textStyle,
      this.hintStyle,
      this.validator,
      this.length = 4,
      required this.oncomplete});

  final Alignment? alignment;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  final int length;

  Function(String) onChanged;
  Function(String) oncomplete;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget,
          )
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => Padding(
        padding:  EdgeInsets.symmetric(horizontal: 3.w),
        child: PinCodeTextField(
          appContext: context,
          controller: controller,
          length: length,
          keyboardType: TextInputType.number,
          textStyle: textStyle,
          hintStyle: hintStyle,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          enableActiveFill: true,
          pinTheme: PinTheme(
            fieldHeight: 5.5.h,
            fieldWidth: 6.5.h,
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(2.w),
            inactiveColor: AppColors.textSecondary,
            activeColor: AppColors.textLight,
            selectedFillColor: AppColors.borderDark,
            inactiveFillColor: AppColors.white,
            activeFillColor: AppColors.borderDark,
            selectedColor: Colors.transparent,
          ),
          onChanged: (value) => onChanged(value),
          onCompleted: (value) => oncomplete(value),
          validator: validator,
        ),
      );
}
