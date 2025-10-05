import 'package:flutter/material.dart';
import 'package:baqalty/core/theme/app_colors.dart';
import 'package:baqalty/core/utils/responsive_utils.dart';
import 'package:sizer/sizer.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: 16,
      ),
      child: Column(
        children: [
          // Step indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalSteps,
              (index) => _buildStepDot(index + 1),
            ),
          ),

          SizedBox(height: 12),

          // Step titles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              totalSteps,
              (index) => _buildStepTitle(index + 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot(int stepNumber) {
    final isActive = stepNumber == currentStep;
    final isCompleted = stepNumber < currentStep;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isActive
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.3),
            border: Border.all(
              color: isCompleted || isActive
                  ? AppColors.primary
                  : AppColors.textSecondary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        if (stepNumber < totalSteps) ...[
          SizedBox(width: 8),
          Container(
            width: 35.w,
            height: 2,
            color: stepNumber < currentStep
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildStepTitle(int stepNumber) {
    final isActive = stepNumber == currentStep;
    final isCompleted = stepNumber < currentStep;

    return Expanded(
      child: Text(
        stepTitles[stepNumber - 1],
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isActive || isCompleted
              ? FontWeight.w600
              : FontWeight.w400,
          color: isActive || isCompleted
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}
