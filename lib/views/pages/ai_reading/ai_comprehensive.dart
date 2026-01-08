import 'dart:io';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
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
              Get.toNamed(Routes.savedChart);
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

  /// Share button - shares interpretation as text
  Widget _buildShareButton(InterpretationController controller) {
    return OutlinedButton.icon(
      onPressed: () async {
        String shareText = "My Astrology Reading\n\n";
        
        // Add user info
        controller.userInfo.forEach((key, value) {
          shareText += "$key: $value\n";
        });
        shareText += "\n";
        
        // Add interpretations
        for (var interpretation in controller.interpretations) {
          shareText += "${interpretation.chartType ?? 'Chart'} - ${interpretation.system ?? 'System'}\n";
          shareText += "${interpretation.rawInterpretation ?? ''}\n\n";
        }
        
        await Share.share(shareText, subject: 'My Astrology Reading');
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
  Widget _buildDownloadButton(InterpretationController controller) {
    return OutlinedButton.icon(
      onPressed: () async {
        await _downloadAsTextFile(controller);
      },
      icon: const Icon(Icons.download, size: 18),
      label: const Text('Download'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF2A2F4A)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Downloads the reading as a text file
  Future<void> _downloadAsTextFile(InterpretationController controller) async {
    try {
      // Build content
      StringBuffer content = StringBuffer();
      content.writeln("=".padRight(50, '='));
      content.writeln("          ASTROLOGY READING");
      content.writeln("=".padRight(50, '='));
      content.writeln();
      
      // User Info
      content.writeln("--- USER INFORMATION ---");
      controller.userInfo.forEach((key, value) {
        content.writeln("$key: $value");
      });
      content.writeln();
      
      // Interpretations
      for (var interpretation in controller.interpretations) {
        content.writeln("-".padRight(50, '-'));
        content.writeln("${interpretation.chartType?.toUpperCase() ?? 'CHART'} - ${interpretation.system?.toUpperCase() ?? 'SYSTEM'}");
        content.writeln("-".padRight(50, '-'));
        content.writeln();
        content.writeln(interpretation.rawInterpretation ?? '');
        content.writeln();
      }
      
      content.writeln("=".padRight(50, '='));
      content.writeln("Generated on: ${DateTime.now().toString().substring(0, 19)}");
      content.writeln("=".padRight(50, '='));

      // Save file
      final output = await getApplicationDocumentsDirectory();
      final fileName = 'astrology_reading_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File('${output.path}/$fileName');
      await file.writeAsString(content.toString());

      showCustomSnackBar('Reading saved to: $fileName', isError: false);
    } catch (e) {
      showCustomSnackBar('Failed to save: $e');
    }
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