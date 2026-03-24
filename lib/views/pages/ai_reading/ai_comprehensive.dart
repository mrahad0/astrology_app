// lib/views/pages/ai_reading/ai_comprehensive.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/data/utils/pdf_generator.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import '../../../controllers/ai_compresive/ai_compresive_controller.dart';

class AiComprehensive extends StatelessWidget {
  const AiComprehensive({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/reading_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "Comprehensive Reading",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
          ),
        ),
        body: SafeArea(
          child: GetBuilder<InterpretationController>(
            init: Get.find<InterpretationController>(),
            builder: (controller) {
              // 1. Show Loading State while fetching data
              if (controller.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: ResponsiveHelper.width(4),
                  ),
                );
              }
              // 2. Calculate total word count from all interpretations
              int totalWords = 0;
              for (var interpretation in controller.interpretations) {
                totalWords += interpretation.wordLimit ?? 0;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Word Count Card ---
                      _buildWordCountCard(totalWords, controller),
                      SizedBox(height: ResponsiveHelper.space(20)),

                      // --- Dynamic Info Card ---
                      _buildInfoCard(controller.userInfo),
                      SizedBox(height: ResponsiveHelper.space(20)),

                      // --- Dynamic AI Sections from multiple interpretations ---
                      if (controller.interpretations.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: ResponsiveHelper.space(40)),
                            child: Text(
                              "No interpretation results available.",
                              style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
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
                            padding: EdgeInsets.only(bottom: ResponsiveHelper.space(16)),
                            child: _SectionCard(
                              sectionNumber: index,
                              title: title,
                              description: content,
                            ),
                          );
                        }),

                      SizedBox(height: ResponsiveHelper.space(20)),
                      _buildBottomActionButtons(controller),
                      SizedBox(height: ResponsiveHelper.space(20)),
                    ],
                  ),
                ),
              );
            },
          ),
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
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: const Color(0xFF2D3554)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Word Count',
                style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
              ),
              SizedBox(width: ResponsiveHelper.space(40)),
              Text(
                'Generated',
                style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$wordLimit words',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox( width: ResponsiveHelper.space(40)),
              Text(
                'Just Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(20)),
          Row(
            children: [

              Expanded(child: _buildShareButton(controller)),

              SizedBox(width: ResponsiveHelper.space(12)),

              Expanded(child: _buildDownloadButton(controller)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> userInfo) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: const Color(0xFF2A2F4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Info',
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(16),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),
          if (userInfo.isEmpty)
            Text(
              'No user information available.',
              style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
            )
          else
            ...userInfo.entries
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
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
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              ),
            ),
            child: controller.isSaving
                ? SizedBox(
                    height: ResponsiveHelper.height(20),
                    width: ResponsiveHelper.width(20),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: ResponsiveHelper.width(2),
                    ),
                  )
                : Text(
                    'Save Reading',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        SizedBox(width: ResponsiveHelper.space(12)),
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
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              ),
            ),
            child: Text(
              'View Reading',
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.bold,
              ),
            ),
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
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8))),
      ),
      child: controller.isSharing
          ? SizedBox(
              height: ResponsiveHelper.height(20),
              width: ResponsiveHelper.width(20),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: ResponsiveHelper.width(2),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: ResponsiveHelper.iconSize(18)),
                SizedBox(width: ResponsiveHelper.space(8)),
                Text(
                  'Share',
                  style: TextStyle(fontSize: ResponsiveHelper.fontSize(14)),
                ),
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
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8))),
      ),
      child: controller.isDownloading
          ? SizedBox(
              height: ResponsiveHelper.height(20),
              width: ResponsiveHelper.width(20),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: ResponsiveHelper.width(2),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download, size: ResponsiveHelper.iconSize(18)),
                SizedBox(width: ResponsiveHelper.space(8)),
                Text(
                  'Download',
                  style: TextStyle(fontSize: ResponsiveHelper.fontSize(14)),
                ),
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
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: const Color(0xFF2A2F4A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Section ${widget.sectionNumber}',
            style: TextStyle(color: const Color(0xFF9726f2), fontSize: ResponsiveHelper.fontSize(14)),
          ),
          SizedBox(height: ResponsiveHelper.space(8)),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(18),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(8)),
          MarkdownBody(
            data: isExpanded ? widget.description : previewText,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14), height: 1.5),
              strong: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.bold,
              ),
              em: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.fontSize(14),
                fontStyle: FontStyle.italic,
              ),
              h1: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(20),
                fontWeight: FontWeight.bold,
              ),
              h2: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(18),
                fontWeight: FontWeight.bold,
              ),
              h3: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(16),
                fontWeight: FontWeight.bold,
              ),
              listBullet: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
            ),
          ),
          if (needsTruncation) ...[
            SizedBox(height: ResponsiveHelper.space(12)),
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Text(
                isExpanded ? "Read Less" : "Read More",
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: ResponsiveHelper.fontSize(14),
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
          width: ResponsiveHelper.width(120),
          child: Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
