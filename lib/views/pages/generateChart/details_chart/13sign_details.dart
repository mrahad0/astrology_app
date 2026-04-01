// lib/views/pages/generateChart/details_chart/13sign_details.dart
import 'package:astrology_app/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart';
import 'package:astrology_app/controllers/ai_compresive/ai_compresive_controller.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Routes/routes.dart';

class Sign13Details extends StatefulWidget {
  const Sign13Details({super.key});

  @override
  State<Sign13Details> createState() => _Sign13DetailsState();
}

class _Sign13DetailsState extends State<Sign13Details> {
  final ChartController controller = Get.find<ChartController>();

  // Personal planets (Sun through Mars)
  static const List<String> _personalPlanets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars'];
  // Outer planets (Jupiter through Pluto)
  static const List<String> _outerPlanets = ['Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'];

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
          final response = controller.natalResponse.value;

          if (response == null ||
              !response.charts.containsKey('ophiuchus')) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF9A3BFF),
                strokeWidth: ResponsiveHelper.width(4),
              ),
            );
          }

          final sign13 = response.charts['ophiuchus']!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ---------- INFO CARD ----------
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
                      Text(
                        "Info",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(18),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.space(20)),
                      _infoRow("Name:", sign13.name),
                      _infoRow("Date of Birth:", sign13.birthDate),
                      _infoRow("Birth Time:", sign13.birthTime),
                      _infoRow("Time Zone:", sign13.location.timezone.isNotEmpty ? sign13.location.timezone : "N/A"),
                      _infoRow("Birth City:", sign13.location.city.isNotEmpty ? sign13.location.city : "N/A"),
                      _infoRow("Birth Country:", sign13.location.country.isNotEmpty ? sign13.location.country : "N/A"),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---------- CHART IMAGE ----------
                Text(
                  "13-Sign Chart Wheel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(17),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(16)),

                ZoomableChartImage(
                  imageUrl: sign13.imageUrl,
                  height: ResponsiveHelper.height(350),
                ),

                SizedBox(height: ResponsiveHelper.space(8)),
                Center(
                  child: Text(
                    "In the 13-sign system, your placements shift slightly",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: ResponsiveHelper.fontSize(12),
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---------- PLANETARY POSITIONS ----------
                Text(
                  "Planetary Positions :",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(17),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(12)),

                ...sign13.planets.entries
                    .where((e) => _personalPlanets.contains(e.key))
                    .map((entry) {
                  final planet = entry.value;
                  return _planetTile(
                    "${planet.name}:",
                    planet.sign,
                    "in ${_getHouseLabel(planet.house)}",
                  );
                }),

                // Also show other planets not in personal/outer lists
                ...sign13.planets.entries
                    .where((e) => !_personalPlanets.contains(e.key) && !_outerPlanets.contains(e.key))
                    .where((e) => e.key != 'Ascendant' && e.key != 'Midheaven')
                    .map((entry) {
                  final planet = entry.value;
                  return _planetTile(
                    "${planet.name}:",
                    planet.sign,
                    "in ${_getHouseLabel(planet.house)}",
                  );
                }),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---------- OUTER PLANETS KEY ASPECTS ----------
                Text(
                  "Outer Planets Key Aspects :",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(17),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(12)),

                ...sign13.planets.entries
                    .where((e) => _outerPlanets.contains(e.key))
                    .map((entry) {
                  final planet = entry.value;
                  return _planetTile(
                    "${planet.name}:",
                    planet.sign,
                    "in ${_getHouseLabel(planet.house)}",
                  );
                }),

                SizedBox(height: ResponsiveHelper.space(40)),

                /// ---------- GENERATE READING ----------
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

  String _getHouseLabel(dynamic house) {
    if (house == null) return '';
    final h = house.toString();
    switch (h) {
      case '1': return '1st house';
      case '2': return '2nd house';
      case '3': return '3rd house';
      default: return '${h}th house';
    }
  }

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.width(110),
            child: Text(
              key,
              style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planetTile(String planet, String sign, String detail) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$planet ',
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
            TextSpan(
              text: sign,
              style: TextStyle(
                color: CustomColors.primaryColor,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: ' $detail',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
