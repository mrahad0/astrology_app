// astrology_system_tab.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/chart_controller/chart_controller.dart';


class AstrologysystemTab extends StatefulWidget {
  final VoidCallback onNext;
  const AstrologysystemTab({super.key, required this.onNext});

  @override
  State<AstrologysystemTab> createState() => _AstrologysystemTab();
}

class _AstrologysystemTab extends State<AstrologysystemTab> {
  final ChartController controller = Get.put(ChartController());
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
          child: Column(
            children: [
              Container(
                height: ResponsiveHelper.height(200),
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                  border: Border.all(
                    color: Color(0xff2A2F45),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Chart Type",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.space(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: buildCard(0, "Natal \nChart", "assets/icons/natal.svg")),
                        SizedBox(width: ResponsiveHelper.space(8)),
                        Expanded(child: buildCard(1, "Transit \nChart", "assets/icons/transit.svg")),
                        SizedBox(width: ResponsiveHelper.space(8)),
                        Expanded(child: buildCard(2, "Synastry \nChart", "assets/icons/synastry.svg")),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              CustomButton(
                text: "Next",
                onpress: () {
                  if (selectedIndex == 0) {
                    controller.setChartType('Natal');
                    Get.toNamed(Routes.natalChart);
                  } else if (selectedIndex == 1) {
                    controller.setChartType('Transit');
                    Get.toNamed(Routes.transitChart);
                  } else if (selectedIndex == 2) {
                    controller.setChartType('Synastry');
                    Get.toNamed(Routes.synastryChart);
                  }
                },
              ),

              SizedBox(height: ResponsiveHelper.space(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(int index, String title, String url) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
      },
      child: Container(
        height: ResponsiveHelper.height(115), // Increased slightly to accommodate scaled text
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
        decoration: BoxDecoration(
          color: const Color(0xff1B1F33),
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          border: Border.all(
            color: isSelected ? Colors.purple : const Color(0xff2A2F45),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              url,
              width: ResponsiveHelper.iconSize(24),
              height: ResponsiveHelper.iconSize(24),
            ),
            SizedBox(height: ResponsiveHelper.space(12)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.purple : Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
