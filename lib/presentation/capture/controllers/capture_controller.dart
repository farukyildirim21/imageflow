import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/routes/app_routes.dart';

class CaptureController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;

  /// Opens camera, then navigates to processing screen.
  /// Processing screen runs ML Kit to automatically detect face vs document.
  Future<void> pickFromCamera() async {
    isLoading.value = true;
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) _navigateToProcessing(image.path);
    } finally {
      isLoading.value = false;
    }
  }

  /// Opens gallery, then navigates to processing screen.
  Future<void> pickFromGallery() async {
    isLoading.value = true;
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) _navigateToProcessing(image.path);
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToProcessing(String imagePath) {
    Get.back(); // close bottom sheet
    Get.toNamed(AppRoutes.processing, arguments: {'imagePath': imagePath});
  }
}
