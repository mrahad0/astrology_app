// lib/controllers/chart_controller/chart_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  // 🔧 Helper: Format Date Consistently
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // 🔧 Helper: Format Time Consistently
  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
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
      print('❌ Chart Generation Error: $e');
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

    print('📅 Natal Birth Date: ${_formatDate(date)}');
    print('⏰ Natal Birth Time: ${_formatTime(time)}');

    final response = await ChartService.generateNatalChart(
      name: chartData['name'] ?? 'User',
      birthDate: _formatDate(date),
      birthTime: _formatTime(time),
      birthCity: chartData['birthCity'] ?? '',
      birthCountry: chartData['birthCountry'] ?? '',
      systems: selectedSystems.toList(),
    );

    if (response != null) {
      natalResponse.value = response;
      print('✅ Natal Chart Generated Successfully');
      return true;
    } else {
      errorMessage.value = 'Failed to generate natal chart';
      return false;
    }
  }

  // Generate Transit Chart - FIXED DATE HANDLING
  Future<bool> _generateTransitChart() async {
    final birthDate = chartData['dateOfBirth'] as DateTime?;
    final birthTime = chartData['birthTime'] as TimeOfDay?;
    final futureDate = chartData['futureDate'] as DateTime?;

    // ✅ Validation
    if (birthDate == null || birthTime == null) {
      errorMessage.value = 'Please provide birth information';
      return false;
    }

    if (futureDate == null) {
      errorMessage.value = 'Please provide transit date';
      return false;
    }

    // ✅ Check if transit date is valid (can be past or future)
    // Transit date should not be before birth date
    if (futureDate.isBefore(birthDate)) {
      errorMessage.value = 'Transit date cannot be before birth date';
      return false;
    }

    final formattedBirthDate = _formatDate(birthDate);
    final formattedBirthTime = _formatTime(birthTime);
    final formattedTransitDate = _formatDate(futureDate);

    print('📅 Transit Birth Date: $formattedBirthDate');
    print('⏰ Transit Birth Time: $formattedBirthTime');
    print('📅 Transit Date: $formattedTransitDate');

    // ✅ Verify dates are correct
    final birthDateTime = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final transitDateTime = DateTime(futureDate.year, futureDate.month, futureDate.day);

    print('🔍 Birth: $birthDateTime');
    print('🔍 Transit: $transitDateTime');
    print('🔍 Days difference: ${transitDateTime.difference(birthDateTime).inDays}');

    final response = await ChartService.generateTransitChart(
      name: chartData['name'] ?? 'User',
      birthDate: formattedBirthDate,
      birthTime: formattedBirthTime,
      birthCity: chartData['birthCity'] ?? '',
      birthCountry: chartData['birthCountry'] ?? '',
      transitDate: formattedTransitDate,
      systems: selectedSystems.toList(),
    );

    if (response != null) {
      transitResponse.value = response;
      print('✅ Transit Chart Generated Successfully');
      return true;
    } else {
      errorMessage.value = 'Failed to generate transit chart';
      print('❌ Transit Chart Generation Failed');
      return false;
    }
  }

  // Generate Synastry Chart - FIXED DATE HANDLING
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

    print('📅 Partner 1 Birth Date: ${_formatDate(date1)}');
    print('⏰ Partner 1 Birth Time: ${_formatTime(time1)}');
    print('📅 Partner 2 Birth Date: ${_formatDate(date2)}');
    print('⏰ Partner 2 Birth Time: ${_formatTime(time2)}');

    final profile1Data = {
      "name": partner1['name'] ?? 'Partner 1',
      "birth_date": _formatDate(date1),
      "birth_time": _formatTime(time1),
      "birth_city": partner1['birthCity'] ?? '',
      "birth_country": partner1['birthCountry'] ?? '',
    };

    final profile2Data = {
      "name": partner2['name'] ?? 'Partner 2',
      "birth_date": _formatDate(date2),
      "birth_time": _formatTime(time2),
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
      print('✅ Synastry Chart Generated Successfully');
      return true;
    } else {
      errorMessage.value = 'Failed to generate synastry chart';
      print('❌ Synastry Chart Generation Failed');
      return false;
    }
  }
}