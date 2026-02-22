// lib/data/models/chart_models/synastry_chart_model.dart
import 'aspect_model.dart';

class SynastryChartData {
  final String chartId;  // 🆕 Added
  final double compatibilityScore;
  final List<AspectModel> aspects;
  final String interpretation;
  final String profile1Name;
  final String profile2Name;
  final String system;

  SynastryChartData({
    required this.chartId,
    required this.compatibilityScore,
    required this.aspects,
    required this.interpretation,
    required this.profile1Name,
    required this.profile2Name,
    required this.system,
  });

  factory SynastryChartData.fromJson(Map<String, dynamic> json) {
    List<AspectModel> aspectList = [];

    if (json['aspects'] != null) {
      aspectList = (json['aspects'] as List)
          .map((aspect) => AspectModel.fromJson(aspect))
          .toList();
    }

    // 🆕 Extract or generate chartId
    String extractedChartId = json['chart_id'] ?? json['id'] ?? '';

    // If no chartId, generate from profile names
    if (extractedChartId.isEmpty) {
      final profile1 = json['profile1_name'] ?? 'partner1';
      final profile2 = json['profile2_name'] ?? 'partner2';
      final system = json['system'] ?? 'western';
      extractedChartId = '${profile1}_${profile2}_synastry_$system'
          .replaceAll(' ', '_');
    }

    return SynastryChartData(
      chartId: extractedChartId,
      compatibilityScore: (json['compatibility_score'] ?? 0).toDouble(),
      aspects: aspectList,
      interpretation: json['interpretation'] ?? '',
      profile1Name: json['profile1_name'] ?? '',
      profile2Name: json['profile2_name'] ?? '',
      system: json['system'] ?? '',
    );
  }
}

class SynastryChartResponse {
  final Map<String, SynastryChartData> results;
  final Map<String, String> images;
  final String message;

  SynastryChartResponse({
    required this.results,
    required this.images,
    required this.message,
  });

  factory SynastryChartResponse.fromJson(Map<String, dynamic> json) {
    Map<String, SynastryChartData> resultsMap = {};
    Map<String, String> imagesMap = {};

    // Parse results
    if (json['results'] != null) {
      (json['results'] as Map<String, dynamic>).forEach((key, value) {
        resultsMap[key] = SynastryChartData.fromJson(value);
      });
    }

    // Parse images
    if (json['images'] != null) {
      (json['images'] as Map<String, dynamic>).forEach((key, value) {
        imagesMap[key] = value.toString();
      });
    }

    return SynastryChartResponse(
      results: resultsMap,
      images: imagesMap,
      message: json['message'] ?? '',
    );
  }
}