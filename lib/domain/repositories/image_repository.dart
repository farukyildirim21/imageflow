import '../entities/processing_record.dart';

abstract class ImageRepository {
  Future<ProcessingRecord> processFaceImage(String imagePath);
  Future<ProcessingRecord> processDocumentImage(String imagePath);
  Future<List<ProcessingRecord>> getHistory();
  Future<void> deleteRecord(String id);
}
