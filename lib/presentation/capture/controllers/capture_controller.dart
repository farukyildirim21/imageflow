import 'dart:io';

import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/routes/app_routes.dart';

class CaptureController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;

  /// Opens camera, then normalises the image and navigates to processing.
  Future<void> pickFromCamera() async {
    isLoading.value = true;
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (picked != null) await _prepareAndNavigate(picked.path);
    } finally {
      isLoading.value = false;
    }
  }

  /// Opens gallery, then normalises the image and navigates to processing.
  Future<void> pickFromGallery() async {
    isLoading.value = true;
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) await _prepareAndNavigate(picked.path);
    } finally {
      isLoading.value = false;
    }
  }

  /// Decodes the picked file and re-encodes it as a standard sRGB JPEG.
  ///
  /// This normalises iOS HEIC, P3 wide-colour and other exotic formats into
  /// plain JPEG so that both [Image.file] and ML Kit receive consistent data.
  Future<void> _prepareAndNavigate(String sourcePath) async {
    String destPath = sourcePath;
    try {
      final rawBytes = await File(sourcePath).readAsBytes();
      final decoded = img.decodeImage(rawBytes);
      
      
      if (decoded != null) {
        final jpgBytes = img.encodeJpg(decoded, quality: 90);
        final tmp = await getTemporaryDirectory();
        final out = File(
          '${tmp.path}/imgflow_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await out.writeAsBytes(jpgBytes);
        destPath = out.path;
      }
    } catch (_) {
      // If normalisation fails, fall back to the original path.
       
    }

    Get.back(); // close bottom sheet
    Get.toNamed(AppRoutes.processing, arguments: {'imagePath': destPath});
  }
}
