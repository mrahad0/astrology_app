// lib/views/pages/generateChart/details_chart/mainDetail_chart/mainDetail_chart.dart
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/evolutionary_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/glactic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/humanDesign_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/vedic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/western_details.dart';
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
    'ophiuchus': '13-Sign',
    'evolutionary': 'Evolutionary',
    'galactic': 'Galactic',
    'human_design': 'Human Design',
  };

  final Map<String, Widget> systemPages = {
    'western': const WesternDetails(),
    'vedic': const VedicDetails(),
    'ophiuchus': const Sign13Details(),
    'evolutionary': const EvolutionaryDetails(),
    'galactic': const GalacticDetails(),
    'human_design': const HumandesignDetails(),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/generateChart_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
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
              return Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF9A3BFF),
                  strokeWidth: ResponsiveHelper.width(4),
                ),
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
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: ResponsiveHelper.iconSize(20),
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.space(10)),
                    Text(
                      "Generated Chart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(20),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.space(30)),
                Container(
                  height: ResponsiveHelper.height(60),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1C3A),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                  ),
                  child: displayedTabs.length == 1
                      ? _buildSingleTab(displayedTabs[0])
                      : _buildMultipleTabs(displayedTabs),
                ),
                SizedBox(height: ResponsiveHelper.space(20)),
                Expanded(
                  child: systemPages[displayedTabs[selected]] ?? const SizedBox.shrink(),
                ),
              ],
            );
          }),
        ),
      ),
     ),
    );
  }

  Widget _buildSingleTab(String systemKey) {
    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.padding(10)),
      decoration: BoxDecoration(
        color: const Color(0xFF9A3BFF),
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
      ),
      child: Center(
        child: Text(
          systemLabels[systemKey] ?? systemKey,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleTabs(List<String> tabs) {
    if (tabs.length <= 3) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
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
                  margin: EdgeInsets.only(right: index < tabs.length - 1 ? ResponsiveHelper.space(8) : 0),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF9A3BFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                  ),
                  child: Center(
                    child: Text(
                      systemLabels[systemKey] ?? systemKey,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
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
      return SizedBox(
        height: ResponsiveHelper.height(60),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tabs.length,
            separatorBuilder: (_, __) => SizedBox(width: ResponsiveHelper.space(8)),
            itemBuilder: (context, index) {
              final isSelected = selected == index;
              final systemKey = tabs[index];
              return GestureDetector(
                onTap: () {
                  setState(() => selected = index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF9A3BFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                  ),
                  child: Center(
                    child: Text(
                      systemLabels[systemKey] ?? systemKey,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
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
