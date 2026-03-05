import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  // Face processing thumbnail & primary actions
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.burrowingOwl, AppColors.greatHornedOwl],
  );

  // Accent — lighter coral
  static const LinearGradient accent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.greatHornedOwl, AppColors.tawnyOwl],
  );

  // Document processing thumbnail
  static const LinearGradient subtle = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.screechOwl, AppColors.greatGreyOwl],
  );
}
