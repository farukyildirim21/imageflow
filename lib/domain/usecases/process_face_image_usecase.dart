import '../entities/processing_record.dart';
import '../repositories/image_repository.dart';

class ProcessFaceImageUseCase {
  final ImageRepository _repository;

  ProcessFaceImageUseCase(this._repository);

  Future<ProcessingRecord> call(String imagePath) {
    return _repository.processFaceImage(imagePath);
  }
}
