import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../theme/app_colors.dart';

class CustomUpdateDialog extends StatelessWidget {
  const CustomUpdateDialog({super.key, required this.onUpdateNow, this.onSkip});

  final VoidCallback onUpdateNow;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final bool isMandatory = onSkip == null;

    return PopScope(
      canPop: isMandatory ? false : true,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.system_update,
                size: 70,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'update_available_title'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isMandatory
                    ? 'update_mandatory_message'.tr()
                    : 'update_optional_message'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  if (!isMandatory)
                    Expanded(
                      flex: 4,
                      child: OutlinedButton(
                        onPressed: onSkip,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'skip'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  if (!isMandatory) const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: ElevatedButton(
                      onPressed: onUpdateNow,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'update_now'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
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
