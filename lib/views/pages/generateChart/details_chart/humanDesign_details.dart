// lib/views/pages/generateChart/details_chart/humanDesign_details.dart
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
      body: SafeArea(
        child: Obx(() {

          var humanDesignData;

          if (controller.selectedChartType.value == 'Natal' &&
              controller.natalResponse.value != null) {
            humanDesignData = controller.natalResponse.value!.charts['human_design'];
          }

          if (humanDesignData == null) {
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
                        Center(child:
                        Text("About Human Design Chart",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),),
                        SizedBox(height: ResponsiveHelper.space(10)),
                        Text('A system that blends astrology with other spiritual frameworks. It identifies your "type" and shows how you are best designed to make decisions and use your energy. Less about prediction, more about understanding how you naturally operate.',
                          style:TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)) ,
                        ),
                      ]
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(24)),
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
                      _infoRow("Name:", humanDesignData.name),
                      _infoRow("Date of Birth:", humanDesignData.birthDate),
                      _infoRow("Birth Time:", humanDesignData.birthTime),
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

                Center(
                  child: SizedBox(
                    height: ResponsiveHelper.height(350),
                    width: MediaQuery.of(context).size.width,
                    child: humanDesignData.imageUrl.isNotEmpty
                        ? Image.network(
                      humanDesignData.imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xFF9A3BFF),
                            strokeWidth: ResponsiveHelper.width(4),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.error,
                              color: Colors.red, size: ResponsiveHelper.iconSize(50)),
                        );
                      },
                    )
                        : Image.asset(
                      "assets/images/chartimage.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- POINTS GRID ----
                Row(
                  children: [
                    Expanded(
                      child: _pointCard(
                        "Type",
                        "Generator",
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.space(12)),
                    Expanded(
                      child: _pointCard(
                        "Strategy",
                        "To Respond",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.space(12)),

                Row(
                  children: [
                    Expanded(
                      child: _pointCard(
                        "Authority",
                        "Sacral",
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.space(12)),
                    Expanded(
                      child: _pointCard(
                        "Profile",
                        "3/5",
                      ),
                    ),
                  ],
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
        }),
      ),
    );
  }

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
              color: Colors.white70,
              fontSize: ResponsiveHelper.fontSize(12),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(8)),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
