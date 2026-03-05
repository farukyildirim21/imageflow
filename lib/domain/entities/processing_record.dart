enum ProcessingType { face, document }

class ProcessingRecord {
  final String id;
  final ProcessingType type;
  final DateTime processedAt;
  final String resultPath;
  final String? originalPath;
  final int fileSizeBytes;

  const ProcessingRecord({
    required this.id,
    required this.type,
    required this.processedAt,
    required this.resultPath,
    this.originalPath,
    required this.fileSizeBytes,
  });
}
