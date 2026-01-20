import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../controllers/ai_compresive/ai_compresive_controller.dart';
import '../../controllers/chart_controller/chart_controller.dart';
import '../../data/models/ai_compresive/ai_interpretation_model.dart';
import '../../views/base/custom_snackBar.dart';

// Cache for loaded fonts
pw.Font? _cachedFont;
pw.Font? _cachedBoldFont;

class PdfGenerator {
  /// Loads fonts for PDF generation (cached for performance)
  static Future<pw.ThemeData> _loadTheme() async {
    if (_cachedFont == null) {
      try {
        // Try to load custom font from assets
        final regularData = await rootBundle.load('assets/fonts/Manrope-Regular.ttf');
        final boldData = await rootBundle.load('assets/fonts/Manrope-Bold.ttf');
        
        // Check if font files are valid (real TTF files are typically > 10KB)
        if (regularData.lengthInBytes > 10000 && boldData.lengthInBytes > 10000) {
          _cachedFont = pw.Font.ttf(regularData);
          _cachedBoldFont = pw.Font.ttf(boldData);
        } else {
          // Font files are too small, use default fonts
          _cachedFont = pw.Font.helvetica();
          _cachedBoldFont = pw.Font.helveticaBold();
        }
      } catch (e) {
        // Fallback to default fonts if loading fails
        _cachedFont = pw.Font.helvetica();
        _cachedBoldFont = pw.Font.helveticaBold();
      }
    }
    
    return pw.ThemeData.withFont(
      base: _cachedFont!,
      bold: _cachedBoldFont!,
    );
  }

  static Future<void> generateAndSharePdf({
    required InterpretationController controller,
    VoidCallback? onStart,
    VoidCallback? onComplete,
  }) async {
    onStart?.call();
    
    // Allow UI to update (show loading indicator) before heavy operations
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      // Load theme with custom fonts
      final theme = await _loadTheme();
      final pdf = pw.Document(theme: theme);

      Map<String, pw.MemoryImage> chartImages = await _loadChartImages();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // Title
              _buildTitle(),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),

              // User Info Section
              _buildUserInfoSection(controller.userInfo),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Interpretations with chart images
              ..._buildInterpretationSections(
                controller.interpretations,
                chartImages,
              ),

