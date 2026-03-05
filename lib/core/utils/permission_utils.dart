import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestGallery() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  static Future<bool> requestStorage() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
}
