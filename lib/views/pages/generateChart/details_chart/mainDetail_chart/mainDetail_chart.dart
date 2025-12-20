// main_detail_chart.dart
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

  Map<String, String> systemLabels = {
    'Western': 'Western',
    'Vedic': 'Vedic',
    '13-Signs': '13-Signs',
    'Evolutionary': 'Evolutionary',
    'Galactic': 'Galactic',
    'Human Design': 'Human Design',
  };

  Map<String, Widget> systemPages = {
    'Western': const WesternDatails(),
    'Vedic': const VedicDetails(),
    '13-Signs': const Sign13Details(),
    'Evolutionary': const EvolutionaryDetails(),
    'Galactic': const GalacticDetails(),
    'Human Design': const HumandesignDetails(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                final selectedSystemsList = controller.selectedSystems;

                if (selectedSystemsList.isEmpty) {
                  return Center(
                    child: Text(
                      "No systems selected",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final displayedTabs = selectedSystemsList
                    .where((s) => systemLabels.containsKey(s))
                    .toList();

                if (selected >= displayedTabs.length) {
                  selected = 0;
                }

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
        ],
      ),
    );
  }

  // Single Tab - Fills entire width
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

  // Multiple Tabs - Equally distributed
  Widget _buildMultipleTabs(List<String> tabs) {
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
                margin: EdgeInsets.only(
                  right: index < tabs.length - 1 ? 8 : 0,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF9A3BFF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    systemLabels[systemKey] ?? systemKey,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: tabs.length > 3 ? 14 : 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}



