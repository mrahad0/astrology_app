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
    final realData = controller.natalResponse.value?.charts['ophiuchus'];
    
    // MOCK DATA for "Frontend Only" state (matching shared image)
    final mockInfo = {
      'name': 'Sadiqul',
      'dob': '11/13/2005',
      'time': '7:00 pm',
      'timezone': 'GMT+6',
      'cityCountry': 'Dhaka, Bangladesh',
    };

    final List<Map<String, String>> mockPositions = [
      {'planet': 'Sun', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'planet': 'Moon', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Mercury', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Venus', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Mars', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Jupiter', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Saturn', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Uranus', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Neptune', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Pluto', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
    ];

    final List<Map<String, String>> mockAspects = [
      {'planet': 'Jupiter', 'sign': 'Gemini', 'extra': 'in 9th house'},
      {'planet': 'Saturn', 'sign': 'Pisces', 'extra': 'in 6th house'},
      {'planet': 'Uranus', 'sign': 'Gemini', 'extra': 'in 9th house'},
      {'planet': 'Neptune', 'sign': 'Cancer', 'extra': 'in 10th house'},
      {'planet': 'Pluto', 'sign': 'Cancer', 'extra': 'in 10th house'},
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

          /// ---- 13-SIGN CHART TITLE ----
          Text(
            "13-Sign Chart Wheel",
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
              imageUrl: realData?.imageUrl ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/13sign_chart.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(12)),
          Center(
            child: Text(
              "In the 13-sign system, your placements shift slightly",
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(12),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- PLANETARY POSITIONS ----
          Text(
            "Planetary Positions :",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),

          ...mockPositions.map((p) => _planetTile(p['planet']!, p['sign']!, p['extra']!)),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- OUTER PLANETS KEY ASPECTS ----
          Text(
            "Outer Planets Key Aspects :",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(12)),

          ...mockAspects.map((p) => _planetTile(p['planet']!, p['sign']!, p['extra']!)),

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
    final realImage = controller.transitResponse.value?.images['ophiuchus'];

    final mockTransitInfo = {
      'name': 'Sadiqul',
      'transitDate': 'June 14, 2024',
      'quality': 'Balanced',
    };

    final List<Map<String, String>> mockPositions = [
      {'planet': 'Sun', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'planet': 'Moon', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Mercury', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Venus', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Mars', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Jupiter', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Saturn', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Uranus', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Neptune', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Pluto', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
    ];

    final List<Map<String, String>> mockAspects = [
      {'planet': 'Jupiter', 'sign': 'Gemini', 'extra': 'in 9th house'},
      {'planet': 'Saturn', 'sign': 'Pisces', 'extra': 'in 6th house'},
      {'planet': 'Uranus', 'sign': 'Gemini', 'extra': 'in 9th house'},
      {'planet': 'Neptune', 'sign': 'Cancer', 'extra': 'in 10th house'},
      {'planet': 'Pluto', 'sign': 'Cancer', 'extra': 'in 10th house'},
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
          Text("13-Sign Transit Chart Wheel",
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
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/13sign_transit.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Planetary Positions :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockPositions.map((p) => _planetTile(p['planet']!, p['sign']!, p['extra']!)),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Outer Planets Key Aspects :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockAspects.map((p) => _planetTile(p['planet']!, p['sign']!, p['extra']!)),
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
    final realImage = controller.synastryResponse.value?.images['ophiuchus'];

    final mockSynastryInfo = {
      'partner1': 'Sadiqul',
      'partner2': 'Sarah',
      'score': '88%',
    };

    final List<Map<String, String>> mockPositions = [
      {'planet': 'Sun', 'sign': 'Taurus', 'extra': 'in Rohini'},
      {'planet': 'Moon', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Mercury', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Venus', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Mars', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Jupiter', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Saturn', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Uranus', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Neptune', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
      {'planet': 'Pluto', 'sign': 'Aquarius', 'extra': 'in Dhanishta'},
    ];

    final List<Map<String, String>> mockAspects = [
      {'planet': 'Jupiter', 'sign': 'Gemini', 'extra': 'in 9th house'},
      {'planet': 'Saturn', 'sign': 'Pisces', 'extra': 'in 6th house'},
      {'planet': 'Uranus', 'sign': 'Gemini', 'extra': 'in 9th house'},
      {'planet': 'Neptune', 'sign': 'Cancer', 'extra': 'in 10th house'},
      {'planet': 'Pluto', 'sign': 'Cancer', 'extra': 'in 10th house'},
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
          Text("13-Sign Synastry Chart Wheel",
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
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/13sign_synastry.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Planetary Positions :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockPositions.map((p) => _planetTile(p['planet']!, p['sign']!, p['extra']!)),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Outer Planets Key Aspects :",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          ...mockAspects.map((p) => _planetTile(p['planet']!, p['sign']!, p['extra']!)),
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

  Widget _planetTile(String planetName, String sign, String extra) {
    return Container(
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
            sign,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            " $extra",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
        ],
      ),
    );
  }
}
