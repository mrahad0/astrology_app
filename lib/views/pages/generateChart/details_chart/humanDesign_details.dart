// lib/views/pages/generateChart/details_chart/humanDesign_details.dart
import 'package:astrology_app/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/ai_compresive/ai_compresive_controller.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HumandesignDetails extends StatefulWidget {
  const HumandesignDetails({super.key});

  @override
  State<HumandesignDetails> createState() => _HumandesignDetails();
}

class _HumandesignDetails extends State<HumandesignDetails> {
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
    final realData = controller.natalResponse.value?.charts['human_design'];
    
    // MOCK DATA for "Frontend Only" state (matching shared image)
    final mockInfo = {
      'name': 'Sadiqul',
      'dob': '11/13/2005',
      'time': '7:00 pm',
      'timezone': 'GMT+6',
      'cityCountry': 'Dhaka, Bangladesh',
    };

    final mockHD = {
      'type': 'Generator',
      'strategy': 'To Respond',
      'authority': 'Sacral',
      'profile': '3/5 Martyr/Heretic',
      'incarnation_cross': 'Left Angle Cross of Individualism (38/39 | 57/51)',
    };

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

          /// ---- HUMAN DESIGN TITLE ----
          Text(
            "Human Design",
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
              imageUrl: realData?.imageUrl ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/hd_chart.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- TYPE & STRATEGY ROW ----
          Row(
            children: [
              Expanded(
                child: _pointCard("Type", mockHD['type']!),
              ),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(
                child: _pointCard("Strategy", mockHD['strategy']!),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.space(12)),

          /// ---- AUTHORITY & PROFILE ROW ----
          Row(
            children: [
              Expanded(
                child: _pointCard("Authority", mockHD['authority']!),
              ),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(
                child: _pointCard("Profile", mockHD['profile']!),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.space(12)),

          /// ---- INCARNATION CROSS ----
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Incarnation Cross",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(8)),
                Text(
                  mockHD['incarnation_cross']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
              ],
            ),
          ),

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
    final realImage = controller.transitResponse.value?.images['human_design'];

    final mockTransitInfo = {
      'name': 'Sadiqul',
      'transitDate': 'June 14, 2024',
      'quality': 'Insightful',
    };

    final mockHD = {
      'type': 'Generator',
      'strategy': 'To Respond',
      'authority': 'Sacral',
      'profile': '3/5 Martyr/Heretic',
      'incarnation_cross': 'Left Angle Cross of Individualism (38/39 | 57/51)',
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
          Text("Human Design Transit Chart Wheel",
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
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/hd_transit.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Row(
            children: [
              Expanded(child: _pointCard("Type", mockHD['type']!)),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(child: _pointCard("Strategy", mockHD['strategy']!)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          Row(
            children: [
              Expanded(child: _pointCard("Authority", mockHD['authority']!)),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(child: _pointCard("Profile", mockHD['profile']!)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          _incarnationCrossCard(mockHD['incarnation_cross']!),
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
    final realImage = controller.synastryResponse.value?.images['human_design'];

    final mockSynastryInfo = {
      'partner1': 'Sadiqul',
      'partner2': 'Sarah',
      'score': '85%',
    };

    final mockHD = {
      'type': 'Generator',
      'strategy': 'To Respond',
      'authority': 'Sacral',
      'profile': '3/5 Martyr/Heretic',
      'incarnation_cross': 'Left Angle Cross of Individualism (38/39 | 57/51)',
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
          Text("Human Design Synastry Chart Wheel",
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
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/hd_synastry.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Row(
            children: [
              Expanded(child: _pointCard("Type", mockHD['type']!)),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(child: _pointCard("Strategy", mockHD['strategy']!)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          Row(
            children: [
              Expanded(child: _pointCard("Authority", mockHD['authority']!)),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(child: _pointCard("Profile", mockHD['profile']!)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          _incarnationCrossCard(mockHD['incarnation_cross']!),
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

  Widget _incarnationCrossCard(String cross) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Incarnation Cross", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(8)),
          Text(cross, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
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
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
          ),
        ],
      ),
    );
  }

  Widget _pointCard(String title, String subtitle) {
    return Container(
      height: ResponsiveHelper.height(100),
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(8)),
          Text(
            subtitle,
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
