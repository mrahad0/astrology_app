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
              !response.charts.containsKey('human_design')) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF9A3BFF),
                strokeWidth: ResponsiveHelper.width(4),
              ),
            );
          }

          final hd = response.charts['human_design']!;

          // Build incarnation cross display text
          String incarnationCrossText = '';
          if (hd.hdIncarnationCross.isNotEmpty) {
            final crossName = hd.hdIncarnationCross['name'] ?? '';
            final gates = hd.hdIncarnationCross['gates'];
            if (gates != null && gates is List && gates.isNotEmpty) {
              final gatesStr = gates.map((g) => g.toString()).join('/');
              incarnationCrossText = '$crossName ($gatesStr)';
            } else {
              incarnationCrossText = crossName;
            }
          }

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
                      _infoRow("Name:", hd.name),
                      _infoRow("Date of Birth:", hd.birthDate),
                      _infoRow("Birth Time:", hd.birthTime),
                      _infoRow("Time Zone:", hd.location.timezone.isNotEmpty ? hd.location.timezone : "N/A"),
                      _infoRow("Birth City:", hd.location.city.isNotEmpty ? hd.location.city : "N/A"),
                      _infoRow("Birth Country:", hd.location.country.isNotEmpty ? hd.location.country : "N/A"),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- HUMAN DESIGN CHART ----
                Text(
                  "Human Design",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(17),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: ResponsiveHelper.space(16)),

                ZoomableChartImage(
                  imageUrl: hd.imageUrl,
                  height: ResponsiveHelper.height(350),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- TYPE & STRATEGY ROW ----
                Row(
                  children: [
                    Expanded(
                      child: _pointCard("Type", hd.hdType),
                    ),
                    SizedBox(width: ResponsiveHelper.space(12)),
                    Expanded(
                      child: _pointCard("Strategy", hd.hdStrategy),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.space(12)),

                /// ---- AUTHORITY & PROFILE ROW ----
                Row(
                  children: [
                    Expanded(
                      child: _pointCard("Authority", hd.hdAuthority),
                    ),
                    SizedBox(width: ResponsiveHelper.space(12)),
                    Expanded(
                      child: _pointCard("Profile", hd.hdProfile),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.space(12)),

                /// ---- INCARNATION CROSS (FULL WIDTH) ----
                if (incarnationCrossText.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                    decoration: BoxDecoration(
                      color: CustomColors.secondbackgroundColor,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                      border: Border.all(color: const Color(0xff2B2F45)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Incarnation Cross",
                          style: TextStyle(
                            color: CustomColors.primaryColor,
                            fontSize: ResponsiveHelper.fontSize(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.space(8)),
                        Text(
                          incarnationCrossText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(14),
                          ),
                        ),
                      ],
                    ),
                  ),

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

  Widget _pointCard(String title, String subtitle) {
    return Container(
      height: ResponsiveHelper.height(100),
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: CustomColors.primaryColor,
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
