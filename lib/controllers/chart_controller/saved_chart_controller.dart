import 'package:get/get.dart';
import '../../data/models/chart_models/saved_chart_model.dart';
import '../../data/services/api_checker.dart';
import '../../data/services/api_client.dart';
import '../../data/services/api_constant.dart';

class SavedChartController extends GetxController {
  var savedCharts = <SavedChartModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchSavedCharts() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.getData(ApiConstant.oldSavedCharts);
      ApiChecker.checkApi(response);

      List<SavedChartModel> charts = [];

      if (response.statusCode == 200 && response.body is Map) {
        final body = response.body as Map<String, dynamic>;

        // Natal charts
        if (body['natal'] != null && body['natal'] is List) {
          charts.addAll((body['natal'] as List)
              .map((e) => SavedChartModel.fromJson(e, "Natal"))
              .toList());
        }

        // Transit charts
        if (body['transit'] != null && body['transit'] is List) {
          charts.addAll((body['transit'] as List)
              .map((e) => SavedChartModel.fromJson(e, "Transit"))
              .toList());
        }

        // Synastry charts
        if (body['synastry'] != null && body['synastry'] is List) {
          charts.addAll((body['synastry'] as List)
              .map((e) => SavedChartModel.fromJson(e, "Synastry"))
              .toList());
        }
      }

      savedCharts.assignAll(charts);
    } finally {
      isLoading.value = false;
    }
  }
}
