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
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                  border: Border.all(
                    color: const Color(0xFF2F3448),
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
                    buildNatalCard(),
                    SizedBox(height: ResponsiveHelper.space(12)),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: buildComplexCard(
                              1,
                              "Transit Chart Only\nApplies to",
                              "assets/icons/transit.svg",
                              [
                                "Western Astrology",
                                "Vedic Astrology",
                                "13-Sign Zodiac",
                                "Evolutionary Astrology",
                              ],
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.space(12)),
                          Expanded(
                            child: buildComplexCard(
                              2,
                              "Synastry Chart\nOnly Applies to",
                              "assets/icons/synastry.svg",
                              [
                                "Western Astrology",
                                "Vedic Astrology",
                                "13-Sign Zodiac",
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget buildNatalCard() {
    bool isSelected = selectedIndex == 0;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
        decoration: BoxDecoration(
          color: const Color(0xFF111424),
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          border: Border.all(
            color: isSelected ? Colors.purple : const Color(0xFF2F3448),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/icons/natal.svg",
              width: ResponsiveHelper.iconSize(28),
              height: ResponsiveHelper.iconSize(28),
            ),
            SizedBox(height: ResponsiveHelper.space(12)),
            Text(
              "Natal Chart",
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildComplexCard(int index, String title, String url, List<String> items) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.padding(16),
            horizontal: ResponsiveHelper.padding(12)),
        decoration: BoxDecoration(
          color: const Color(0xFF111424),
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          border: Border.all(
            color: isSelected ? Colors.purple : const Color(0xFF2F3448),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              url,
              width: ResponsiveHelper.iconSize(28),
              height: ResponsiveHelper.iconSize(28),
            ),
            SizedBox(height: ResponsiveHelper.space(12)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: ResponsiveHelper.space(12)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.asMap().entries.map((e) {
                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveHelper.space(4)),
                  child: Text(
                    "${e.key + 1}. ${e.value}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(12),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
