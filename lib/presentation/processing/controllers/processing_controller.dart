import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/datasources/ml/face_detection_service.dart';
import '../../../data/datasources/ml/text_recognition_service.dart';
import '../../../domain/usecases/process_face_image_usecase.dart';
import '../../../domain/usecases/process_document_image_usecase.dart';

enum ProcessingStep {
  analysing,   // face detection running
  faceEffect,  // colour-pop pipeline
  recognising, // OCR running
  generating,  // PDF generation
  saving,
  done,
  error,
}

class ProcessingController extends GetxController {
  final FaceDetectionService _faceDetection;
  final TextRecognitionService _textRecognition;
  final ProcessFaceImageUseCase _processFace;
  final ProcessDocumentImageUseCase _processDocument;

  ProcessingController({
    required FaceDetectionService faceDetection,
    required TextRecognitionService textRecognition,
    required ProcessFaceImageUseCase processFace,
    required ProcessDocumentImageUseCase processDocument,
  })  : _faceDetection = faceDetection,
        _textRecognition = textRecognition,
        _processFace = processFace,
        _processDocument = processDocument;

  final Rx<ProcessingStep> step = ProcessingStep.analysing.obs;
  final RxString errorMessage = ''.obs;

  // Image path received from the capture screen.
  late final String imagePath;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    imagePath = (args?['imagePath'] as String?) ?? '';
    if (imagePath.isEmpty) {
      _setError('No image path provided.');
      return;
    }
    _run();
  }

  Future<void> _run() async {
    try {
      // ── Step 1: face detection ──────────────────────────────────────────
      step.value = ProcessingStep.analysing;
      final faces = await _faceDetection.detectFaces(imagePath);

      if (faces.isNotEmpty) {
        // ── Face pipeline ────────────────────────────────────────────────
        step.value = ProcessingStep.faceEffect;
        final record = await _processFace(imagePath);

        step.value = ProcessingStep.done;
        Get.offNamed(AppRoutes.result, arguments: record);
        return;
      }

      // ── Step 2: text recognition ────────────────────────────────────────
      step.value = ProcessingStep.recognising;
      final recognized = await _textRecognition.recognizeText(imagePath);

      if (_textRecognition.hasText(recognized)) {
        // ── Document pipeline ────────────────────────────────────────────
        step.value = ProcessingStep.generating;
        final record = await _processDocument(imagePath);

        step.value = ProcessingStep.done;
        Get.offNamed(AppRoutes.result, arguments: record);
        return;
      }

      // ── Nothing detected ────────────────────────────────────────────────
      _setError(
        'No face or text detected in this image.\nTry a clearer photo.',
      );
    } catch (e) {
      _setError('Something went wrong.\nPlease try again.');
    }
  }

  void _setError(String message) {
    errorMessage.value = message;
    step.value = ProcessingStep.error;
  }

  void retry() {
    errorMessage.value = '';
    _run();
  }

  void goBack() => Get.back();

  // Human-readable label for the current step.
  String get stepLabel {
    switch (step.value) {
      case ProcessingStep.analysing:
        return 'Analysing image…';
      case ProcessingStep.faceEffect:
        return 'Applying portrait effect…';
      case ProcessingStep.recognising:
        return 'Recognising text…';
      case ProcessingStep.generating:
        return 'Generating document…';
      case ProcessingStep.saving:
        return 'Saving result…';
      case ProcessingStep.done:
        return 'Done';
      case ProcessingStep.error:
        return 'Error';
    }
  }
}
