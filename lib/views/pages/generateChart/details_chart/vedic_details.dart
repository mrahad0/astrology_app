// lib/views/pages/generateChart/details_chart/vedic_details.dart
import 'package:astrology_app/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/ai_compresive/ai_compresive_controller.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/chart_models/transit_chart_model.dart';


class VedicDetails extends StatefulWidget {
  const VedicDetails({super.key});

  @override
  State<VedicDetails> createState() => _VedicDetailsState();
}

class _VedicDetailsState extends State<VedicDetails> {
  final ChartController controller = Get.find<ChartController>();

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
          // Check which chart type is selected
          if (controller.selectedChartType.value == 'Natal') {
            return _buildNatalChart();
          } else if (controller.selectedChartType.value == 'Transit') {
            return _buildTransitChart();
          } else if (controller.selectedChartType.value == 'Synastry') {
            return _buildSynastryChart();
          }
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(16)),
            ),
          );
        }),
      ),
     ),
    );
  }

  // ==================== NATAL CHART ====================
  Widget _buildNatalChart() {
    final vedicData = controller.natalResponse.value?.charts['vedic'];

    if (vedicData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF9A3BFF),
          strokeWidth: ResponsiveHelper.width(4),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Info Card
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
                _infoRow("Name:", vedicData.name),
                _infoRow("Date of Birth:", vedicData.birthDate),
                _infoRow("Birth Time:", vedicData.birthTime),
                _infoRow("Time Zone:", vedicData.location.timezone.isNotEmpty ? vedicData.location.timezone : "N/A"),
                _infoRow("Birth City:", vedicData.location.city.isNotEmpty ? vedicData.location.city : "N/A"),
                _infoRow("Birth Country:", vedicData.location.country.isNotEmpty ? vedicData.location.country : "N/A"),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Vedic Chart Wheel Title
          Text(
            "Vedic Chart Wheel",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          /// Chart Image
          ZoomableChartImage(
            imageUrl: vedicData.imageUrl,
            height: ResponsiveHelper.height(350),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ——— Sidereal planetary positions ———
          Text(
            "Sidereal planetary positions :",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          if (vedicData.siderealPlanetaryPositions.isNotEmpty)
            ...vedicData.siderealPlanetaryPositions.map((pos) {
              final displayName = pos['display_name'] ?? pos['planet'] ?? '';
              final sign = pos['sign'] ?? '';
              final houseLabel = pos['house_label'] ?? 'house ${pos['house'] ?? ''}';
              return _siderealTile(
                "$displayName:",
                sign,
                "in $houseLabel",
              );
            })
          else
            ...vedicData.planets.entries.take(10).map((entry) {
              final planet = entry.value;
              return _siderealTile(
                "${planet.name}:",
                planet.sign,
                "in ${planet.house}",
              );
            }),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ——— Lifepath indicator ———
          Text(
            "Lifepath indicator:",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          if (vedicData.lifepathIndicator.isNotEmpty)
            ...vedicData.lifepathIndicator.entries.map((entry) {
              final data = entry.value is Map ? entry.value as Map<String, dynamic> : {};
              final label = data['label'] ?? entry.key;
              final sign = data['sign'] ?? '';
              final nakshatra = data['nakshatra'] ?? '';
              return _siderealTile(
                "$label:",
                sign,
                "in $nakshatra",
              );
            }),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ——— Lunar System ———
          Text(
            "Lunar System :",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          if (vedicData.lunarSystem.isNotEmpty)
            ...vedicData.lunarSystem.entries.map((entry) {
              final data = entry.value is Map ? entry.value as Map<String, dynamic> : {};
              final label = data['label'] ?? entry.key;

              // Handle "Current Dasha" which has planet + remaining instead of sign + nakshatra
              if (data.containsKey('planet')) {
                final planet = data['planet'] ?? '';
                final remaining = data['remaining'] ?? '';
                return _lunarDashaTile(label, planet, remaining);
              }

              final sign = data['sign'] ?? '';
              final nakshatra = data['nakshatra'] ?? '';
              final pada = data['pada'];

              return _lunarTile(label, sign, nakshatra, pada);
            }),

          SizedBox(height: ResponsiveHelper.space(40)),

          /// Generate Reading Button
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
  }

  // ==================== TRANSIT CHART ====================
  Widget _buildTransitChart() {
    final transitData = controller.transitResponse.value?.results['vedic'];

    if (transitData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF9A3BFF),
          strokeWidth: ResponsiveHelper.width(4),
        ),
      );
    }

    final imageUrl = controller.transitResponse.value?.images['vedic'] ?? '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  Center(
                    child: Text(
                      "About Vedic Chart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.space(10)),
                  Text(
                    "Based on the actual positions of the stars in the sky. Your sign may shift back by one. More focused on karma, fate, and life events.This means you might be a Leo in Western but a Cancer in Vedic – same birthday, different systems.",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                  ),
                ]
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Info Card
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
                  "Vedic Transit Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Name:", transitData.profileName),
                _infoRow("Transit Date:", transitData.transitDate),
                _infoRow("Quality:", transitData.overallQuality),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Chart Image
          Text(
            "Vedic Transit Chart",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          ZoomableChartImage(
            imageUrl: imageUrl,
            height: ResponsiveHelper.height(350),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),

          /// Gochara (Active Transits)
          Text(
            "Gochara (Active Transits)",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          if (transitData.transits.isEmpty)
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
              decoration: BoxDecoration(
                color: CustomColors.secondbackgroundColor,
                borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
                border: Border.all(color: const Color(0xff2B2F45)),
              ),
              child: Text(
                "No significant transits at this time",
                style: TextStyle(color: Colors.white70, fontSize: ResponsiveHelper.fontSize(14)),
              ),
            )
          else
            ...transitData.transits.map((transit) {
              return _transitTile(transit);
            }),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Interpretation
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
                  "Interpretation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(12)),
                Text(
                  transitData.interpretation,
                  style: TextStyle(color: Colors.white70, fontSize: ResponsiveHelper.fontSize(14)),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(40)),

          Obx(() => CustomButton(
            text: "Generate",
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
  }

  // ==================== SYNASTRY CHART ====================
  Widget _buildSynastryChart() {
    final synastryData = controller.synastryResponse.value?.results['vedic'];

    if (synastryData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF9A3BFF),
          strokeWidth: ResponsiveHelper.width(4),
        ),
      );
    }

    final imageUrl = controller.synastryResponse.value?.images['vedic'] ?? '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  Center(
                    child: Text(
                      "About Vedic Chart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.space(10)),
                  Text(
                    "Based on the actual positions of the stars in the sky. Your sign may shift back by one. More focused on karma, fate, and life events.This means you might be a Leo in Western but a Cancer in Vedic – same birthday, different systems.",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                  ),
                ]
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          /// Info Card
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
                  "Vedic Synastry Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Partner 1:", synastryData.profile1Name),
                _infoRow("Partner 2:", synastryData.profile2Name),
                _infoRow("Compatibility:", "${synastryData.compatibilityScore.toStringAsFixed(1)}%"),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Chart Image
          Text(
            "Vedic Synastry Chart",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          ZoomableChartImage(
            imageUrl: imageUrl,
            height: ResponsiveHelper.height(350),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),

          /// Relationship Aspects
          Text(
            "Relationship Aspects",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          ...synastryData.aspects.take(10).map((aspect) {
            return _aspectTile(
              "${aspect.point1} ${aspect.aspect} ${aspect.point2}",
              "orb: ${aspect.orb.toStringAsFixed(1)}°",
            );
          }),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Interpretation
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
                  "Interpretation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(12)),
                Text(
                  synastryData.interpretation,
                  style: TextStyle(color: Colors.white70, fontSize: ResponsiveHelper.fontSize(14)),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(40)),

          Obx(() => CustomButton(
            text: "Generate",
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
  }

  // ==================== HELPER WIDGETS ====================

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

  Widget _siderealTile(String planet, String sign, String detail) {
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

  Widget _aspectTile(String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xffFF6B9D),
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white70, fontSize: ResponsiveHelper.fontSize(14)),
          ),
        ],
      ),
    );
  }

  Widget _transitTile(TransitModel transit) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${transit.planet} ${transit.aspect}",
                style: TextStyle(
                  color: const Color(0xffFF6B9D),
                  fontSize: ResponsiveHelper.fontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "orb: ${transit.orb.toStringAsFixed(1)}°",
                style: TextStyle(color: Colors.white70, fontSize: ResponsiveHelper.fontSize(12)),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(8)),
          Text(
            "Natal: ${transit.natalPosition} → Transit: ${transit.transitPosition}",
            style: TextStyle(color: const Color(0xffA4A9C1), fontSize: ResponsiveHelper.fontSize(13)),
          ),
          SizedBox(height: ResponsiveHelper.space(6)),
          Text(
            transit.interpretation,
            style: TextStyle(color: Colors.white70, fontSize: ResponsiveHelper.fontSize(13)),
          ),
        ],
      ),
    );
  }

  /// Lunar system tile — label, purple sign, nakshatra
  Widget _lunarTile(String label, String sign, String nakshatra, dynamic pada) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
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
          SizedBox(height: ResponsiveHelper.space(4)),
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
                  text: ' in $nakshatra',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Current Dasha tile — label, purple planet name, remaining text
  Widget _lunarDashaTile(String label, String planet, String remaining) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
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
          SizedBox(height: ResponsiveHelper.space(4)),
          Text(
            planet,
            style: TextStyle(
              color: CustomColors.primaryColor,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (remaining.isNotEmpty)
            Text(
              remaining,
              style: TextStyle(
                color: Colors.white70,
                fontSize: ResponsiveHelper.fontSize(12),
              ),
            ),
        ],
      ),
    );
  }
}
