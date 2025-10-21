import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/styles/styles.dart';
import 'package:baqalty/core/widgets/primary_button.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:iconsax/iconsax.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:sizer/sizer.dart';

class SaveCartDialog extends StatefulWidget {
  final Function(String cartName) onSave;
  final String? initialName;

  const SaveCartDialog({
    super.key,
    required this.onSave,
    this.initialName,
  });

  @override
  State<SaveCartDialog> createState() => _SaveCartDialogState();
}

class _SaveCartDialogState extends State<SaveCartDialog> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onSave(_nameController.text.trim());
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
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
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Iconsax.shopping_bag,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "save_cart".tr(),
                      style: TextStyles.textViewBold18.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Description
              Text(
                "enter_cart_name_description".tr(),
                style: TextStyles.textViewMedium14.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 20),

              // Name input field
              CustomTextFormField(
                controller: _nameController,
                hint: "cart_name".tr(),
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please_enter_cart_name".tr();
                  }
                  if (value.trim().length < 2) {
                    return "cart_name_too_short".tr();
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),

              SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.borderLight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "cancel".tr(),
                        style: TextStyles.textViewMedium16.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: "save".tr(),
                      onPressed: _isLoading ? null : _handleSave,
                      color: AppColors.primary,
                      textStyle: TextStyles.textViewMedium16.copyWith(
                        color: Colors.white,
                      ),
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
