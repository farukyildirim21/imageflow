import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Enhances a document image and bundles it with its extracted text into a PDF.
class DocumentProcessingService {
  /// [imagePath]     – original image from the camera / gallery.
  /// [extractedText] – OCR result from [TextRecognitionService].
  ///
  /// Returns the raw PDF bytes.
  Future<Uint8List> generatePdf(
    String imagePath,
    String extractedText,
  ) async {
    final rawBytes = await File(imagePath).readAsBytes();
    var source = img.decodeImage(rawBytes);
    if (source == null) throw Exception('Could not decode image at $imagePath');

    // Downscale very large images so the PDF stays manageable.
    if (source.width > 1800) {
      source = img.copyResize(source, width: 1800, interpolation: img.Interpolation.linear);
    }

    // Boost contrast and brightness slightly to improve document legibility.
    img.adjustColor(source, contrast: 1.15, brightness: 1.05);

    final jpgBytes = Uint8List.fromList(img.encodeJpg(source, quality: 85));

    // Build PDF document.
    final doc = pw.Document(
      title: 'Scanned Document',
      author: 'ImageFlow',
    );

    final pdfImage = pw.MemoryImage(jpgBytes);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Document image scaled to fit the page width.
              pw.Image(pdfImage, fit: pw.BoxFit.contain),
              if (extractedText.trim().isNotEmpty) ...[
                pw.SizedBox(height: 18),
                pw.Divider(thickness: 0.5),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Extracted Text',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  extractedText.trim(),
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ],
          );
        },
      ),
    );

    return Uint8List.fromList(await doc.save());
  }
}
