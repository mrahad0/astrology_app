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

      debugPrint('🚀 Natal Chart Request: $body');

      Response response = await ApiClient.postData(
        ApiConstant.natalChart,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Natal Chart Success: ${response.body}');
        return NatalChartResponse.fromJson(response.body);
      } else {
        debugPrint('Natal Chart Error: ${response.statusText}');
        return null;
      }
    } catch (e) {
      debugPrint('Natal Chart Exception: $e');
      return null;
    }
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
        debugPrint('Transit Chart Success: ${response.body}');
        return TransitChartResponse.fromJson(response.body);
      } else {
        debugPrint('Transit Chart Error: ${response.statusText}');
        return null;
      }
    } catch (e) {
      debugPrint('Transit Chart Exception: $e');
      return null;
    }
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

      debugPrint('Synastry Chart Request: $body');

      Response response = await ApiClient.postData(
        ApiConstant.synastryChart,
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Synastry Chart Success: ${response.body}');
        return SynastryChartResponse.fromJson(response.body);
      } else {
        debugPrint('Synastry Chart Error: ${response.statusText}');
        return null;
      }
    } catch (e) {
      debugPrint('Synastry Chart Exception: $e');
      return null;
    }
  }
}