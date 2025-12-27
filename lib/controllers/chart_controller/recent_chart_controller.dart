import 'package:get/get.dart';
import '../../Data/services/api_checker.dart';
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../data/models/chart_models/recent_chart_model.dart';

class RecentChartController extends GetxController {
  var recentCharts = <RecentChartModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchRecentCharts() async {
    try {
      isLoading(true);
      final response = await ApiClient.getData(ApiConstant.recentCharts);

      if (response.statusCode == 200) {
        final body = response.body;

        if (body is Map) {
          final List natalData = body['natal'] ?? [];
          final List transitData = body['transit'] ?? [];
          final List synastryData = body['synastry'] ?? [];

          final List<RecentChartModel> allCharts = [];

          allCharts.addAll(
              natalData.map((e) => RecentChartModel.fromJson(e, "Natal")));
          allCharts.addAll(
              transitData.map((e) => RecentChartModel.fromJson(e, "Transit")));
          allCharts.addAll(
              synastryData.map((e) => RecentChartModel.fromJson(e, "Synastry")));

          recentCharts.value = allCharts;
        } else {
          recentCharts.clear();
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
