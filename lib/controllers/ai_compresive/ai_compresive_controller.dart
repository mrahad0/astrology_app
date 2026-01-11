import 'dart:convert';
import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:get/get.dart';
import '../../Data/services/api_checker.dart';
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../data/models/ai_compresive/ai_interpretation_model.dart';

class InterpretationController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  void setDownloading(bool value) {
    _isDownloading = value;
    update();
  }

  InterpretationModel? _interpretationData;
  InterpretationModel? get interpretationData => _interpretationData;

  Map<String, dynamic> userInfo = {};

  List<Map<String, String>> chartDataForSaving = [];

  List<InterpretationModel> interpretations = [];

  Future<void> getAiInterpretation(Map<String, dynamic> body) async {
    _isLoading = true;
    _interpretationData = null;
    update();

    Response response = await ApiClient.postData(
      ApiConstant.interpret,
      jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _interpretationData = InterpretationModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  /// Fetches AI interpretations for multiple charts/systems
  Future<void> getMultipleInterpretations(
    List<Map<String, String>> charts,
    Map<String, dynamic> info,
  ) async {
    userInfo = info;
    chartDataForSaving = charts;
    interpretations.clear();
    _isLoading = true;
    update();

    for (var chart in charts) {
      Response response = await ApiClient.postData(
        ApiConstant.interpret,
        jsonEncode(chart),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        interpretations.add(InterpretationModel.fromJson(response.body));
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoading = false;
    update();
  }

  /// Saves all chart interpretations to the backend
  Future<bool> saveCharts() async {
    if (interpretations.isEmpty) {
      showCustomSnackBar("No charts to save");
      return false;
    }

    _isSaving = true;
    update();

    // Build the request body from interpretations
    List<Map<String, dynamic>> chartsToSave = [];
    for (var interpretation in interpretations) {
      chartsToSave.add({
        "chart_type": interpretation.chartType ?? "",
        "chart_id": interpretation.chartId ?? "",
        "system": interpretation.system ?? "",
      });
    }

    Response response = await ApiClient.postData(
      ApiConstant.saveCharts,
      jsonEncode(chartsToSave),
    );

    _isSaving = false;
    update();

    if (response.statusCode == 200 || response.statusCode == 201) {
      showCustomSnackBar("Charts saved successfully!", isError: false);
      return true;
    } else {
      ApiChecker.checkApi(response);
      return false;
    }
  }

  /// Clears all stored data
  void clearData() {
    userInfo.clear();
    chartDataForSaving.clear();
    interpretations.clear();
    _interpretationData = null;
    update();
  }
}