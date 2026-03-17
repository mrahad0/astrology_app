// generate_chart_screen.dart
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(24)),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.maxContentWidth ?? double.infinity,
          ),
          child: Column(
            children: [
              // ---------------- Step Indicator ----------------
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(16),
                  vertical: ResponsiveHelper.padding(8),
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        height: ResponsiveHelper.height(4),
                        margin: EdgeInsets.only(right: ResponsiveHelper.space(6)),
                        decoration: BoxDecoration(
                          color: index == 0
                              ? CustomColors.primaryColor
                              : const Color(0xff2A2C3A),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(4)),
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
        ),
      ),
    );
  }
}
