import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../domain/entities/processing_record.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/local/file_storage_service.dart';
import '../datasources/ml/face_detection_service.dart';
import '../datasources/ml/face_processing_service.dart';
import '../datasources/ml/text_recognition_service.dart';
import '../datasources/ml/document_processing_service.dart';
import '../models/processing_record_model.dart';

class ImageRepositoryImpl implements ImageRepository {
  final HiveService _hiveService;
  final FileStorageService _fileStorage;
  final FaceDetectionService _faceDetection;
  final FaceProcessingService _faceProcessing;
  final TextRecognitionService _textRecognition;
  final DocumentProcessingService _documentProcessing;

  ImageRepositoryImpl({
    required HiveService hiveService,
    required FileStorageService fileStorage,
    required FaceDetectionService faceDetection,
    required FaceProcessingService faceProcessing,
    required TextRecognitionService textRecognition,
    required DocumentProcessingService documentProcessing,
  })  : _hiveService = hiveService,
        _fileStorage = fileStorage,
        _faceDetection = faceDetection,
        _faceProcessing = faceProcessing,
        _textRecognition = textRecognition,
        _documentProcessing = documentProcessing;

  @override
  Future<ProcessingRecord> processFaceImage(String imagePath) async {
    // Detect face bounding boxes for the colour-pop effect.
    final faces = await _faceDetection.detectFaces(imagePath);

    // Apply colour-pop: greyscale + restored face region.
    final processedBytes = await _faceProcessing.process(imagePath, faces);

    // Persist to app storage.
    final id = const Uuid().v4();
    final savedFile = await _fileStorage.saveBytes(
      processedBytes,
      'face_$id.png',
    );

    final record = ProcessingRecord(
      id: id,
      type: ProcessingType.face,
      processedAt: DateTime.now(),
      resultPath: savedFile.path,
      originalPath: imagePath,
      fileSizeBytes: await savedFile.length(),
    );

    await _hiveService.save(ProcessingRecordModel.fromEntity(record));
    return record;
  }

  @override
  Future<ProcessingRecord> processDocumentImage(String imagePath) async {
    // Run OCR.
    final recognized = await _textRecognition.recognizeText(imagePath);
    final extractedText = recognized.text.trim();

    // Enhance image and embed in PDF.
    final pdfBytes =
        await _documentProcessing.generatePdf(imagePath, extractedText);

    // Persist PDF.
    final id = const Uuid().v4();
    final savedFile = await _fileStorage.saveBytes(
      pdfBytes,
      'doc_$id.pdf',
      isPdf: true,
    );

    final record = ProcessingRecord(
      id: id,
      type: ProcessingType.document,
      processedAt: DateTime.now(),
      resultPath: savedFile.path,
      originalPath: imagePath,
      fileSizeBytes: await savedFile.length(),
      extractedText: extractedText.isEmpty ? null : extractedText,
    );

    await _hiveService.save(ProcessingRecordModel.fromEntity(record));
    return record;
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
        // Only delete originals that live inside app-managed directories.
        final original = File(record.originalPath!);
        final docsDir = original.parent.path;
        final managedDirs = [
          await _fileStorage.getProcessedImagesDir(),
          await _fileStorage.getPdfsDir(),
        ];
        if (managedDirs.any((d) => docsDir.startsWith(d))) {
          await _fileStorage.deleteFile(record.originalPath!);
        }
      }
    }
    await _hiveService.delete(id);
  }
}
