// generate_chart_screen.dart
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/pages/generateChart/astrologySystem_Tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/chart_controller/chart_controller.dart';

class GenerateChart extends StatefulWidget {
  const GenerateChart({super.key});

  @override
  State<GenerateChart> createState() => _GenerateChart();
}

class _GenerateChart extends State<GenerateChart> {
  final ChartController controller = Get.put(ChartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Generate Chart",
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // ---------------- Step Indicator ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? CustomColors.primaryColor
                          : const Color(0xff2A2C3A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),

          // ---------------- Content ----------------
          Expanded(
            child: AstrologysystemTab(onNext: () {}),
          ),
        ],
      ),
    );
  }
}






