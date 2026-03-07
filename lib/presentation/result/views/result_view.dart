import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imageflow/app/theme/app_gradients.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../domain/entities/processing_record.dart';
import '../controllers/result_controller.dart';

class ResultView extends StatelessWidget {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResultController>();
    final record = controller.record;
    final isFace = record.type == ProcessingType.face;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── "← Face Result" / "← PDF Created" title ────────────
              _TitleRow(
                text: isFace ? 'Face Result' : 'PDF Created',
                onBack: controller.done,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Compare / result body ────────────────────────────────
              if (isFace)
                _FaceSwipeCompare(record: record)
              else
                _DocumentResult(record: record, controller: controller),

              const Spacer(),

              // ── Done / Open PDF button ───────────────────────────────
              _PrimaryButton(
                label: isFace ? 'Done' : 'Open PDF',
                onTap: isFace
                    ? controller.done
                    : () => controller.viewFile(record.resultPath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Title row with back arrow ─────────────────────────────────────────────────

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.text, required this.onBack});
  final String text;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: const Icon(
            Icons.arrow_back,
            size: 20,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(text, style: AppTextStyles.titleSmall),
      ],
    );
  }
}

// ── Face: swipe before / after ────────────────────────────────────────────────

class _FaceSwipeCompare extends StatefulWidget {
  const _FaceSwipeCompare({required this.record});
  final ProcessingRecord record;

  @override
  State<_FaceSwipeCompare> createState() => _FaceSwipeCompareState();
}

class _FaceSwipeCompareState extends State<_FaceSwipeCompare> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Swipeable image container ─────────────────────────────────
        // Label lives INSIDE each card (matches mockup).
        // Fixed height: tall enough to show portrait images comfortably.
        SizedBox(
          height: 360,
          child: PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _page = i),
            children: [
              _ImageCard(label: 'Before', path: widget.record.originalPath),
              _ImageCard(label: 'After', path: widget.record.resultPath),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // ── Page dots ─────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _page == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _page == i
                    ? AppColors.burrowingOwl
                    : AppColors.greatGreyOwl,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        // ── Swipe hint ────────────────────────────────────────────────
        Text(
          '← swipe to compare →',
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSmall,
        ),
      ],
    );
  }
}

/// A single image card used inside the PageView.
/// The label sits inside the container at the top (matches mockup).
/// The image has uniform padding on all four sides.
class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.label, required this.path});
  final String label;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Small horizontal margin so next page peeks at the edge.
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(72, 76, 109, 0.2),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      padding: const EdgeInsets.all(AppSpacing.md), // uniform padding all sides
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label inside the container — matches mockup-compare-label
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          // Image fills remaining space with contain (no crop, no distortion)
          Expanded(child: _buildImage()),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (path == null || path!.isEmpty) return _placeholder();
    final file = File(path!);
    if (!file.existsSync()) return _placeholder();

    return Image.file(
      file,
      fit: BoxFit.contain, // full image visible, aspect ratio preserved
      width: double.infinity,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(Icons.image_outlined, size: 36, color: AppColors.textMuted),
    );
  }
}

// ── Document result ───────────────────────────────────────────────────────────

class _DocumentResult extends StatelessWidget {
  const _DocumentResult({required this.record, required this.controller});
  final ProcessingRecord record;
  final ResultController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // PDF icon — matches mockup exactly
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(234, 79, 108, 0.1),
              border: Border.all(color: AppColors.burrowingOwl, width: 2),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(
              child: Text(
                'PDF',
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.burrowingOwl,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Document Scan',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (record.extractedText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${record.extractedText!.split('\n').length} lines extracted',
              style: AppTextStyles.labelSmall,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Primary gradient button ───────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
