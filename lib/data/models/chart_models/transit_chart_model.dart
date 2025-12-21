// lib/models/chart_models/transit_chart_model.dart
class TransitModel {
  final String planet;
  final String aspect;
  final double orb;
  final String influence;
  final String natalPosition;
  final String transitPosition;
  final String house;
  final String interpretation;

  TransitModel({
    required this.planet,
    required this.aspect,
    required this.orb,
    required this.influence,
    required this.natalPosition,
    required this.transitPosition,
    required this.house,
    required this.interpretation,
  });

  factory TransitModel.fromJson(Map<String, dynamic> json) {
    return TransitModel(
      planet: json['planet'] ?? '',
      aspect: json['aspect'] ?? '',
      orb: (json['orb'] ?? 0).toDouble(),
      influence: json['influence'] ?? '',
      natalPosition: json['natal_position'] ?? '',
      transitPosition: json['transit_position'] ?? '',
      house: json['house'] ?? '',
      interpretation: json['interpretation'] ?? '',
    );
  }
}

class TransitChartData {
  final String transitDate;
  final List<TransitModel> transits;
  final int significantAspects;
  final String overallQuality;
  final String interpretation;
  final String profileName;
  final String system;

  TransitChartData({
    required this.transitDate,
    required this.transits,
    required this.significantAspects,
    required this.overallQuality,
    required this.interpretation,
    required this.profileName,
    required this.system,
  });

  factory TransitChartData.fromJson(Map<String, dynamic> json) {
    List<TransitModel> transitList = [];

    if (json['transits'] != null) {
      transitList = (json['transits'] as List)
          .map((transit) => TransitModel.fromJson(transit))
          .toList();
    }

    return TransitChartData(
      transitDate: json['transit_date'] ?? '',
      transits: transitList,
      significantAspects: json['significant_aspects'] ?? 0,
      overallQuality: json['overall_quality'] ?? '',
      interpretation: json['interpretation'] ?? '',
      profileName: json['profile_name'] ?? '',
      system: json['system'] ?? '',
    );
  }
}

class TransitChartResponse {
  final Map<String, TransitChartData> results;
  final Map<String, String> images;
  final String message;

  TransitChartResponse({
    required this.results,
    required this.images,
    required this.message,
  });

  factory TransitChartResponse.fromJson(Map<String, dynamic> json) {
    Map<String, TransitChartData> resultsMap = {};
    Map<String, String> imagesMap = {};

    // Parse results
    if (json['results'] != null) {
      (json['results'] as Map<String, dynamic>).forEach((key, value) {
        resultsMap[key] = TransitChartData.fromJson(value);
      });
    }

    // Parse images
    if (json['images'] != null) {
      (json['images'] as Map<String, dynamic>).forEach((key, value) {
        imagesMap[key] = value.toString();
      });
    }

    return TransitChartResponse(
      results: resultsMap,
      images: imagesMap,
      message: json['message'] ?? '',
    );
  }
}

