import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/data/utils/pdf_generator.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
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
          init: Get.find<InterpretationController>(),
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
                      ...controller.interpretations.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key + 1;
                        final interpretation = entry.value;
                        final title =
                            "${interpretation.chartType ?? 'Chart'} - ${interpretation.system ?? 'System'}";
                        final content = interpretation.rawInterpretation ?? '';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _SectionCard(
                            sectionNumber: index,
                            title: title,
                            description: content,
                          ),
                        );
                      }),

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

  Widget _buildWordCountCard(
    int wordLimit,
    InterpretationController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D3554)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Word Count',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(width: 40),
              Text(
                'Generated',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$wordLimit words',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40),
              const Text(
                'Just Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
          const Text(
            'Info',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (userInfo.isEmpty)
            const Text(
              'No user information available.',
              style: TextStyle(color: Colors.grey),
            )
          else
            ...userInfo.entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InfoRow(
                      label: '${entry.key}:',
                      value: '${entry.value}',
                    ),
                  ),
                )
                .toList(),
        ],
      ),
    );
  }

  Widget _buildBottomActionButtons(InterpretationController controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isSaving
                ? null
                : () async {
                    final success = await controller.saveCharts();
                    if (success) {
                      // Navigate to Reading screen to see saved charts
                      Get.toNamed(
                        Routes.aiReading,
                        arguments: {'showBackButton': true},
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save Reading',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(
                Routes.aiReading,
                arguments: {'showBackButton': true},
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2A2F4A)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('View Reading'),
          ),
        ),
      ],
    );
  }

  /// Share button - shares interpretation as PDF
  Widget _buildShareButton(InterpretationController controller) {
    return OutlinedButton(
      onPressed: controller.isSharing
          ? null
          : () async {
              await PdfGenerator.generateAndSharePdf(
                controller: controller,
                onStart: () => controller.setSharing(true),
                onComplete: () => controller.setSharing(false),
              );
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF2A2F4A)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: controller.isSharing
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 18),
                SizedBox(width: 8),
                Text('Share'),
              ],
            ),
    );
  }

  /// Download button - saves as PDF file
  Widget _buildDownloadButton(InterpretationController controller) {
    return OutlinedButton(
      onPressed: controller.isDownloading
          ? null
          : () async {
              await PdfGenerator.generateAndSharePdf(
                controller: controller,
                onStart: () => controller.setDownloading(true),
                onComplete: () => controller.setDownloading(false),
              );
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
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download, size: 18),
                SizedBox(width: 8),
                Text('Download'),
              ],
            ),
    );
  }
}

// --- Internal SectionCard with Read More Logic (100 words) ---
class _SectionCard extends StatefulWidget {
  final int sectionNumber;
  final String title;
  final String description;

  const _SectionCard({
    required this.sectionNumber,
    required this.title,
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
          Text(
            'Section ${widget.sectionNumber}',
            style: const TextStyle(color: Color(0xFF9726f2), fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          MarkdownBody(
            data: isExpanded ? widget.description : previewText,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
              strong: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              em: const TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              h1: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              h2: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              h3: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
