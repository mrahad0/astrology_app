// lib/views/pages/ai_reading/saved_charts_details.dart
import 'dart:io';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/chart_models/saved_chart_model.dart';
import '../../../data/models/chart_models/recent_chart_model.dart';

/// A unified details page that can display either SavedChartModel or RecentChartModel
class SavedChartsDetails extends StatelessWidget {
  final SavedChartModel? savedChart;
  final RecentChartModel? recentChart;

  const SavedChartsDetails({
    super.key, 
    this.savedChart,
    this.recentChart,
  }) : assert(savedChart != null || recentChart != null, 'Either savedChart or recentChart must be provided');

  // Getters to access data from either model
  String get chartCategory => savedChart?.chartCategory ?? recentChart!.chartCategory;
  String get systemDisplayName => savedChart?.systemDisplayName ?? recentChart!.systemDisplayName;
  String get name => savedChart?.name ?? recentChart!.name;
  String get date => savedChart?.date ?? recentChart!.date;
  String get birthTime => savedChart?.birthTime ?? recentChart!.birthTime;
  String get city => savedChart?.city ?? recentChart!.city;
  String get country => savedChart?.country ?? recentChart!.country;
  String get chartImageUrl => savedChart?.chartImageUrl ?? recentChart!.chartImageUrl;
  String get interpretation => savedChart?.interpretation ?? recentChart!.interpretation;
  String get formattedDate => savedChart?.formattedDate ?? recentChart!.formattedDate;
  int get wordCount => savedChart?.wordCount ?? recentChart!.wordCount;
  String get systemType => savedChart?.systemType ?? recentChart!.systemType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "$chartCategory - $systemDisplayName",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Word Count & Generated Card
              _buildWordCountCard(context),

              const SizedBox(height: 16),

              // Chart Image Card
              if (chartImageUrl.isNotEmpty) ...[
                _buildChartImageCard(context),
                const SizedBox(height: 16),
              ],

              // Info Card
              _buildInfoCard(),

              const SizedBox(height: 16),

              // Interpretation Section
              if (interpretation.isNotEmpty)
                _buildInterpretationCard(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Word Count Card
  Widget _buildWordCountCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Word Count",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text("$wordCount words",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Generated",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(formattedDate,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _shareChart(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text("Share",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _downloadChart(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text("Download",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Chart Image Card
  Widget _buildChartImageCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$systemDisplayName Chart",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              chartImageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: 300,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF9A3BFF),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported,
                          color: Colors.grey, size: 50),
                      SizedBox(height: 8),
                      Text("Failed to load chart image",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Info Card
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Info",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _infoRow("Name:", name.isNotEmpty ? name : "-"),
          _infoRow("Date of Birth:", date.isNotEmpty ? date : "-"),
          _infoRow("Birth Time:", birthTime.isNotEmpty ? birthTime : "-"),
          _infoRow("City:", city.isNotEmpty ? city : "-"),
          _infoRow("Country:", country.isNotEmpty ? country : "-"),
          _infoRow("System:", systemDisplayName),
          _infoRow("Chart Type:", chartCategory),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Flexible(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  // Interpretation Card with Markdown
  Widget _buildInterpretationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$systemDisplayName Interpretation",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              Text("$wordCount words",
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          MarkdownBody(
            data: interpretation,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
              strong: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              em: const TextStyle(
                  color: Colors.white70, fontStyle: FontStyle.italic),
              h1: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              h2: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              h3: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              listBullet: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // Share functionality
  Future<void> _shareChart() async {
    String shareText = "$chartCategory - $systemDisplayName\n\n";
    shareText += "Name: $name\n";
    shareText += "Date of Birth: $date\n";
    shareText += "Birth Time: $birthTime\n";
    shareText += "Location: $city, $country\n\n";
    shareText += "--- Interpretation ---\n\n";
    shareText += interpretation;

    await Share.share(shareText, subject: 'My Astrology Chart Reading');
  }

  // Download functionality
  Future<void> _downloadChart() async {
    try {
      StringBuffer content = StringBuffer();
      content.writeln("=".padRight(50, '='));
      content.writeln("          ${chartCategory.toUpperCase()} - ${systemDisplayName.toUpperCase()}");
      content.writeln("=".padRight(50, '='));
      content.writeln();

      content.writeln("--- USER INFORMATION ---");
      content.writeln("Name: $name");
      content.writeln("Date of Birth: $date");
      content.writeln("Birth Time: $birthTime");
      content.writeln("City: $city");
      content.writeln("Country: $country");
      content.writeln();

      content.writeln("-".padRight(50, '-'));
      content.writeln("INTERPRETATION");
      content.writeln("-".padRight(50, '-'));
      content.writeln();
      content.writeln(interpretation);
      content.writeln();

      content.writeln("=".padRight(50, '='));
      content.writeln("Generated on: ${DateTime.now().toString().substring(0, 19)}");
      content.writeln("=".padRight(50, '='));

      final output = await getApplicationDocumentsDirectory();
      final fileName =
          'chart_${systemType}_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File('${output.path}/$fileName');
      await file.writeAsString(content.toString());

      showCustomSnackBar('Reading saved to: $fileName', isError: false);
    } catch (e) {
      showCustomSnackBar('Failed to save: $e');
    }
  }
}

/// Factory constructor to create from SavedChartModel
extension SavedChartsDetailsFromSaved on SavedChartsDetails {
  static SavedChartsDetails fromSavedChart(SavedChartModel chart) {
    return SavedChartsDetails(savedChart: chart);
  }
}

/// Factory constructor to create from RecentChartModel
extension SavedChartsDetailsFromRecent on SavedChartsDetails {
  static SavedChartsDetails fromRecentChart(RecentChartModel chart) {
    return SavedChartsDetails(recentChart: chart);
  }
}