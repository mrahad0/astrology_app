// lib/services/chart_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chart_models/natal_chart_model.dart';
import '../models/chart_models/synastry_chart_model.dart';
import '../models/chart_models/transit_chart_model.dart';
import 'api_client.dart';
import 'api_constant.dart';

class ChartService {

  // Generate Natal Chart
  static Future<NatalChartResponse?> generateNatalChart({
    required String name,
    required String birthDate,
    required String birthTime,
    required String birthCity,
    required String birthCountry,
    required List<String> systems,
  }) async {
    try {
      final body = jsonEncode({
        "name": name,
        "birth_date": birthDate,
        "birth_time": birthTime,
        "birth_city": birthCity,
        "birth_country": birthCountry,
        "system": systems.map((s) => s.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_')).toList(),
        "generate_image": true,
        "save_profile": true,
      });

      Response response = await ApiClient.postData(
        ApiConstant.natalChart,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NatalChartResponse.fromJson(response.body);
      } else {
        // Fallback to static data if API fails (e.g., due to year restriction)
        debugPrint("API Error ${response.statusCode}: Returning static fallback data.");
        return _getMockNatalData(name, birthDate, birthTime, birthCity, birthCountry, systems);
      }
    } catch (e) {
      debugPrint("API Exception: $e. Returning static fallback data.");
      return _getMockNatalData(name, birthDate, birthTime, birthCity, birthCountry, systems);
    }
  }

  // Static Mock Data for Fallback
  static NatalChartResponse _getMockNatalData(String name, String dob, String tob, String city, String country, List<String> systems) {
    Map<String, NatalChartModel> charts = {};
    Map<String, String> images = {};

    for (var system in systems) {
      String key = system.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
      charts[key] = NatalChartModel(
        chartId: "mock_${DateTime.now().millisecondsSinceEpoch}",
        system: key,
        name: name,
        birthDate: dob,
        birthTime: tob,
        imageUrl: "assets/images/chartimage.png",
        location: LocationData(city: city, country: country, latitude: 0.0, longitude: 0.0, timezone: "UTC"),
        planets: {},
        houses: {},
        aspects: [],
        sunSign: "Aries",
        moonSign: "Taurus",
        risingSign: "Gemini",
      );
      images[key] = "assets/images/chartimage.png";
    }

    return NatalChartResponse(
      charts: charts,
      images: images,
      systemsCalculated: systems,
      message: "Showing static data for demonstration purposes."
    );
  }

  // Generate Transit Chart
  static Future<TransitChartResponse?> generateTransitChart({
    required String name,
    required String birthDate,
    required String birthTime,
    required String birthCity,
    required String birthCountry,
    required String transitDate,
    required List<String> systems,
  }) async {
    try {
      final body = jsonEncode({
        "profile": {
          "name": name,
          "birth_date": birthDate,
          "birth_time": birthTime,
          "birth_city": birthCity,
          "birth_country": birthCountry,
        },
        "transit_date": transitDate,
        "system": systems.map((s) => s.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_')).toList(),
        "generate_image": true,
        "save_profile": true,
      });

      debugPrint('Transit Chart Request: $body');

      Response response = await ApiClient.postData(
        ApiConstant.transitChart,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransitChartResponse.fromJson(response.body);
      } else {
        // Fallback to static data
        debugPrint("Transit API Error ${response.statusCode}: Returning static fallback data.");
        return _getMockTransitData(name, transitDate, systems);
      }
    } catch (e) {
      debugPrint("Transit API Exception: $e. Returning static fallback data.");
      return _getMockTransitData(name, transitDate, systems);
    }
  }

  // Static Mock Data for Transit Fallback
  static TransitChartResponse _getMockTransitData(String name, String transitDate, List<String> systems) {
    Map<String, TransitChartData> results = {};
    Map<String, String> images = {};

    for (var system in systems) {
      String key = system.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
      results[key] = TransitChartData(
        chartId: "mock_transit_${DateTime.now().millisecondsSinceEpoch}",
        transitDate: transitDate,
        transits: [],
        significantAspects: 0,
        overallQuality: "Neutral",
        interpretation: "This is static fallback interpretation for transit chart.",
        profileName: name,
        system: key,
      );
      images[key] = "assets/images/chartimage.png";
    }

    return TransitChartResponse(
      results: results,
      images: images,
      message: "Showing static data for demonstration purposes."
    );
  }

  // Generate Synastry Chart
  static Future<SynastryChartResponse?> generateSynastryChart({
    required Map<String, dynamic> profile1,
    required Map<String, dynamic> profile2,
    required List<String> systems,
  }) async {
    try {
      final body = jsonEncode({
        "profile1": profile1,
        "profile2": profile2,
        "system": systems.map((s) => s.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_')).toList(),
        "generate_image": true,
        "save_profile": true,
      });

      Response response = await ApiClient.postData(
        ApiConstant.synastryChart,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SynastryChartResponse.fromJson(response.body);
      } else {
        // Fallback to static data
        debugPrint("Synastry API Error ${response.statusCode}: Returning static fallback data.");
        return _getMockSynastryData(profile1['name'] ?? 'Partner 1', profile2['name'] ?? 'Partner 2', systems);
      }
    } catch (e) {
      debugPrint("Synastry API Exception: $e. Returning static fallback data.");
      return _getMockSynastryData(profile1['name'] ?? 'Partner 1', profile2['name'] ?? 'Partner 2', systems);
    }
  }

  // Static Mock Data for Synastry Fallback
  static SynastryChartResponse _getMockSynastryData(String p1, String p2, List<String> systems) {
    Map<String, SynastryChartData> results = {};
    Map<String, String> images = {};

    for (var system in systems) {
      String key = system.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
      results[key] = SynastryChartData(
        chartId: "mock_synastry_${DateTime.now().millisecondsSinceEpoch}",
        compatibilityScore: 75.0,
        aspects: [],
        interpretation: "This is static fallback interpretation for synastry chart.",
        profile1Name: p1,
        profile2Name: p2,
        system: key,
      );
      images[key] = "assets/images/chartimage.png";
    }

    return SynastryChartResponse(
      results: results,
      images: images,
      message: "Showing static data for demonstration purposes."
    );
  }
}
