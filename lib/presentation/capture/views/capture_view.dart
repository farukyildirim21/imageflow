import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/capture_controller.dart';

/// Bottom sheet — Camera / Gallery source selection.
/// After picking, ML Kit on the processing screen auto-detects face vs document.
class CaptureView extends StatelessWidget {
  const CaptureView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaptureController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox(
              height: 140,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.burrowingOwl),
              ),
            );
          }

          // "Choose Source" — matches mockup "Capture Modal"
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // .mockup-title inline: font-weight:600 / margin-bottom:space-md / text-primary
                Text('Choose Source', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.md),

                // Camera — .mockup-item + margin-bottom:space-sm
                _buildOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: controller.pickFromCamera,
                  marginBottom: true,
                ),

                // Gallery — .mockup-item
                _buildOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: controller.pickFromGallery,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // .mockup-item: rgba(72,76,109,0.2) | radius-sm(8px) | padding 12/16 | gap 12px
  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool marginBottom = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: marginBottom
            ? const EdgeInsets.only(bottom: AppSpacing.sm)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(72, 76, 109, 0.2),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,   // 12 px
          horizontal: AppSpacing.md, // 16 px
        ),
        child: Row(
          children: [
            // icon size: 1.25rem = 20px (matches mockup emoji span)
            Icon(icon, color: AppColors.textPrimary, size: 20),
            const SizedBox(width: AppSpacing.sm), // gap: space-sm (12 px)
            Text(label, style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }
}
