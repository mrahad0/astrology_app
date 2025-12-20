// chart_controller.dart
import 'package:get/get.dart';

class ChartController extends GetxController {
  RxString selectedChartType = ''.obs;
  RxMap<String, dynamic> chartData = <String, dynamic>{}.obs;
  RxList<String> selectedSystems = <String>[].obs;

  List<String> get availableSystems {
    if (selectedChartType.value == 'Natal') {
      return ['Western', 'Vedic', '13-Signs', 'Evolutionary', 'Galactic', 'Human Design'];
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
  }
}