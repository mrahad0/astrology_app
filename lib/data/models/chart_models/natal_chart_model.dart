// lib/data/models/chart_models/natal_chart_model.dart
import 'planet_model.dart';
import 'house_model.dart';
import 'aspect_model.dart';

class LocationData {
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String timezone;

  LocationData({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      timezone: json['timezone'] ?? '',
    );
  }
}

class NatalChartModel {
  final String chartId;
  final String system;
  final String name;
  final String birthDate;
  final String birthTime;
  final String imageUrl;
  final LocationData location;
  final Map<String, PlanetModel> planets;
  final Map<int, HouseModel> houses;
  final List<AspectModel> aspects;
  final String sunSign;
  final String moonSign;
  final String risingSign;

  // Vedic-specific fields (raw JSON data)
  final List<Map<String, dynamic>> siderealPlanetaryPositions;
  final Map<String, dynamic> lifepathIndicator;
  final Map<String, dynamic> lunarSystem;

  // Evolutionary-specific field
  final Map<String, dynamic> grid;

  // Galactic-specific field
  final Map<String, List<dynamic>> sections;

  // Human Design-specific fields
  final String hdType;
  final String hdStrategy;
  final String hdAuthority;
  final String hdProfile;
  final Map<String, dynamic> hdIncarnationCross;

  NatalChartModel({
    required this.chartId,
    required this.system,
    required this.name,
    required this.birthDate,
    required this.birthTime,
    required this.imageUrl,
    required this.location,
    required this.planets,
    required this.houses,
    required this.aspects,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    this.siderealPlanetaryPositions = const [],
    this.lifepathIndicator = const {},
    this.lunarSystem = const {},
    this.grid = const {},
    this.sections = const {},
    this.hdType = '',
    this.hdStrategy = '',
    this.hdAuthority = '',
    this.hdProfile = '',
    this.hdIncarnationCross = const {},
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

    // Parse location
    LocationData locationData = LocationData(
      city: '',
      country: '',
      latitude: 0.0,
      longitude: 0.0,
      timezone: '',
    );

    if (json['location'] != null) {
      locationData = LocationData.fromJson(json['location']);
    }

    // Parse Vedic-specific: sidereal_planetary_positions
    List<Map<String, dynamic>> siderealPositions = [];
    if (json['sidereal_planetary_positions'] != null) {
      siderealPositions = (json['sidereal_planetary_positions'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    // Parse Vedic-specific: lifepath_indicator
    Map<String, dynamic> lifepath = {};
    if (json['lifepath_indicator'] != null) {
      lifepath = Map<String, dynamic>.from(json['lifepath_indicator']);
    }

    // Parse Vedic-specific: lunar_system
    Map<String, dynamic> lunar = {};
    if (json['lunar_system'] != null) {
      lunar = Map<String, dynamic>.from(json['lunar_system']);
    }

    // Parse Evolutionary-specific: grid
    Map<String, dynamic> gridData = {};
    if (json['grid'] != null) {
      gridData = Map<String, dynamic>.from(json['grid']);
    }

    // Parse Galactic-specific: sections
    Map<String, List<dynamic>> sectionsData = {};
    if (json['sections'] != null) {
      (json['sections'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          sectionsData[key] = List<dynamic>.from(value);
        }
      });
    }


    return NatalChartModel(
      chartId: json['chart_id'] ?? json['id'] ?? '',
      system: systemKey,
      name: json['name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      birthTime: json['birth_time'] ?? '',
      imageUrl: '',
      location: locationData,
      planets: planetMap,
      houses: houseMap,
      aspects: aspectList,
      sunSign: json['sun_sign'] ?? '',
      moonSign: json['moon_sign'] ?? '',
      risingSign: json['rising_sign'] ?? json['ascendant'] ?? '',
      siderealPlanetaryPositions: siderealPositions,
      lifepathIndicator: lifepath,
      lunarSystem: lunar,
      grid: gridData,
      sections: sectionsData,
      hdType: json['type']?.toString() ?? '',
      hdStrategy: json['strategy']?.toString() ?? '',
      hdAuthority: json['authority']?.toString() ?? '',
      hdProfile: json['profile']?.toString() ?? '',
      hdIncarnationCross: json['incarnation_cross'] != null
          ? Map<String, dynamic>.from(json['incarnation_cross'])
          : {},
    );
  }

  // Helper method to create copy with updated imageUrl
  NatalChartModel copyWith({
    String? chartId,
    String? system,
    String? name,
    String? birthDate,
    String? birthTime,
    String? imageUrl,
    LocationData? location,
    Map<String, PlanetModel>? planets,
    Map<int, HouseModel>? houses,
    List<AspectModel>? aspects,
    String? sunSign,
    String? moonSign,
    String? risingSign,
    List<Map<String, dynamic>>? siderealPlanetaryPositions,
    Map<String, dynamic>? lifepathIndicator,
    Map<String, dynamic>? lunarSystem,
    Map<String, dynamic>? grid,
    Map<String, List<dynamic>>? sections,
    String? hdType,
    String? hdStrategy,
    String? hdAuthority,
    String? hdProfile,
    Map<String, dynamic>? hdIncarnationCross,
  }) {
    return NatalChartModel(
      chartId: chartId ?? this.chartId,
      system: system ?? this.system,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      planets: planets ?? this.planets,
      houses: houses ?? this.houses,
      aspects: aspects ?? this.aspects,
      sunSign: sunSign ?? this.sunSign,
      moonSign: moonSign ?? this.moonSign,
      risingSign: risingSign ?? this.risingSign,
      siderealPlanetaryPositions: siderealPlanetaryPositions ?? this.siderealPlanetaryPositions,
      lifepathIndicator: lifepathIndicator ?? this.lifepathIndicator,
      lunarSystem: lunarSystem ?? this.lunarSystem,
      grid: grid ?? this.grid,
      sections: sections ?? this.sections,
      hdType: hdType ?? this.hdType,
      hdStrategy: hdStrategy ?? this.hdStrategy,
      hdAuthority: hdAuthority ?? this.hdAuthority,
      hdProfile: hdProfile ?? this.hdProfile,
      hdIncarnationCross: hdIncarnationCross ?? this.hdIncarnationCross,
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

    // Set image URLs to charts using copyWith
    chartMap.forEach((key, chart) {
      if (imageMap.containsKey(key)) {
        chartMap[key] = chart.copyWith(imageUrl: imageMap[key]);
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
