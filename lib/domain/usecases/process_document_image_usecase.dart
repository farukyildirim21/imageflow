import '../entities/processing_record.dart';
import '../repositories/image_repository.dart';

class ProcessDocumentImageUseCase {
  final ImageRepository _repository;

  ProcessDocumentImageUseCase(this._repository);

  Future<ProcessingRecord> call(String imagePath) {
    return _repository.processDocumentImage(imagePath);
  }
}
