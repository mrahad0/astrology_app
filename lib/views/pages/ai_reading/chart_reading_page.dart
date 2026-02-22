// lib/views/pages/ai_reading/chart_reading_page.dart
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../data/models/chart_models/recent_chart_model.dart';
import '../../../data/models/chart_models/saved_chart_model.dart';

/// A page that displays just the interpretation for a chart
class ChartReadingPage extends StatelessWidget {
  final RecentChartModel? recentChart;
  final SavedChartModel? savedChart;

  const ChartReadingPage({
    super.key,
    this.recentChart,
    this.savedChart,
  }) : assert(recentChart != null || savedChart != null, 
         'Either recentChart or savedChart must be provided');

  // Getters to access data from either model
  String get chartCategory => savedChart?.chartCategory ?? recentChart!.chartCategory;
  String get systemDisplayName => savedChart?.systemDisplayName ?? recentChart!.systemDisplayName;
  String get name => savedChart?.name ?? recentChart!.name;
  String get interpretation => savedChart?.interpretation ?? recentChart!.interpretation;
  int get wordCount => savedChart?.wordCount ?? recentChart!.wordCount;

  bool get hasInterpretation => interpretation.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "$systemDisplayName Reading",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: hasInterpretation 
          ? _buildInterpretationContent(context)
          : _buildNoInterpretationContent(context),
      ),
    );
  }

  /// Shows the interpretation content
  Widget _buildInterpretationContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card with chart info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xff2E334A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "$chartCategory - $systemDisplayName",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9A3BFF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$wordCount words",
                        style: const TextStyle(
                          color: Color(0xFF9A3BFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Reading for $name",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Interpretation content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xff2E334A)),
            ),
            child: MarkdownBody(
              data: interpretation,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.7),
                strong: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                em: const TextStyle(
                    color: Colors.white70, fontStyle: FontStyle.italic),
                h1: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 2),
                h2: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    height: 2),
                h3: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 2),
                listBullet: const TextStyle(color: Color(0xFF9A3BFF)),
                blockquote: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: const Color(0xFF9A3BFF).withOpacity(0.5),
                      width: 4,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Shows message when interpretation is not available
  Widget _buildNoInterpretationContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 80,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              "The interpretation is not generated for this chart",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Generate an interpretation from the chart details page to view your personalized reading.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
