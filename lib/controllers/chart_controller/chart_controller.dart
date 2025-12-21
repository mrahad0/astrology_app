// lib/controllers/chart_controller/chart_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/chart_models/natal_chart_model.dart';
import '../../data/models/chart_models/synastry_chart_model.dart';
import '../../data/models/chart_models/transit_chart_model.dart';
import '../../data/services/chart_service.dart';

class ChartController extends GetxController {
  RxString selectedChartType = ''.obs;
  RxMap<String, dynamic> chartData = <String, dynamic>{}.obs;
  RxList<String> selectedSystems = <String>[].obs;

  // API Response Storage
  Rx<NatalChartResponse?> natalResponse = Rx<NatalChartResponse?>(null);
  Rx<TransitChartResponse?> transitResponse = Rx<TransitChartResponse?>(null);
  Rx<SynastryChartResponse?> synastryResponse = Rx<SynastryChartResponse?>(null);

  // Loading & Error States
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  List<String> get availableSystems {
    if (selectedChartType.value == 'Natal') {
      return ['Western', 'Vedic', '13_sign', 'Evolutionary', 'Galactic', 'Human Design'];
    } else if (selectedChartType.value == 'Transit' || selectedChartType.value == 'Synastry') {
      return ['Western', 'Vedic'];
    }
    return [];
  }

  void setChartType(String type) {
    selectedChartType.value = type;
    selectedSystems.clear();
  }

  void setChartData(Map<String, dynamic> data) {
    chartData.value = data;
  }

  void toggleSystem(String system) {
    if (selectedSystems.contains(system)) {
      selectedSystems.remove(system);
    } else {
      selectedSystems.add(system);
    }
  }

  void clearData() {
    selectedChartType.value = '';
    chartData.clear();
    selectedSystems.clear();
    natalResponse.value = null;
    transitResponse.value = null;
    synastryResponse.value = null;
    errorMessage.value = '';
  }

  // 🚀 Generate Chart API Call
  Future<bool> generateChart() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (selectedChartType.value == 'Natal') {
        return await _generateNatalChart();
      } else if (selectedChartType.value == 'Transit') {
        return await _generateTransitChart();
      } else if (selectedChartType.value == 'Synastry') {
        return await _generateSynastryChart();
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Failed to generate chart: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Generate Natal Chart
  Future<bool> _generateNatalChart() async {
    final date = chartData['dateOfBirth'] as DateTime?;
    final time = chartData['birthTime'] as TimeOfDay?;

    if (date == null || time == null) {
      errorMessage.value = 'Please provide complete birth information';
      return false;
    }

    final response = await ChartService.generateNatalChart(
      name: chartData['name'] ?? '',
      birthDate: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      birthTime: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00',
      birthCity: chartData['birthCity'] ?? '',
      birthCountry: chartData['birthCountry'] ?? '',
      systems: selectedSystems.toList(),
    );

    if (response != null) {
      natalResponse.value = response;
      return true;
    } else {
      errorMessage.value = 'Failed to generate natal chart';
      return false;
    }
  }

  // Generate Transit Chart - FIXED
  Future<bool> _generateTransitChart() async {
    // Transit needs natal birth data + transit date
    final date = chartData['dateOfBirth'] as DateTime?;
    final time = chartData['birthTime'] as TimeOfDay?;
    final futureDate = chartData['futureDate'] as DateTime?;

    if (date == null || time == null || futureDate == null) {
      errorMessage.value = 'Please provide complete information';
      return false;
    }

    final response = await ChartService.generateTransitChart(
      name: chartData['name'] ?? 'User',
      birthDate: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      birthTime: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00',
      birthCity: chartData['birthCity'] ?? '',
      birthCountry: chartData['birthCountry'] ?? '',
      transitDate: '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}',
      systems: selectedSystems.toList(),
    );

    if (response != null) {
      transitResponse.value = response;
      return true;
    } else {
      errorMessage.value = 'Failed to generate transit chart';
      return false;
    }
  }

  // Generate Synastry Chart - FIXED
  Future<bool> _generateSynastryChart() async {
    final partner1 = chartData['partner1'] as Map<String, dynamic>?;
    final partner2 = chartData['partner2'] as Map<String, dynamic>?;

    if (partner1 == null || partner2 == null) {
      errorMessage.value = 'Please provide complete information for both partners';
      return false;
    }

    final date1 = partner1['dateOfBirth'] as DateTime?;
    final time1 = partner1['birthTime'] as TimeOfDay?;
    final date2 = partner2['dateOfBirth'] as DateTime?;
    final time2 = partner2['birthTime'] as TimeOfDay?;

    if (date1 == null || time1 == null || date2 == null || time2 == null) {
      errorMessage.value = 'Please provide complete birth information for both partners';
      return false;
    }

    final profile1Data = {
      "name": partner1['name'] ?? '',
      "birth_date": '${date1.year}-${date1.month.toString().padLeft(2, '0')}-${date1.day.toString().padLeft(2, '0')}',
      "birth_time": '${time1.hour.toString().padLeft(2, '0')}:${time1.minute.toString().padLeft(2, '0')}:00',
      "birth_city": partner1['birthCity'] ?? '',
      "birth_country": partner1['birthCountry'] ?? '',
    };

    final profile2Data = {
      "name": partner2['name'] ?? '',
      "birth_date": '${date2.year}-${date2.month.toString().padLeft(2, '0')}-${date2.day.toString().padLeft(2, '0')}',
      "birth_time": '${time2.hour.toString().padLeft(2, '0')}:${time2.minute.toString().padLeft(2, '0')}:00',
      "birth_city": partner2['birthCity'] ?? '',
      "birth_country": partner2['birthCountry'] ?? '',
    };

    final response = await ChartService.generateSynastryChart(
      profile1: profile1Data,
      profile2: profile2Data,
      systems: selectedSystems.toList(),
    );

    if (response != null) {
      synastryResponse.value = response;
      return true;
    } else {
      errorMessage.value = 'Failed to generate synastry chart';
      return false;
    }
  }
}