import 'package:get/get.dart';
import '../../data/models/chart_models/saved_chart_model.dart';
import '../../data/services/api_checker.dart';
import '../../data/services/api_client.dart';
import '../../data/services/api_constant.dart';

class SavedChartController extends GetxController {
  var savedCharts = <SavedChartModel>[].obs;
  var isLoading = false.obs;

  // Pagination variables
  var currentPage = 1.obs;
  final int itemsPerPage = 10;

  /// Returns the total number of pages based on the total charts and items per page
  int get totalPages => (savedCharts.length / itemsPerPage).ceil();

  /// Returns the list of charts for the current page
  List<SavedChartModel> get paginatedCharts {
    if (savedCharts.isEmpty) return [];
    
    final startIndex = (currentPage.value - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    
    if (startIndex >= savedCharts.length) return [];
    
    return savedCharts.sublist(
      startIndex,
      endIndex > savedCharts.length ? savedCharts.length : endIndex,
    );
  }

  /// Changes to the specified page
  void changePage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
    }
  }

  Future<void> fetchSavedCharts() async {
    try {
      isLoading.value = true;
      currentPage.value = 1; // Reset to first page on fetch

      final response = await ApiClient.getData(ApiConstant.oldSavedCharts);
      ApiChecker.checkApi(response);

      List<SavedChartModel> charts = [];

      if (response.statusCode == 200 && response.body is Map) {
        final body = response.body as Map<String, dynamic>;

        // Natal charts
        if (body['natal'] != null && body['natal'] is List) {
          charts.addAll((body['natal'] as List)
              .map((e) => SavedChartModel.fromJson(Map<String, dynamic>.from(e as Map), "Natal"))
              .toList());
        }

        // Transit charts - check both 'transit' and 'transits' keys
        final transitList = body['transit'] ?? body['transits'];
        if (transitList != null && transitList is List) {
          charts.addAll(transitList
              .map((e) => SavedChartModel.fromJson(Map<String, dynamic>.from(e as Map), "Transit"))
              .toList());
        }

        // Synastry charts
        if (body['synastry'] != null && body['synastry'] is List) {
          charts.addAll((body['synastry'] as List)
              .map((e) => SavedChartModel.fromJson(Map<String, dynamic>.from(e as Map), "Synastry"))
              .toList());
        }
      }

      savedCharts.assignAll(charts);
    } finally {
      isLoading.value = false;
    }
  }
}
