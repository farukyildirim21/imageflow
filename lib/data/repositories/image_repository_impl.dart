import '../../domain/entities/processing_record.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/local/file_storage_service.dart';
import '../datasources/ml/face_detection_service.dart';
import '../datasources/ml/text_recognition_service.dart';
import '../models/processing_record_model.dart';

class ImageRepositoryImpl implements ImageRepository {
  final HiveService _hiveService;
  final FileStorageService _fileStorage;
  final FaceDetectionService _faceDetection;
  final TextRecognitionService _textRecognition;

  ImageRepositoryImpl({
    required HiveService hiveService,
    required FileStorageService fileStorage,
    required FaceDetectionService faceDetection,
    required TextRecognitionService textRecognition,
  })  : _hiveService = hiveService,
        _fileStorage = fileStorage,
        _faceDetection = faceDetection,
        _textRecognition = textRecognition;

  @override
  Future<ProcessingRecord> processFaceImage(String imagePath) {
    // Implemented in feature/face-processing
    throw UnimplementedError();
  }

  @override
  Future<ProcessingRecord> processDocumentImage(String imagePath) {
    // Implemented in feature/document-processing
    throw UnimplementedError();
  }

  @override
  Future<List<ProcessingRecord>> getHistory() async {
    return _hiveService.getAll().map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deleteRecord(String id) async {
    final records = _hiveService.getAll();
    final record = records.where((r) => r.id == id).firstOrNull;
    if (record != null) {
      await _fileStorage.deleteFile(record.resultPath);
      if (record.originalPath != null) {
        await _fileStorage.deleteFile(record.originalPath!);
      }
    }
    await _hiveService.delete(id);
  }
}
