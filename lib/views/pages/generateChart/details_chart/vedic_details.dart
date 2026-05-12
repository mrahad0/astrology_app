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

class VedicDetails extends StatefulWidget {
  const VedicDetails({super.key});

  @override
  State<VedicDetails> createState() => _VedicDetailsState();
}

class _VedicDetailsState extends State<VedicDetails> {
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
    final realData = controller.natalResponse.value?.charts['vedic'];
    
    // MOCK DATA for "Frontend Only" state (matching shared image)
    final mockInfo = {
      'name': 'Sadiqul',
      'dob': '11/13/2005',
      'time': '7:00 pm',
      'timezone': 'GMT+6',
      'cityCountry': 'Dhaka, Bangladesh',
    };

    final List<Map<String, String>> mockPlanets = [
      {'name': 'Sun', 'sign': 'Gemini', 'house': '9th house'},
      {'name': 'Moon', 'sign': 'Pisces', 'house': '6th house'},
      {'name': 'Mars', 'sign': 'Gemini', 'house': '9th house'},
      {'name': 'Mercury', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Jupiter', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Venus', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Saturn', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Rahu', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Ketu', 'sign': 'Cancer', 'house': '10th house'},
    ];

    final List<Map<String, String>> mockLifepath = [
      {'label': 'Dharma', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Karma', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Artha', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Kama', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
    ];

    final mockLunar = [
      {
        'label': 'Nakshatra placement (Moon Nakshatra)',
        'sign': 'Taurus',
        'detail': 'in Rohini'
      },
      {
        'label': 'Nakshatra pada',
        'sign': 'Aquarius',
        'detail': 'in Dhanishta'
      },
      {
        'label': 'Current Dasha',
        'sign': 'Venus',
        'detail': '\nRemaining: 18 years'
      },
    ];

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
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
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
                _infoRow("Name:", mockInfo['name']!),
                _infoRow("Date of Birth:", mockInfo['dob']!),
                _infoRow("Birth Time:", mockInfo['time']!),
                _infoRow("Time Zone:", mockInfo['timezone']!),
                _infoRow(
                  "Birth City / Birth Country:",
                  mockInfo['cityCountry']!,
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- VEDIC CHART TITLE ----
          Text(
            "Vedic Chart Wheel",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          /// ---- CHART IMAGE (FROM BACKEND) ----
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realData?.imageUrl ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/vedic_chart.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- SIDEREAL POSITIONS ----
          Text(
            "Sidereal planetary positions :",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),

          ...mockPlanets.map((p) => _planetTile(p['name']!, p['sign']!, "in ${p['house']}")),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- LIFEPATH INDICATOR ----
          Text(
            "Lifepath indicator :",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),

          ...mockLifepath.map((l) => _planetTile(l['label']!, l['sign']!, l['extra']!)),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- LUNAR SYSTEM ----
          Text(
            "Lunar System :",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),

          ...mockLunar.map((m) => _lunarTile(m['label']!, m['sign']!, m['detail']!)),

          SizedBox(height: ResponsiveHelper.space(40)),

          /// ---- GENERATE READING ----
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
    final realImage = controller.transitResponse.value?.images['vedic'];

    // MOCK DATA
    final mockTransitInfo = {
      'name': 'Sadiqul',
      'transitDate': 'June 14, 2024',
      'quality': 'Positive',
    };

    final List<Map<String, String>> mockPlanets = [
      {'name': 'Sun', 'sign': 'Gemini', 'house': '9th house'},
      {'name': 'Moon', 'sign': 'Pisces', 'house': '6th house'},
      {'name': 'Mars', 'sign': 'Gemini', 'house': '9th house'},
      {'name': 'Mercury', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Jupiter', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Venus', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Saturn', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Rahu', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Ketu', 'sign': 'Cancer', 'house': '10th house'},
    ];

    final List<Map<String, String>> mockLifepath = [
      {'label': 'Dharma', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Karma', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Artha', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Kama', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
    ];

    final mockLunar = [
      {'label': 'Nakshatra placement', 'sign': 'Taurus', 'detail': 'in Rohini'},
      {'label': 'Nakshatra pada', 'sign': 'Aquarius', 'detail': 'in Dhanishta'},
      {'label': 'Current Dasha', 'sign': 'Venus', 'detail': '\nRemaining: 18 years'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),

          /// ---- TRANSIT INFO CARD ----
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(18),
                        fontWeight: FontWeight.w600)),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Name:", mockTransitInfo['name']!),
                _infoRow("Transit Date:", mockTransitInfo['transitDate']!),
                _infoRow("Overall Quality:", mockTransitInfo['quality']!),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- TRANSIT CHART TITLE ----
          Text(
            "Vedic Transit Chart Wheel",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          /// ---- CHART IMAGE (FROM BACKEND) ----
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/vedic_transit.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          Text(
            "Sidereal planetary positions :",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockPlanets.map((p) => _planetTile(p['name']!, p['sign']!, "in ${p['house']}")),

          SizedBox(height: ResponsiveHelper.space(24)),

          Text(
            "Lifepath indicator :",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockLifepath.map((l) => _planetTile(l['label']!, l['sign']!, l['extra']!)),

          SizedBox(height: ResponsiveHelper.space(24)),

          Text(
            "Lunar System :",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockLunar.map((m) => _lunarTile(m['label']!, m['sign']!, m['detail']!)),

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
    final realImage = controller.synastryResponse.value?.images['vedic'];

    // MOCK DATA
    final mockSynastryInfo = {
      'partner1': 'Sadiqul',
      'partner2': 'Sarah',
      'score': '82%',
    };

    final List<Map<String, String>> mockPlanets = [
      {'name': 'Sun', 'sign': 'Gemini', 'house': '9th house'},
      {'name': 'Moon', 'sign': 'Pisces', 'house': '6th house'},
      {'name': 'Mars', 'sign': 'Gemini', 'house': '9th house'},
      {'name': 'Mercury', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Jupiter', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Venus', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Saturn', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Rahu', 'sign': 'Cancer', 'house': '10th house'},
      {'name': 'Ketu', 'sign': 'Cancer', 'house': '10th house'},
    ];

    final List<Map<String, String>> mockLifepath = [
      {'label': 'Dharma', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Karma', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Artha', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'label': 'Kama', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
    ];

    final mockLunar = [
      {'label': 'Nakshatra placement', 'sign': 'Taurus', 'detail': 'in Rohini'},
      {'label': 'Nakshatra pada', 'sign': 'Aquarius', 'detail': 'in Dhanishta'},
      {'label': 'Current Dasha', 'sign': 'Venus', 'detail': '\nRemaining: 18 years'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),

          /// ---- COMPATIBILITY SCORE CARD ----
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w400)),
                SizedBox(height: ResponsiveHelper.space(10)),
                Text(mockSynastryInfo['score']!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(40),
                        fontWeight: FontWeight.bold)),
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

          /// ---- SYNASTRY CHART TITLE ----
          Text(
            "Vedic Synastry Chart Wheel",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          /// ---- CHART IMAGE (FROM BACKEND) ----
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/vedic_synastry.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          Text(
            "Sidereal planetary positions :",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockPlanets.map((p) => _planetTile(p['name']!, p['sign']!, "in ${p['house']}")),

          SizedBox(height: ResponsiveHelper.space(24)),

          Text(
            "Lifepath indicator :",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockLifepath.map((l) => _planetTile(l['label']!, l['sign']!, l['extra']!)),

          SizedBox(height: ResponsiveHelper.space(24)),

          Text(
            "Lunar System :",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockLunar.map((m) => _lunarTile(m['label']!, m['sign']!, m['detail']!)),

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

  Widget _lunarTile(String label, String sign, String detail) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(4)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: sign,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: " $detail",
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
}
