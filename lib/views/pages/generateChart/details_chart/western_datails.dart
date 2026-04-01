// lib/views/pages/generateChart/details_chart/western_datails.dart
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

class WesternDatails extends StatefulWidget {
  const WesternDatails({super.key});

  @override
  State<WesternDatails> createState() => _WesternDatailsState();
}

class _WesternDatailsState extends State<WesternDatails> {
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

  // Personal planets list (Sun through Mars)
  static const List<String> _personalPlanets = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars'];
  // Outer planets list (Jupiter through Pluto)
  static const List<String> _outerPlanets = ['Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'];

  // Color mapping for zodiac signs
  Color _getSignColor(String sign) {
    switch (sign.toLowerCase()) {
      case 'aries':
        return const Color(0xFFFF4D4D);
      case 'taurus':
        return const Color(0xFF4CAF50);
      case 'gemini':
        return const Color(0xFFFFEB3B);
      case 'cancer':
        return const Color(0xFF42A5F5);
      case 'leo':
        return const Color(0xFFFF9800);
      case 'virgo':
        return const Color(0xFF8BC34A);
      case 'libra':
        return const Color(0xFFE91E63);
      case 'scorpio':
        return const Color(0xFF9C27B0);
      case 'sagittarius':
        return const Color(0xFFFF5722);
      case 'capricorn':
        return const Color(0xFF795548);
      case 'aquarius':
        return const Color(0xFF00BCD4);
      case 'pisces':
        return const Color(0xFF3F51B5);
      default:
        return const Color(0xFF9726f2);
    }
  }

  Widget _buildNatalChart() {
    final westernData = controller.natalResponse.value?.charts['western'];

    if (westernData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF9A3BFF),
          strokeWidth: ResponsiveHelper.width(4),
        ),
      );
    }

    // Extract personal planets from the planets map
    final personalPlanetEntries = westernData.planets.entries
        .where((e) => _personalPlanets.contains(e.key))
        .toList();

    // Extract outer planets from the planets map
    final outerPlanetEntries = westernData.planets.entries
        .where((e) => _outerPlanets.contains(e.key))
        .toList();

    // Get personal planet aspects (where point1 is a personal planet)
    final personalAspects = westernData.aspects
        .where((a) => _personalPlanets.contains(a.point1))
        .take(6)
        .toList();

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
                _infoRow("Name:", westernData.name),
                _infoRow("Date of Birth:", westernData.birthDate),
                _infoRow("Birth Time:", westernData.birthTime),
                _infoRow("Time Zone:", westernData.location.timezone.isNotEmpty ? westernData.location.timezone : "N/A"),
                _infoRow("Birth City:", westernData.location.city.isNotEmpty ? westernData.location.city : "N/A"),
                _infoRow("Birth Country:", westernData.location.country.isNotEmpty ? westernData.location.country : "N/A"),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Birth Chart Wheel Title
          Text(
            "Birth Chart Wheel",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          /// Chart Image
          ZoomableChartImage(
            imageUrl: westernData.imageUrl,
            height: ResponsiveHelper.height(350),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),

          /// ——— Personal Planets ———
          Text(
            "Personal Planets:",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          ...personalPlanetEntries.map((entry) {
            final planet = entry.value;
            return _planetTileNew(
              planet.name,
              planet.sign,
              "in ${_ordinalHouse(planet.house)} house",
            );
          }),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ——— Personal Planets Key Aspects ———
          Text(
            "Personal Planets Key Aspects :",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          ...personalAspects.map((aspect) {
            return _aspectTileNew(
              aspect.point1,
              _capitalizeFirst(aspect.aspect),
              "${aspect.orb.toStringAsFixed(0)}°",
            );
          }),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ——— Outer Planets Key Aspects ———
          Text(
            "Outer Planets  Key Aspects :",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),

          ...outerPlanetEntries.map((entry) {
            final planet = entry.value;
            return _planetTileNew(
              planet.name,
              planet.sign,
              "in ${_ordinalHouse(planet.house)} house",
            );
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

  /// New planet tile with purple sign text — matches the screenshot
  Widget _planetTileNew(String planetName, String sign, String houseText) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Row(
        children: [
          Text(
            "$planetName:   ",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            sign,
            style: TextStyle(
              color: CustomColors.primaryColor,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            " $houseText",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
        ],
      ),
    );
  }

  /// New aspect tile — planet name, aspect type, orb degree
  Widget _aspectTileNew(String planetName, String aspectName, String orbDegree) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Row(
        children: [
          Text(
            "$planetName:  ",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            aspectName,
            style: TextStyle(
              color: const Color(0xffA4A9C1),
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          SizedBox(width: ResponsiveHelper.space(6)),
          Text(
            orbDegree,
            style: TextStyle(
              color: CustomColors.primaryColor,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to convert house number string to ordinal (e.g. "2" -> "2nd")
  String _ordinalHouse(String houseStr) {
    final num = int.tryParse(houseStr) ?? 0;
    if (num == 0) return houseStr;
    switch (num) {
      case 1: return '1st';
      case 2: return '2nd';
      case 3: return '3rd';
      default: return '${num}th';
    }
  }

  /// Capitalize first letter of a string
  String _capitalizeFirst(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  // ==================== TRANSIT CHART ====================
  Widget _buildTransitChart() {
    final transitData = controller.transitResponse.value?.results['western'];

    if (transitData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF9A3BFF),
          strokeWidth: ResponsiveHelper.width(4),
        ),
      );
    }

    final imageUrl = controller.transitResponse.value?.images['western'] ?? '';

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
                      "About Western Chart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.space(10)),
                  Text(
                    "Based on the seasons. Your sign reflects where the Sun was relative to the spring equinox. More focused on personality, psychology, and self-understanding.",
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
                  "Transit Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Name:", transitData.profileName),
                _infoRow("Transit Date:", transitData.transitDate),
                _infoRow("Overall Quality:", transitData.overallQuality),
                _infoRow("Significant Aspects:", transitData.significantAspects.toString()),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Chart Image
          Text(
            "Transit Chart",
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

          /// Active Transits
          Text(
            "Active Transits",
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
    final synastryData = controller.synastryResponse.value?.results['western'];

    if (synastryData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF9A3BFF),
          strokeWidth: ResponsiveHelper.width(4),
        ),
      );
    }

    final imageUrl = controller.synastryResponse.value?.images['western'] ?? '';

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
                      "About Western Chart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.space(10)),
                  Text(
                    "Based on the seasons. Your sign reflects where the Sun was relative to the spring equinox. More focused on personality, psychology, and self-understanding.",
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
                  "Synastry Info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Partner 1:", synastryData.profile1Name),
                _infoRow("Partner 2:", synastryData.profile2Name),
                _infoRow("Compatibility Score:", "${synastryData.compatibilityScore.toStringAsFixed(1)}%"),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// Chart Image
          Text(
            "Synastry Chart",
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

          /// Key Aspects
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

  Widget _planetTile(String planet, String detail) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Row(
        children: [
          Text(
            "$planet:",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.bold),
          ),
          SizedBox(width: ResponsiveHelper.space(8)),
          Expanded(
            child: Text(
              detail,
              style: TextStyle(color: const Color(0xffA4A9C1), fontSize: ResponsiveHelper.fontSize(14)),
            ),
          ),
        ],
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
}
