import '../entities/processing_record.dart';
import '../repositories/image_repository.dart';

class GetHistoryUseCase {
  final ImageRepository _repository;

  GetHistoryUseCase(this._repository);

  Future<List<ProcessingRecord>> call() {
    return _repository.getHistory();
  }
}
