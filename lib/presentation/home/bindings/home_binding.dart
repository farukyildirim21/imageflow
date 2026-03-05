import 'package:get/get.dart';
import '../../../data/datasources/local/hive_service.dart';
import '../../../data/datasources/local/file_storage_service.dart';
import '../../../data/datasources/ml/face_detection_service.dart';
import '../../../data/datasources/ml/text_recognition_service.dart';
import '../../../data/repositories/image_repository_impl.dart';
import '../../../domain/usecases/get_history_usecase.dart';
import '../../../domain/usecases/delete_record_usecase.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // HiveService is already registered in main.dart as permanent
    Get.lazyPut(() => FileStorageService());
    Get.lazyPut(() => FaceDetectionService());
    Get.lazyPut(() => TextRecognitionService());

    Get.lazyPut(() => ImageRepositoryImpl(
          hiveService: Get.find(),
          fileStorage: Get.find(),
          faceDetection: Get.find(),
          textRecognition: Get.find(),
        ));

    Get.lazyPut(() => GetHistoryUseCase(Get.find<ImageRepositoryImpl>()));
    Get.lazyPut(() => DeleteRecordUseCase(Get.find<ImageRepositoryImpl>()));

    Get.lazyPut<HomeController>(() => HomeController(
          getHistory: Get.find(),
          deleteRecord: Get.find(),
        ));
  }
}
