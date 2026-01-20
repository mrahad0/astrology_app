import 'package:astrology_app/views/base/custom_snackBar.dart';
import 'package:get/get.dart';
import '../../Data/services/api_checker.dart';
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../data/models/chart_models/recent_chart_model.dart';

class RecentChartController extends GetxController {
  var recentCharts = <RecentChartModel>[].obs;
  var isLoading = false.obs;

  // Pagination variables
  var currentPage = 1.obs;
  final int itemsPerPage = 10;

  /// Returns the total number of pages based on the total charts and items per page
  int get totalPages => (recentCharts.length / itemsPerPage).ceil();

  /// Returns the list of charts for the current page
  List<RecentChartModel> get paginatedCharts {
    if (recentCharts.isEmpty) return [];
    
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    
    if (startIndex >= recentCharts.length) return [];
    
    return recentCharts.sublist(
      startIndex,
      endIndex > recentCharts.length ? recentCharts.length : endIndex,
    );
  }

  /// Changes to the specified page
  void changePage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
    }
  }

  Future<void> fetchRecentCharts() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset to first page on fetch
      final response = await ApiClient.getData(ApiConstant.recentCharts);

      if (response.statusCode == 200) {
        final body = response.body;

        if (body is Map) {
          final List natalData = body['natal'] ?? [];
          // Check both 'transit' and 'transits' keys
          final List transitData = body['transit'] ?? body['transits'] ?? [];
          final List synastryData = body['synastry'] ?? [];

          final List<RecentChartModel> allCharts = [];

          allCharts.addAll(
              natalData.map((e) => RecentChartModel.fromJson(Map<String, dynamic>.from(e as Map), "Natal")));
          allCharts.addAll(
              transitData.map((e) => RecentChartModel.fromJson(Map<String, dynamic>.from(e as Map), "Transit")));
          allCharts.addAll(
              synastryData.map((e) => RecentChartModel.fromJson(Map<String, dynamic>.from(e as Map), "Synastry")));

          recentCharts.value = allCharts;
        } else {
          recentCharts.clear();
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
