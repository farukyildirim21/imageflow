enum ProcessingType { face, document }

class ProcessingRecord {
  final String id;
  final ProcessingType type; //face or document
  final DateTime processedAt;
  final String resultPath;
  final String? originalPath;
  final int fileSizeBytes;
  // Text extracted via OCR (document type only).
  final String? extractedText;

  const ProcessingRecord({
    required this.id,
    required this.type,
    required this.processedAt,
    required this.resultPath,
    this.originalPath,
    required this.fileSizeBytes,
    this.extractedText,
  });
}
