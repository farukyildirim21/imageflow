import 'dart:io';
import 'package:flutter/material.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_radius.dart';
import '../../../domain/entities/processing_record.dart';

class GradientThumbnail extends StatelessWidget {
  final ProcessingType type;
  final String? imagePath;
  final double size;

  const GradientThumbnail({
    super.key,
    required this.type,
    this.imagePath,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = type == ProcessingType.face
        ? AppGradients.primary
        : AppGradients.subtle;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: size,
        height: size,
        child: imagePath != null && File(imagePath!).existsSync()
            ? Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(gradient: gradient),
                ),
              )
            : Container(
                decoration: BoxDecoration(gradient: gradient),
              ),
      ),
    );
  }
}
