import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../../app/routes/app_routes.dart';
import '../../../domain/entities/processing_record.dart';
import '../../home/controllers/home_controller.dart';

class ResultController extends GetxController {
  late final ProcessingRecord record;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is ProcessingRecord) {
      record = arg;
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  /// Open a file (image or PDF) in the device's native viewer.
  Future<void> viewFile(String? path) async {
    if (path == null || path.isEmpty) return;
    await OpenFilex.open(path);
  }

  /// Return to the home screen and refresh the history list.
  void done() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().reloadHistory();
    }
    Get.offAllNamed(AppRoutes.home);
  }
}
