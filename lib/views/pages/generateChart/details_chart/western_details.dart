// lib/views/pages/generateChart/details_chart/western_details.dart
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

class WesternDetails extends StatefulWidget {
  const WesternDetails({super.key});

  @override
  State<WesternDetails> createState() => _WesternDetailsState();
}

class _WesternDetailsState extends State<WesternDetails> {
  final ChartController controller = Get.find<ChartController>();

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
    final realData = controller.natalResponse.value?.charts['western'];
    
    final mockInfo = {
      'name': 'Sadiqul',
      'dob': '11/13/2005',
      'time': '7:00 pm',
      'timezone': 'GMT+6',
      'cityCountry': 'Dhaka, Bangladesh',
    };

    final List<Map<String, String>> mockPlanets = [
      {'name': 'Sun', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Moon', 'sign': 'Pisces', 'house': 'in 6th house'},
      {'name': 'Mercury', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Venus', 'sign': 'Cancer', 'house': 'in 10th house'},
      {'name': 'Mars', 'sign': 'Cancer', 'house': 'in 10th house'},
    ];

    final List<Map<String, String>> mockAspects = [
      {'planet': 'Sun', 'aspect': 'Opposition', 'degree': '1°'},
      {'planet': 'Moon', 'aspect': 'Conjunction', 'degree': '2.1°'},
      {'planet': 'Rising', 'aspect': 'Square', 'degree': '2.1°'},
      {'planet': 'Mercury', 'aspect': 'Trine', 'degree': '2.7°'},
      {'planet': 'Venus', 'aspect': 'Sextile', 'degree': '2.1°'},
      {'planet': 'Mars', 'aspect': 'Conjunction', 'degree': '2.1°'},
    ];
    
    final List<Map<String, String>> mockOuterPlanets = [
      {'name': 'Jupiter', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Saturn', 'sign': 'Pisces', 'house': 'in 6th house'},
      {'name': 'Uranus', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Neptune', 'sign': 'Cancer', 'house': 'in 10th house'},
      {'name': 'Pluto', 'sign': 'Cancer', 'house': 'in 10th house'},
    ];

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
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Info",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.w600)),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Name:", mockInfo['name']!),
                _infoRow("Date of Birth:", mockInfo['dob']!),
                _infoRow("Birth Time:", mockInfo['time']!),
                _infoRow("Time Zone:", mockInfo['timezone']!),
                _infoRow("Birth City / Birth Country:", mockInfo['cityCountry']!),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Birth Chart Wheel",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realData?.imageUrl ?? "assets/images/chartimage.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Personal Planets:",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockPlanets.map((p) => _planetTile(p['name']!, p['sign']!, p['house']!)),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Personal Planets Key Aspects :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockAspects.map((a) => _aspectTile(a['planet']!, a['aspect']!, a['degree']!)),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Outer Planets  Key Aspects :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockOuterPlanets.map((p) => _planetTile(p['name']!, p['sign']!, p['house']!)),
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
    final realImage = controller.transitResponse.value?.images['western'];

    final mockTransitInfo = {
      'name': 'Sadiqul',
      'transitDate': 'June 14, 2024',
      'quality': 'Flowing',
    };

    final List<Map<String, String>> mockPlanets = [
      {'name': 'Sun', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Moon', 'sign': 'Pisces', 'house': 'in 6th house'},
      {'name': 'Mercury', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Venus', 'sign': 'Cancer', 'house': 'in 10th house'},
      {'name': 'Mars', 'sign': 'Cancer', 'house': 'in 10th house'},
    ];

    final List<Map<String, String>> mockAspects = [
      {'planet': 'Sun', 'aspect': 'Opposition', 'degree': '1°'},
      {'planet': 'Moon', 'aspect': 'Conjunction', 'degree': '2.1°'},
      {'planet': 'Rising', 'aspect': 'Square', 'degree': '2.1°'},
      {'planet': 'Mercury', 'aspect': 'Trine', 'degree': '2.7°'},
      {'planet': 'Venus', 'aspect': 'Sextile', 'degree': '2.1°'},
      {'planet': 'Mars', 'aspect': 'Conjunction', 'degree': '2.1°'},
    ];
    
    final List<Map<String, String>> mockOuterPlanets = [
      {'name': 'Jupiter', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Saturn', 'sign': 'Pisces', 'house': 'in 6th house'},
      {'name': 'Uranus', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Neptune', 'sign': 'Cancer', 'house': 'in 10th house'},
      {'name': 'Pluto', 'sign': 'Cancer', 'house': 'in 10th house'},
    ];

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
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
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
          Text("Western Transit Chart Wheel",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "assets/images/chartimage.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Personal Planets:",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockPlanets.map((p) => _planetTile(p['name']!, p['sign']!, p['house']!)),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Transit Key Aspects :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockAspects.map((a) => _aspectTile(a['planet']!, a['aspect']!, a['degree']!)),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Outer Planets  Key Aspects :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockOuterPlanets.map((p) => _planetTile(p['name']!, p['sign']!, p['house']!)),
          SizedBox(height: ResponsiveHelper.space(40)),
          CustomButton(text: "Generate Reading", isLoading: controller.isGeneratingInterpretation.value, onpress: () {}),
          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  // ==================== SYNASTRY VIEW ====================
  Widget _buildSynastryChart() {
    final realImage = controller.synastryResponse.value?.images['western'];

    final mockSynastryInfo = {
      'partner1': 'Sadiqul',
      'partner2': 'Sarah',
      'score': '85%',
    };

    final List<Map<String, String>> mockPlanets = [
      {'name': 'Sun', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Moon', 'sign': 'Pisces', 'house': 'in 6th house'},
      {'name': 'Mercury', 'sign': 'Gemini', 'house': 'in 9th house'},
      {'name': 'Venus', 'sign': 'Cancer', 'house': 'in 10th house'},
      {'name': 'Mars', 'sign': 'Cancer', 'house': 'in 10th house'},
    ];

    final List<Map<String, String>> mockAspects = [
      {'planet': 'Sun', 'aspect': 'Opposition', 'degree': '1°'},
      {'planet': 'Moon', 'aspect': 'Conjunction', 'degree': '2.1°'},
      {'planet': 'Rising', 'aspect': 'Square', 'degree': '2.1°'},
      {'planet': 'Mercury', 'aspect': 'Trine', 'degree': '2.7°'},
      {'planet': 'Venus', 'aspect': 'Sextile', 'degree': '2.1°'},
      {'planet': 'Mars', 'aspect': 'Conjunction', 'degree': '2.1°'},
    ];

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
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: Column(
              children: [
                Text("Harmony Score",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(16), fontWeight: FontWeight.w400)),
                SizedBox(height: ResponsiveHelper.space(10)),
                Text(mockSynastryInfo['score']!,
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(40), fontWeight: FontWeight.bold)),
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
          Text("Western Synastry Chart Wheel",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "assets/images/chartimage.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Synastry Overlay Aspects :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockPlanets.map((p) => _planetTile(p['name']!, p['sign']!, p['house']!)),
          SizedBox(height: ResponsiveHelper.space(24)),
          ...mockAspects.map((a) => _aspectTile(a['planet']!, a['aspect']!, a['degree']!)),
          SizedBox(height: ResponsiveHelper.space(40)),
          CustomButton(text: "Generate Reading", isLoading: controller.isGeneratingInterpretation.value, onpress: () {}),
          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  Widget _partnerLabel(String label, String name) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(12))),
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
            width: ResponsiveHelper.width(130),
            child: Text(key,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _planetTile(String planetName, String sign, String houseText) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$planetName: ",
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: sign,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: " $houseText",
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

  Widget _aspectTile(String planetName, String aspectName, String orbDegree) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Row(
        children: [
          Text(
            "$planetName: ",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            " $aspectName",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          SizedBox(width: ResponsiveHelper.space(6)),
          Text(
            orbDegree,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
