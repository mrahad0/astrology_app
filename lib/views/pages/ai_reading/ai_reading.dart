import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/pages/ai_reading/saved_charts_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/ai_compresive/ai_compresive_controller.dart';
import '../../../data/models/chart_models/recent_chart_model.dart';
import 'package:astrology_app/controllers/chart_controller/recent_chart_controller.dart';

import '../../../utils/color.dart';
import 'ai_comprehensive.dart';

class AiReadingScreen extends StatefulWidget {
  const AiReadingScreen({super.key});

  @override
  State<AiReadingScreen> createState() => _AiReadingScreenState();
}

class _AiReadingScreenState extends State<AiReadingScreen> {
  bool showBackButton = false;
  final selectedFilter = 0.obs;

  final List<String> filters = [
    "All",
    "Western",
    "Vedic",
    "13-Signs",
    "Evolutionary",
    "Galactic",
    "Human Design Profile",
  ];

  final RecentChartController controller = Get.put(RecentChartController());
  InterpretationController? interpretationController;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is Map) {
      showBackButton = Get.arguments['showBackButton'] ?? false;
    }

    // Try to get existing InterpretationController if available
    if (Get.isRegistered<InterpretationController>()) {
      interpretationController = Get.find<InterpretationController>();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchRecentCharts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        )
            : null,
        title: const Text(
          "Reading",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.fetchRecentCharts(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Only show charts that have interpretations generated
          final chartsWithInterpretation = controller.recentCharts
              .where((chart) => chart.interpretation.isNotEmpty)
              .toList();

          List<RecentChartModel> filteredCharts;
          if (selectedFilter.value == 0) {
            filteredCharts = chartsWithInterpretation;
          } else {
            final filterName = filters[selectedFilter.value];
            filteredCharts = chartsWithInterpretation
                .where(
                  (chart) =>
              chart.chartCategory.toLowerCase().contains(
                filterName.toLowerCase(),
              ) ||
                  chart.systemType.toLowerCase().contains(
                    filterName.toLowerCase(),
                  ),
            )
                .toList();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchRecentCharts();
              // Also refresh interpretation controller if available
              if (Get.isRegistered<InterpretationController>()) {
                interpretationController = Get.find<InterpretationController>();
                setState(() {});
              }
            },
            color: Colors.purple,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your chart collection",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 20),

                // ------------------ FILTER BUTTONS ---------------------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(filters.length, (index) {
                      bool isSelected = selectedFilter.value == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => selectedFilter.value = index,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.purple
                                  : CustomColors.secondbackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.purple
                                    : const Color(0xff2A2F45),
                              ),
                            ),
                            child: Text(
                              filters[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 22),

                // ------------------ CURRENT SESSION INTERPRETATIONS ---------------------
                if (interpretationController != null &&
                    interpretationController!.interpretations.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Current Session",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _currentSessionCard(),
                      const SizedBox(height: 24),
                      const Text(
                        "Saved Readings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // ------------------ CHART LIST OR EMPTY STATE ---------------------
                if (filteredCharts.isEmpty)
                  Center(
                    child: Text(
                      selectedFilter.value == 0
                          ? "No chart interpretations generated yet"
                          : "${filters[selectedFilter.value]} – No interpretations",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  Column(
                    children: filteredCharts.map((chart) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _chartCard(chart: chart),
                      );
                    }).toList(),
                  ),

                SizedBox(height: MediaQuery.of(context).size.height / 6),
              ],
            ),
          ),
          );
        }),
      ),
    );
  }

  // ---------------------- CURRENT SESSION CARD ------------------------
  Widget _currentSessionCard() {
    final interp = interpretationController!;
    final systems = interp.interpretations
        .map((i) => _capitalizeSystem(i.system ?? 'Unknown'))
        .join(', ');
    final chartType = interp.interpretations.isNotEmpty
        ? _capitalize(interp.interpretations.first.chartType ?? 'Chart')
        : 'Chart';
    final userInfo = interp.userInfo;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$chartType ($systems)",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userInfo['name'] ?? 'Generated Reading',
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          Text(
            "${interp.interpretations.length} system(s) generated",
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          const Text(
            "Not saved yet",
            style: TextStyle(fontSize: 12, color: Colors.orange),
          ),
          const SizedBox(height: 18),
          CustomButton(
            text: "View",
            onpress: () {
              Get.to(() => const AiComprehensive());
            },
          ),
        ],
      ),
    );
  }

  // Helper to capitalize first letter
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Helper to capitalize system names
  String _capitalizeSystem(String system) {
    switch (system.toLowerCase()) {
      case 'western':
        return 'Western';
      case 'vedic':
        return 'Vedic';
      case '13_sign':
        return '13-Sign';
      case 'evolutionary':
        return 'Evolutionary';
      case 'galactic':
        return 'Galactic';
      case 'human_design':
        return 'Human Design';
      default:
        return _capitalize(system);
    }
  }

  // ---------------------- CARD WIDGET ------------------------
  Widget _chartCard({required RecentChartModel chart}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${chart.chartCategory} (${chart.systemDisplayName})",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            chart.name,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          Text(
            chart.date,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          Text(
            "${chart.city}, ${chart.country}",
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 18),
          CustomButton(
            text: "View",
            onpress: () {
              Get.to(() => SavedChartsDetails(recentChart: chart));
            },
          ),
        ],
      ),
    );
  }
}
