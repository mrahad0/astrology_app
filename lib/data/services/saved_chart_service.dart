import '../models/chart_models/saved_chart_model.dart';
import 'api_checker.dart';
import 'api_client.dart';
import 'api_constant.dart';

class SavedChartRepository {
  static Future<List<SavedChartModel>> getSavedCharts() async {
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
    return charts;
  }
}
