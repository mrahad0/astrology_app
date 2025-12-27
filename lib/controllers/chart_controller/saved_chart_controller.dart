import 'package:get/get.dart';

import '../../data/models/chart_models/saved_chart_model.dart';
import '../../data/services/saved_chart_service.dart';

class SavedChartController extends GetxController {
  var savedCharts = <SavedChartModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchSavedCharts() async {
    try {
      isLoading.value = true;
      final charts = await SavedChartRepository.getSavedCharts();
      savedCharts.assignAll(charts);
    } finally {
      isLoading.value = false;
    }
  }
}
