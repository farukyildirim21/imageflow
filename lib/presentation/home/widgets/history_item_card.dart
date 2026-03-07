import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../domain/entities/processing_record.dart';
import '../../shared/widgets/gradient_thumbnail.dart';

class HistoryItemCard extends StatelessWidget {
  final ProcessingRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryItemCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onDelete,
  });

  String get _title =>
      record.type == ProcessingType.face ? 'Face Processed' : 'Document Scan';

  String get _formattedDate =>
      DateFormat('MMM d, yyyy').format(record.processedAt);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(72, 76, 109, 0.2),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            children: [
              GradientThumbnail(
                type: record.type,
                // For face: show the processed PNG result.
                // For document: resultPath is a PDF — show the original photo instead.
                imagePath: record.type == ProcessingType.face
                    ? record.resultPath
                    : record.originalPath,
                size: 32,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_title, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 4),
                    Text(_formattedDate, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.error),
    );
  }
}
