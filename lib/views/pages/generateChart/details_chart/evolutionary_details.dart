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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
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
    );
  }

  // ==================== NATAL VIEW ====================
  Widget _buildNatalChart() {
    final realData = controller.natalResponse.value?.charts['evolutionary'];
    
    // MOCK DATA for "Frontend Only" state
    final mockInfo = {
      'name': 'Sadiqul',
      'dob': '11/13/2005',
      'time': '7:00 pm',
      'timezone': 'GMT+6',
      'cityCountry': 'Dhaka, Bangladesh',
    };

    final Map<String, dynamic> mockGrid = {
      'pluto_sign_house': {'label': 'Pluto Sign / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'north_node_sign_house': {'label': 'North Node Sign / House', 'sign': 'Leo', 'house': '6th house'},
      'south_node': {'label': 'South Node / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'pluto_to_node_aspect': {'label': 'Pluto to Node Aspect', 'sign': 'Gemini', 'house': '3rd house'},
      'chiron_sign_house': {'label': 'Chiron Sign / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'chiron_to_pluto_aspect': {'label': 'Chiron to Pluto Aspect', 'sign': 'Sagittarius', 'house': '9th house'},
      'saturn_sign_house': {'label': 'Saturn Sign / House', 'sign': 'Taurus', 'house': '2nd house'},
      'sun_sign': {'label': 'Sun Sign', 'sign': 'Capricorn', 'house': ''},
      'moon_sign': {'label': 'Moon Sign', 'sign': 'Scorpio', 'house': ''},
      'rising_sign': {'label': 'Rising Sign (Ascendant)', 'sign': 'Pisces', 'house': ''},
      'vertex_point': {'label': 'Vertex Point', 'sign': 'Virgo', 'house': ''},
      'part_of_fortune': {'label': 'Part of Fortune', 'sign': 'Capricorn', 'house': ''},
    };

    final evolutionaryData = realData;
    final gridToUse = evolutionaryData?.grid ?? mockGrid;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),

          /// ---- INFO CARD ----
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff2F3448)),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
              color: const Color(0xFF1F2544),
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
                _infoRow("Name:", evolutionaryData?.name ?? mockInfo['name']!),
                _infoRow("Date of Birth:", evolutionaryData?.birthDate ?? mockInfo['dob']!),
                _infoRow("Birth Time:", evolutionaryData?.birthTime ?? mockInfo['time']!),
                _infoRow("Time Zone:", evolutionaryData != null ? (evolutionaryData.location.timezone.isNotEmpty ? evolutionaryData.location.timezone : "N/A") : mockInfo['timezone']!),
                _infoRow(
                  "Birth City / Birth Country:",
                  evolutionaryData != null 
                    ? "${evolutionaryData.location.city}, ${evolutionaryData.location.country}"
                    : mockInfo['cityCountry']!,
                ),
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
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2544),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
              border: Border.all(color: const Color(0xff2F3448).withOpacity(0.5)),
            ),
            child: ZoomableChartImage(
              imageUrl: evolutionaryData?.imageUrl ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/evolutionary_chart.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- EVOLUTIONARY POINTS GRID ----
          if (gridToUse.isNotEmpty)
            ..._gridRows.map((rowKeys) {
              return Padding(
                padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _gridCard(gridToUse, rowKeys[0]),
                      ),
                      if (rowKeys.length > 1) ...[
                         SizedBox(width: ResponsiveHelper.space(12)),
                         Expanded(
                           child: _gridCard(gridToUse, rowKeys[1]),
                         ),
                      ],
                    ],
                  ),
                ),
              );
            }),

          SizedBox(height: ResponsiveHelper.space(40)),

          CustomButton(
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
          ),

          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  // ==================== TRANSIT VIEW ====================
  Widget _buildTransitChart() {
    final realImage = controller.transitResponse.value?.images['evolutionary'];

    final mockTransitInfo = {
      'name': 'Sadiqul',
      'transitDate': 'June 14, 2024',
      'quality': 'Positive',
    };

    final Map<String, dynamic> mockGrid = {
      'pluto_sign_house': {'label': 'Pluto Sign / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'north_node_sign_house': {'label': 'North Node Sign / House', 'sign': 'Leo', 'house': '6th house'},
      'south_node': {'label': 'South Node / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'pluto_to_node_aspect': {'label': 'Pluto to Node Aspect', 'sign': 'Gemini', 'house': '3rd house'},
      'chiron_sign_house': {'label': 'Chiron Sign / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'chiron_to_pluto_aspect': {'label': 'Chiron to Pluto Aspect', 'sign': 'Sagittarius', 'house': '9th house'},
      'saturn_sign_house': {'label': 'Saturn Sign / House', 'sign': 'Taurus', 'house': '2nd house'},
      'sun_sign': {'label': 'Sun Sign', 'sign': 'Capricorn', 'house': ''},
      'moon_sign': {'label': 'Moon Sign', 'sign': 'Scorpio', 'house': ''},
      'rising_sign': {'label': 'Rising Sign (Ascendant)', 'sign': 'Pisces', 'house': ''},
      'vertex_point': {'label': 'Vertex Point', 'sign': 'Virgo', 'house': ''},
      'part_of_fortune': {'label': 'Part of Fortune', 'sign': 'Capricorn', 'house': ''},
    };

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff2F3448)),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
              color: const Color(0xFF1F2544),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Transit Info",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.w600)),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Name:", mockTransitInfo['name']!),
                _infoRow("Transit Date:", mockTransitInfo['transitDate']!),
                _infoRow("Overall Quality:", mockTransitInfo['quality']!),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Evolutionary Transit Chart Wheel",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2544),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
              border: Border.all(color: const Color(0xff2F3448).withOpacity(0.5)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/evolutionary_transit.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          ..._gridRows.map((rowKeys) {
            return Padding(
              padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: _gridCard(mockGrid, rowKeys[0])),
                    if (rowKeys.length > 1) ...[
                      SizedBox(width: ResponsiveHelper.space(12)),
                      Expanded(child: _gridCard(mockGrid, rowKeys[1])),
                    ],
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: ResponsiveHelper.space(40)),
          CustomButton(
            text: "Generate Reading",
            isLoading: controller.isGeneratingInterpretation.value,
            onpress: () {},
          ),
          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  // ==================== SYNASTRY VIEW ====================
  Widget _buildSynastryChart() {
    final realImage = controller.synastryResponse.value?.images['evolutionary'];

    final mockSynastryInfo = {
      'partner1': 'Sadiqul',
      'partner2': 'Sarah',
      'score': '83%',
    };

    final Map<String, dynamic> mockGrid = {
      'pluto_sign_house': {'label': 'Pluto Sign / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'north_node_sign_house': {'label': 'North Node Sign / House', 'sign': 'Leo', 'house': '6th house'},
      'south_node': {'label': 'South Node / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'pluto_to_node_aspect': {'label': 'Pluto to Node Aspect', 'sign': 'Gemini', 'house': '3rd house'},
      'chiron_sign_house': {'label': 'Chiron Sign / House', 'sign': 'Sagittarius', 'house': '9th house'},
      'chiron_to_pluto_aspect': {'label': 'Chiron to Pluto Aspect', 'sign': 'Sagittarius', 'house': '9th house'},
      'saturn_sign_house': {'label': 'Saturn Sign / House', 'sign': 'Taurus', 'house': '2nd house'},
      'sun_sign': {'label': 'Sun Sign', 'sign': 'Capricorn', 'house': ''},
      'moon_sign': {'label': 'Moon Sign', 'sign': 'Scorpio', 'house': ''},
      'rising_sign': {'label': 'Rising Sign (Ascendant)', 'sign': 'Pisces', 'house': ''},
      'vertex_point': {'label': 'Vertex Point', 'sign': 'Virgo', 'house': ''},
      'part_of_fortune': {'label': 'Part of Fortune', 'sign': 'Capricorn', 'house': ''},
    };

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff2F3448)),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
              color: const Color(0xFF1F2544),
            ),
            child: Column(
              children: [
                Text("Harmony Score",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(16), fontWeight: FontWeight.w400)),
                SizedBox(height: ResponsiveHelper.space(10)),
                Text(mockSynastryInfo['score']!,
                    style: TextStyle(color: CustomColors.primaryColor, fontSize: ResponsiveHelper.fontSize(40), fontWeight: FontWeight.bold)),
                SizedBox(height: ResponsiveHelper.space(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _partnerLabel("Partner 1", mockSynastryInfo['partner1']!),
                    Container(height: 30, width: 1, color: Colors.white24),
                    _partnerLabel("Partner 2", mockSynastryInfo['partner2']!),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Evolutionary Synastry Chart Wheel",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2544),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
              border: Border.all(color: const Color(0xff2F3448).withOpacity(0.5)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/evolutionary_synastry.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          ..._gridRows.map((rowKeys) {
            return Padding(
              padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: _gridCard(mockGrid, rowKeys[0])),
                    if (rowKeys.length > 1) ...[
                      SizedBox(width: ResponsiveHelper.space(12)),
                      Expanded(child: _gridCard(mockGrid, rowKeys[1])),
                    ],
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: ResponsiveHelper.space(40)),
          CustomButton(
            text: "Generate Reading",
            isLoading: controller.isGeneratingInterpretation.value,
            onpress: () {},
          ),
          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  Widget _partnerLabel(String label, String name) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white54, fontSize: ResponsiveHelper.fontSize(12))),
        SizedBox(height: ResponsiveHelper.space(4)),
        Text(name, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.width(110),
            child: Text(key,
                style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14))),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  /// Builds a single grid card from the evolutionary `grid` map.
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
        color: const Color(0xFF1F2544),
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xff2F3448).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: ResponsiveHelper.fontSize(12),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(10)),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                sign,
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: ResponsiveHelper.fontSize(15),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (house.isNotEmpty)
                Text(
                  ' ${house.toLowerCase().contains('house') ? house : "$house House"}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
