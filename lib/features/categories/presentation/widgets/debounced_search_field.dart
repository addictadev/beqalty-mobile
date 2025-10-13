import 'dart:async';
import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:baqalty/core/widgets/custom_textform_field.dart';
import 'package:iconsax/iconsax.dart';

class DebouncedSearchField extends StatefulWidget {
  final String hint;
  final Function(String) onSearch;
  final Duration debounceDuration;
  final String? initialValue;
  final bool showClearButton;

  const DebouncedSearchField({
    super.key,
    required this.hint,
    required this.onSearch,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.initialValue,
    this.showClearButton = true,
  });

  @override
  State<DebouncedSearchField> createState() => _DebouncedSearchFieldState();
}

class _DebouncedSearchFieldState extends State<DebouncedSearchField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearch(value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: _controller,
      hint: widget.hint,
      onChanged: _onSearchChanged,
      prefixIcon: Icon(
        Iconsax.search_normal,
        color: AppColors.textSecondary,
        size: 20,
      ),
      suffixIcon: _controller.text.isNotEmpty && widget.showClearButton
          ? GestureDetector(
              onTap: _clearSearch,
              child: Container(
                margin: EdgeInsets.only(right: 12, left: 12),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ),
            )
          : null,
      fillColor: AppColors.white,
      borderColor: Colors.transparent,
      focusedBorderColor: AppColors.primary,
      borderWidth: 0,
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 16,
      ),
      filled: true,
    );
  }
}
