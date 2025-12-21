// lib/models/chart_models/synastry_chart_model.dart
import 'aspect_model.dart';

class SynastryChartData {
  final double compatibilityScore;
  final List<AspectModel> aspects;
  final String interpretation;
  final String profile1Name;
  final String profile2Name;
  final String system;

  SynastryChartData({
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

    return SynastryChartData(
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