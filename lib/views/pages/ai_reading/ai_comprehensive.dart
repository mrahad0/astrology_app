import 'dart:io';
import 'dart:typed_data';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../../controllers/ai_compresive/ai_compresive_controller.dart';

class AiComprehensive extends StatelessWidget {
  const AiComprehensive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Comprehensive Reading",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: GetBuilder<InterpretationController>(
          init: Get.isRegistered<InterpretationController>() 
              ? Get.find<InterpretationController>() 
              : Get.put(InterpretationController()),
          builder: (controller) {
            // 1. Show Loading State while fetching data
            if (controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            // 2. Calculate total word count from all interpretations
            int totalWords = 0;
            for (var interpretation in controller.interpretations) {
              totalWords += interpretation.wordLimit ?? 0;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Word Count Card ---
                    _buildWordCountCard(totalWords, controller),
                    const SizedBox(height: 20),

                    // --- Dynamic Info Card ---
                    _buildInfoCard(controller.userInfo),
                    const SizedBox(height: 20),

                    // --- Dynamic AI Sections from multiple interpretations ---
                    if (controller.interpretations.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            "No interpretation results available.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...controller.interpretations.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final interpretation = entry.value;
                        final title = "${interpretation.chartType ?? 'Chart'} - ${interpretation.system ?? 'System'}";
                        final content = interpretation.rawInterpretation ?? '';
                        final wordCount = content.split(' ').length;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _SectionCard(
                            sectionNumber: index,
                            title: title,
                            wordCount: "$wordCount words",
                            description: content,
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: 20),
                    _buildBottomActionButtons(controller),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildWordCountCard(int wordLimit, InterpretationController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D3554)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Word Count', style: TextStyle(color: Colors.grey, fontSize: 14)),
              SizedBox(width: 40),
              Text('Generated', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$wordLimit words',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
              const Text(
                'Just Now',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildShareButton(controller)),
              const SizedBox(width: 12),
              Expanded(child: _buildDownloadButton(controller)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> userInfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2F4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          if (userInfo.isEmpty)
            const Text('No user information available.', style: TextStyle(color: Colors.grey))
          else
            ...userInfo.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InfoRow(label: '${entry.key}:', value: '${entry.value}'),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomActionButtons(InterpretationController controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isSaving ? null : () async {
              await controller.saveCharts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: controller.isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text('Save Reading', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(Routes.aiReading, arguments: {'showBackButton': true});
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2A2F4A)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('View Reading'),
          ),
        ),
      ],
    );
  }

  /// Share button - shares interpretation as PDF
  Widget _buildShareButton(InterpretationController controller) {
    return OutlinedButton.icon(
      onPressed: () async {
        // Reuse the download logic which generates PDF and shares
        await _downloadAsTextFile(controller);
      },
      icon: const Icon(Icons.share, size: 18),
      label: const Text('Share'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF2A2F4A)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Download button - saves as text file
  /// Download button - saves as PDF file
  Widget _buildDownloadButton(InterpretationController controller) {
    return OutlinedButton(
      onPressed: controller.isDownloading
          ? null
          : () async {
              await _downloadAsTextFile(controller);
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF2A2F4A)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: controller.isDownloading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.download, size: 18),
                SizedBox(width: 8),
                Text('Download'),
              ],
            ),
    );
  }

  /// Downloads the reading as a PDF file with chart images
  Future<void> _downloadAsTextFile(InterpretationController controller) async {
    controller.setDownloading(true);
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Get chart images from ChartController if available
      Map<String, pw.MemoryImage> chartImages = {};
      if (Get.isRegistered<ChartController>()) {
        final chartController = Get.find<ChartController>();
        final natalResponse = chartController.natalResponse.value;
        
        // Download natal chart images
        if (natalResponse != null) {
          for (var entry in natalResponse.images.entries) {
            try {
              final response = await HttpClient().getUrl(Uri.parse(entry.value));
              final httpResponse = await response.close();
              final bytes = await consolidateHttpClientResponseBytes(httpResponse);
              chartImages[entry.key] = pw.MemoryImage(bytes);
            } catch (e) {
              // Skip if image fails to load
            }
          }
        }
      }

      // Add pages to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // Title
              pw.Center(
                child: pw.Text(
                  'ASTROLOGY READING',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),

              // User Info Section
              pw.Text(
                'USER INFORMATION',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...controller.userInfo.entries.map((entry) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Text('${entry.key}: ${entry.value}'),
              )),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Interpretations with chart images
              ...controller.interpretations.map((interpretation) {
                final systemKey = interpretation.system?.toLowerCase().replaceAll(' ', '_') ?? '';
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
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
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
                    if (hasImage)
                      pw.SizedBox(height: 15),
                    pw.Text(
                      (interpretation.rawInterpretation ?? '').replaceAll('**', ''),
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                    pw.SizedBox(height: 20),
                  ],
                );
              }),

              // Footer
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Generated on: ${DateTime.now().toString().substring(0, 19)}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              ),
            ];
          },
        ),
      );

      // Save to temp directory first, then share
      final tempDir = await getTemporaryDirectory();
      final fileName = 'astrology_reading_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      // Open share dialog so user can save to Downloads or any location
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Astrology Reading PDF',
      );
    } catch (e) {
      showCustomSnackBar('Failed to save PDF: $e');
    } finally {
      controller.setDownloading(false);
    }
  }

  /// Helper to consolidate HTTP response bytes
  Future<Uint8List> consolidateHttpClientResponseBytes(HttpClientResponse response) async {
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
}

// --- Internal SectionCard with Read More Logic (100 words) ---
class _SectionCard extends StatefulWidget {
  final int sectionNumber;
  final String title;
  final String wordCount;
  final String description;

  const _SectionCard({
    required this.sectionNumber,
    required this.title,
    required this.wordCount,
    required this.description,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Split description into words for 100-word preview
    final words = widget.description.split(' ');
    final bool needsTruncation = words.length > 100;
    final String previewText = needsTruncation
        ? "${words.take(100).join(' ')}..."
        : widget.description;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2F4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Section ${widget.sectionNumber}', style: const TextStyle(color: Color(0xFF9726f2), fontSize: 14)),
              Text(widget.wordCount, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          MarkdownBody(
            data: isExpanded ? widget.description : previewText,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
              strong: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              em: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
              h1: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              h2: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              h3: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              listBullet: const TextStyle(color: Colors.grey),
            ),
          ),
          if (needsTruncation) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Text(
                isExpanded ? "Read Less" : "Read More",
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}