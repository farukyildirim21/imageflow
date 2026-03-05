import 'package:hive/hive.dart';
import '../../domain/entities/processing_record.dart';

part 'processing_record_model.g.dart';

@HiveType(typeId: 0)
class ProcessingRecordModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type;

  @HiveField(2)
  late DateTime processedAt;

  @HiveField(3)
  late String resultPath;

  @HiveField(4)
  String? originalPath;

  @HiveField(5)
  late int fileSizeBytes;

  ProcessingRecord toEntity() => ProcessingRecord(
        id: id,
        type: type == 'face' ? ProcessingType.face : ProcessingType.document,
        processedAt: processedAt,
        resultPath: resultPath,
        originalPath: originalPath,
        fileSizeBytes: fileSizeBytes,
      );

  static ProcessingRecordModel fromEntity(ProcessingRecord record) {
    final model = ProcessingRecordModel()
      ..id = record.id
      ..type = record.type == ProcessingType.face ? 'face' : 'document'
      ..processedAt = record.processedAt
      ..resultPath = record.resultPath
      ..originalPath = record.originalPath
      ..fileSizeBytes = record.fileSizeBytes;
    return model;
  }
}
