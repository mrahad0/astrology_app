// lib/views/pages/generateChart/details_chart/mainDetail_chart/mainDetail_chart.dart
import 'package:astrology_app/views/pages/generateChart/details_chart/evolutionary_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/glactic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/humanDesign_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/vedic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/western_datails.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../13sign_details.dart' show Sign13Details;

class MainDetailChart extends StatefulWidget {
  const MainDetailChart({super.key});

  @override
  State<MainDetailChart> createState() => _MainDetailChart();
}

class _MainDetailChart extends State<MainDetailChart> {
  final ChartController controller = Get.find<ChartController>();
  int selected = 0;

  final Map<String, String> systemLabels = {
    'western': 'Western',
    'vedic': 'Vedic',
    '13_sign': '13 Sign',
    'evolutionary': 'Evolutionary',
    'galactic': 'Galactic',
    'human_design': 'Human Design',
  };

  final Map<String, Widget> systemPages = {
    'western': const WesternDatails(),
    'vedic': const VedicDetails(),
    '13_sign': const Sign13Details(),
    'evolutionary': const EvolutionaryDetails(),
    'galactic': const GalacticDetails(),
    'human_design': const HumandesignDetails(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Obx(() {
            List<String> displayedTabs = [];

            if (controller.selectedChartType.value == 'Natal' &&
                controller.natalResponse.value != null) {
              displayedTabs = controller.selectedSystems
                  .map((s) =>
                  s.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_'))
                  .where((key) =>
                  controller.natalResponse.value!.charts.containsKey(key))
                  .toList();
            } else if ((controller.selectedChartType.value == 'Transit' &&
                controller.transitResponse.value != null) ||
                (controller.selectedChartType.value == 'Synastry' &&
                    controller.synastryResponse.value != null)) {
              final data = controller.selectedChartType.value == 'Transit'
                  ? controller.transitResponse.value!.results
                  : controller.synastryResponse.value!.results;

              displayedTabs = controller.selectedSystems
                  .map((s) =>
                  s.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_'))
                  .where((key) => data.containsKey(key))
                  .toList();
            }

            if (displayedTabs.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF9A3BFF)),
              );
            }

            if (selected >= displayedTabs.length) selected = 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Generated Chart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1C3A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: displayedTabs.length == 1
                      ? _buildSingleTab(displayedTabs[0])
                      : _buildMultipleTabs(displayedTabs),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: systemPages[displayedTabs[selected]] ?? const SizedBox.shrink(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSingleTab(String systemKey) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF9A3BFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          systemLabels[systemKey] ?? systemKey,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleTabs(List<String> tabs) {
    // If tabs are 3 or less, use Row with Expanded
    if (tabs.length <= 3) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selected == index;
            final systemKey = tabs[index];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => selected = index);
                },
                child: Container(
                  margin: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF9A3BFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      systemLabels[systemKey] ?? systemKey,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    } else {
      // If more than 3 tabs, make it scrollable
      return SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = selected == index;
              final systemKey = tabs[index];
              return GestureDetector(
                onTap: () {
                  setState(() => selected = index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF9A3BFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      systemLabels[systemKey] ?? systemKey,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}


