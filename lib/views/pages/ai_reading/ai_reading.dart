import 'package:astrology_app/routes/routes.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/views/pages/ai_reading/saved_charts_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chart_models/recent_chart_model.dart';
import 'package:astrology_app/controllers/chart_controller/recent_chart_controller.dart';

import '../../../utils/color.dart';

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

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is Map) {
      showBackButton = Get.arguments['showBackButton'] ?? false;
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }


          List<RecentChartModel> filteredCharts;
          if (selectedFilter.value == 0) {
            filteredCharts = controller.recentCharts;
          } else {
            final filterName = filters[selectedFilter.value];
            filteredCharts = controller.recentCharts
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

          return SingleChildScrollView(
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

                // ------------------ CHART LIST OR EMPTY STATE ---------------------
                if (filteredCharts.isEmpty)
                  Center(
                    child: Text(
                      selectedFilter.value == 0
                          ? "No charts found"
                          : "${filters[selectedFilter.value]} – No charts",
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
                        child: chartCard(
                          type: "${chart.chartCategory} (${chart.systemType})",
                          name: chart.name,
                          date: chart.date,
                          location: "${chart.city}, ${chart.country}",
                        ),
                      );
                    }).toList(),
                  ),

                SizedBox(height: MediaQuery.of(context).size.height / 6),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------------- CARD WIDGET ------------------------
  Widget chartCard({
    required String type,
    required String name,
    required String date,
    required String location,
  }) {
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
            type,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 18),
          CustomButton(
            text: "View",
            onpress: () => Get.to(SavedChartsDetails()),
          ),
        ],
      ),
    );
  }
}