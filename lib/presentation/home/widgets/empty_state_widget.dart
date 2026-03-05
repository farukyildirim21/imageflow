import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCapture;

  const EmptyStateWidget({super.key, required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('No processed images yet', style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tap the + button to get started',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          TextButton(
            onPressed: onCapture,
            child: Text(
              'Start Processing',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.burrowingOwl,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
