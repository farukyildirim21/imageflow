import 'package:get/get.dart';

import '../../../data/datasources/ml/face_detection_service.dart';
import '../../../data/datasources/ml/face_processing_service.dart';
import '../../../data/datasources/ml/text_recognition_service.dart';
import '../../../data/datasources/ml/document_processing_service.dart';
import '../../../data/repositories/image_repository_impl.dart';
import '../../../domain/usecases/process_face_image_usecase.dart';
import '../../../domain/usecases/process_document_image_usecase.dart';
import '../controllers/processing_controller.dart';

class ProcessingBinding extends Bindings {
  @override
  void dependencies() {
    // ML services – fenix: true so they are recreated if previously disposed.
    Get.lazyPut<FaceDetectionService>(
      () => FaceDetectionService(),
      fenix: true,
    );
    Get.lazyPut<FaceProcessingService>(
      () => FaceProcessingService(),
      fenix: true,
    );
    Get.lazyPut<TextRecognitionService>(
      () => TextRecognitionService(),
      fenix: true,
    );
    Get.lazyPut<DocumentProcessingService>(
      () => DocumentProcessingService(),
      fenix: true,
    );

    // Use cases (repository is already registered via HomeBinding).
    Get.lazyPut<ProcessFaceImageUseCase>(
      () => ProcessFaceImageUseCase(Get.find<ImageRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut<ProcessDocumentImageUseCase>(
      () => ProcessDocumentImageUseCase(Get.find<ImageRepositoryImpl>()),
      fenix: true,// dispose edilse bile, yeniden create edilir
    );

    Get.lazyPut<ProcessingController>(
      () => ProcessingController(
        faceDetection: Get.find(),
        textRecognition: Get.find(),
        processFace: Get.find(),
        processDocument: Get.find(),
      ),
    );
  }
}
