// lib/views/pages/generateChart/details_chart/evolutionary_details.dart
import 'package:astrology_app/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/ai_compresive/ai_compresive_controller.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/chart_models/natal_chart_model.dart';

class EvolutionaryDetails extends StatefulWidget {
  const EvolutionaryDetails({super.key});

  @override
  State<EvolutionaryDetails> createState() => _EvolutionaryDetailsState();
}

class _EvolutionaryDetailsState extends State<EvolutionaryDetails> {
  final ChartController controller = Get.find<ChartController>();

  // Ordered keys for the grid — displayed as 2-column rows
  static const List<List<String>> _gridRows = [
    ['pluto_sign_house', 'north_node_sign_house'],
    ['south_node', 'pluto_to_node_aspect'],
    ['chiron_sign_house', 'chiron_to_pluto_aspect'],
    ['saturn_sign_house', 'sun_sign'],
    ['moon_sign', 'rising_sign'],
    ['vertex_point', 'part_of_fortune'],
  ];

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
        child: Obx(() {
          NatalChartModel? evolutionaryData;

          if (controller.selectedChartType.value == 'Natal' &&
              controller.natalResponse.value != null) {
            evolutionaryData = controller.natalResponse.value!.charts['evolutionary'];
          }

          if (evolutionaryData == null) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF9A3BFF),
                strokeWidth: ResponsiveHelper.width(4),
              ),
            );
          }

          final grid = evolutionaryData.grid;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- INFO CARD ----
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff262A40)),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                    color: CustomColors.secondbackgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Info",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(18),
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: ResponsiveHelper.space(20)),
                      _infoRow("Name:", evolutionaryData.name),
                      _infoRow("Date of Birth:", evolutionaryData.birthDate),
                      _infoRow("Birth Time:", evolutionaryData.birthTime),
                      _infoRow("Time Zone:", evolutionaryData.location.timezone.isNotEmpty ? evolutionaryData.location.timezone : "N/A"),
                      _infoRow("Birth City:", evolutionaryData.location.city.isNotEmpty ? evolutionaryData.location.city : "N/A"),
                      _infoRow("Birth Country:", evolutionaryData.location.country.isNotEmpty ? evolutionaryData.location.country : "N/A"),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- EVOLUTIONARY POINTS CHART TITLE ----
                Text(
                  "Evolutionary Points Chart",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(17),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: ResponsiveHelper.space(16)),

                /// ---- CHART IMAGE ----
                ZoomableChartImage(
                  imageUrl: evolutionaryData.imageUrl,
                  height: ResponsiveHelper.height(350),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- EVOLUTIONARY POINTS GRID ----
                if (grid.isNotEmpty)
                  ..._gridRows.map((rowKeys) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: _gridCard(grid, rowKeys[0]),
                          ),
                          SizedBox(width: ResponsiveHelper.space(12)),
                          Expanded(
                            child: _gridCard(grid, rowKeys[1]),
                          ),
                        ],
                      ),
                    );
                  }),

                SizedBox(height: ResponsiveHelper.space(40)),

                /// ---- GENERATE READING ----
                Obx(() => CustomButton(
                  text: "Generate Reading",
                  isLoading: controller.isGeneratingInterpretation.value,
                  onpress: () async {
                    controller.isGeneratingInterpretation.value = true;
                    final interpretationController = Get.find<InterpretationController>();
                    final charts = controller.getChartIdsForInterpretation();
                    final info = controller.getChartInfo();
                    await interpretationController.getMultipleInterpretations(charts, info);
                    controller.isGeneratingInterpretation.value = false;
                    Get.toNamed(Routes.aiComprehensive);
                  },
                )),

                SizedBox(height: ResponsiveHelper.space(20)),
              ],
            ),
          );
        }),
      ),
     ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.width(110),
            child: Text(key,
                style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14))),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
          ),
        ],
      ),
    );
  }

  /// Builds a single grid card from the evolutionary `grid` map.
  /// Each entry has: { "label": "...", "sign": "...", "house": "..." (optional) }
  Widget _gridCard(Map<String, dynamic> grid, String key) {
    final entry = grid[key];
    if (entry == null || entry is! Map) {
      return const SizedBox.shrink();
    }

    final data = Map<String, dynamic>.from(entry);
    final label = data['label'] ?? key;
    final sign = data['sign'] ?? '';
    final house = data['house'] ?? '';

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveHelper.fontSize(13),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(8)),
          if (house.isNotEmpty)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: sign,
                    style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: ResponsiveHelper.fontSize(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' $house',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              sign,
              style: TextStyle(
                color: CustomColors.primaryColor,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
