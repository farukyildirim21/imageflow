import '../repositories/image_repository.dart';

class DeleteRecordUseCase {
  final ImageRepository _repository;

  DeleteRecordUseCase(this._repository);

  Future<void> call(String id) {
    return _repository.deleteRecord(id);
  }
}