              // Footer
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),
              _buildFooter(),
            ];
          },
        ),
      );

      // Save and share the PDF
      await _saveAndSharePdf(pdf);
    } catch (e) {
      showCustomSnackBar('Failed to generate PDF: $e');
    } finally {
      onComplete?.call();
    }
  }

  static Future<void> generateSavedChartPdf({
    required Map<String, dynamic> chartData,
    required String interpretation,
    String? chartImageUrl,
    VoidCallback? onStart,
    VoidCallback? onComplete,
  }) async {
    onStart?.call();
    
    // Allow UI to update (show loading indicator) before heavy operations
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      // Load theme with custom fonts
      final theme = await _loadTheme();
      final pdf = pw.Document(theme: theme);

      pw.MemoryImage? chartImage;
      if (chartImageUrl != null && chartImageUrl.isNotEmpty) {
        try {
          chartImage = await _loadImageFromUrl(chartImageUrl);
        } catch (e) {
          // Skip if image fails to load
        }
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // Title
              _buildTitle(),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),

              // Chart Info Section
              _buildChartInfoSection(chartData),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Chart Image
              if (chartImage != null) ...[
                pw.Center(
                  child: pw.Container(
                    width: 300,
                    height: 300,
                    child: pw.Image(chartImage),
                  ),
                ),
                pw.SizedBox(height: 20),
              ],

              // Interpretation Section
              _buildInterpretationText(interpretation),

              // Footer
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),
              _buildFooter(),
            ];
          },
        ),
      );

      await _saveAndSharePdf(pdf);
    } catch (e) {
      showCustomSnackBar('Failed to generate PDF: $e');
    } finally {
      onComplete?.call();
    }
  }

  // ===================== Private Helper Methods =====================

  /// Builds the PDF title section
  static pw.Widget _buildTitle() {
    return pw.Center(
      child: pw.Text(
        'ASTROLOGY READING',
        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  /// Builds the user info section
  static pw.Widget _buildUserInfoSection(Map<String, dynamic> userInfo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'USER INFORMATION',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...userInfo.entries.map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text('${entry.key}: ${entry.value}'),
          ),
        ),
      ],
    );
  }

  /// Builds the chart info section for saved charts
  static pw.Widget _buildChartInfoSection(Map<String, dynamic> chartData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CHART INFORMATION',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        ...chartData.entries.map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text('${entry.key}: ${entry.value}'),
          ),
        ),
      ],
    );
  }

  /// Builds interpretation sections with optional chart images
  static List<pw.Widget> _buildInterpretationSections(
    List<InterpretationModel> interpretations,
    Map<String, pw.MemoryImage> chartImages,
  ) {
    return interpretations.map((interpretation) {
      final systemKey =
          interpretation.system?.toLowerCase().replaceAll(' ', '_') ?? '';
      final hasImage = chartImages.containsKey(systemKey);

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.purple50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              '${interpretation.chartType?.toUpperCase() ?? 'CHART'} - ${interpretation.system?.toUpperCase() ?? 'SYSTEM'}',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          // Add chart image if available
          if (hasImage)
            pw.Center(
              child: pw.Container(
                width: 300,
                height: 300,
                child: pw.Image(chartImages[systemKey]!),
              ),
            ),
          if (hasImage) pw.SizedBox(height: 15),
          pw.Text(
            (interpretation.rawInterpretation ?? '').replaceAll('**', ''),
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 20),
        ],
      );
    }).toList();
  }

  /// Builds the interpretation text section
  static pw.Widget _buildInterpretationText(String interpretation) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.purple50,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Text(
            'INTERPRETATION',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          interpretation.replaceAll('**', ''),
          style: const pw.TextStyle(fontSize: 11),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  /// Builds the PDF footer
  static pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Text(
        'Generated on: ${DateTime.now().toString().substring(0, 19)}',
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
      ),
    );
  }

  /// Loads chart images from ChartController (in parallel for performance)
  static Future<Map<String, pw.MemoryImage>> _loadChartImages() async {
    Map<String, pw.MemoryImage> chartImages = {};

    if (Get.isRegistered<ChartController>()) {
      final chartController = Get.find<ChartController>();
      final natalResponse = chartController.natalResponse.value;

      if (natalResponse != null && natalResponse.images.isNotEmpty) {
        // Load all images in parallel for better performance
        final futures = natalResponse.images.entries.map((entry) async {
          try {
            final image = await _loadImageFromUrl(entry.value);
            if (image != null) {
              return MapEntry(entry.key, image);
            }
          } catch (e) {
            // Skip if image fails to load
          }
          return null;
        }).toList();

        final results = await Future.wait(futures);
        for (var result in results) {
          if (result != null) {
            chartImages[result.key] = result.value;
          }
        }
      }
    }

    return chartImages;
  }

  /// Loads an image from URL and converts to MemoryImage
  static Future<pw.MemoryImage?> _loadImageFromUrl(String url) async {
    try {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final httpResponse = await response.close();
      final bytes = await _consolidateHttpResponseBytes(httpResponse);
      return pw.MemoryImage(bytes);
    } catch (e) {
      return null;
    }
  }

  /// Consolidates HTTP response bytes into a single Uint8List
  static Future<Uint8List> _consolidateHttpResponseBytes(
    HttpClientResponse response,
  ) async {
    final chunks = <List<int>>[];
    await for (var chunk in response) {
      chunks.add(chunk);
    }
    final totalLength = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
    final result = Uint8List(totalLength);
    var offset = 0;
    for (var chunk in chunks) {
      result.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return result;
  }

  /// Saves the PDF to temp directory and opens share dialog
  static Future<void> _saveAndSharePdf(pw.Document pdf) async {
    final tempDir = await getTemporaryDirectory();
    final fileName =
        'astrology_reading_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    // Open share dialog so user can save to Downloads or any location
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: 'Astrology Reading PDF'),
    );
  }
}
