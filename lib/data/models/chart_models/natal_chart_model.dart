// lib/models/chart_models/natal_chart_model.dart
import 'planet_model.dart';
import 'house_model.dart';
import 'aspect_model.dart';

class NatalChartModel {
  final String system;
  final String name;
  final String birthDate;
  final String birthTime;
  final String imageUrl;
  final Map<String, PlanetModel> planets;
  final Map<int, HouseModel> houses;
  final List<AspectModel> aspects;
  final String sunSign;
  final String moonSign;
  final String risingSign;

  NatalChartModel({
    required this.system,
    required this.name,
    required this.birthDate,
    required this.birthTime,
    required this.imageUrl,
    required this.planets,
    required this.houses,
    required this.aspects,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
  });

  factory NatalChartModel.fromJson(Map<String, dynamic> json, String systemKey) {
    // Parse planets
    Map<String, PlanetModel> planetMap = {};
    if (json['planets'] != null) {
      (json['planets'] as Map<String, dynamic>).forEach((key, value) {
        planetMap[key] = PlanetModel.fromJson(key, value);
      });
    }

    // Parse houses
    Map<int, HouseModel> houseMap = {};
    if (json['houses'] != null) {
      (json['houses'] as Map<String, dynamic>).forEach((key, value) {
        HouseModel house = HouseModel.fromJson(key, value);
        houseMap[house.houseNumber] = house;
      });
    }

    // Parse aspects
    List<AspectModel> aspectList = [];
    if (json['aspects'] != null) {
      aspectList = (json['aspects'] as List)
          .map((aspect) => AspectModel.fromJson(aspect))
          .toList();
    }

    return NatalChartModel(
      system: systemKey,
      name: json['name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      birthTime: json['birth_time'] ?? '',
      imageUrl: '', // Will be set from images map
      planets: planetMap,
      houses: houseMap,
      aspects: aspectList,
      sunSign: json['sun_sign'] ?? '',
      moonSign: json['moon_sign'] ?? '',
      risingSign: json['rising_sign'] ?? json['ascendant'] ?? '',
    );
  }
}

class NatalChartResponse {
  final Map<String, NatalChartModel> charts;
  final Map<String, String> images;
  final List<String> systemsCalculated;
  final String message;

  NatalChartResponse({
    required this.charts,
    required this.images,
    required this.systemsCalculated,
    required this.message,
  });

  factory NatalChartResponse.fromJson(Map<String, dynamic> json) {
    Map<String, NatalChartModel> chartMap = {};
    Map<String, String> imageMap = {};

    // Parse charts
    if (json['charts'] != null) {
      (json['charts'] as Map<String, dynamic>).forEach((key, value) {
        chartMap[key] = NatalChartModel.fromJson(value, key);
      });
    }

    // Parse images
    if (json['images'] != null) {
      (json['images'] as Map<String, dynamic>).forEach((key, value) {
        imageMap[key] = value.toString();
      });
    }

    // Set image URLs to charts
    chartMap.forEach((key, chart) {
      if (imageMap.containsKey(key)) {
        chartMap[key] = NatalChartModel(
          system: chart.system,
          name: chart.name,
          birthDate: chart.birthDate,
          birthTime: chart.birthTime,
          imageUrl: imageMap[key]!,
          planets: chart.planets,
          houses: chart.houses,
          aspects: chart.aspects,
          sunSign: chart.sunSign,
          moonSign: chart.moonSign,
          risingSign: chart.risingSign,
        );
      }
    });

    return NatalChartResponse(
      charts: chartMap,
      images: imageMap,
      systemsCalculated: List<String>.from(json['systems_calculated'] ?? []),
      message: json['message'] ?? '',
    );
  }
}