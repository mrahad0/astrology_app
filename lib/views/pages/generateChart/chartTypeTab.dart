// chart_type_tab.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/chart_descriptions.dart';

class ChartTypeTab extends StatefulWidget {
  final VoidCallback onNext;
  const ChartTypeTab({super.key, required this.onNext});

  @override
  State<ChartTypeTab> createState() => _ChartTypeTabState();
}

class _ChartTypeTabState extends State<ChartTypeTab> {
  final ChartController controller = Get.find<ChartController>();

  void _handleNext() {
    if (controller.selectedSystems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one astrology system',
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(ResponsiveHelper.padding(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      Get.toNamed(Routes.reviewPage);
    }
  }

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
        appBar: CustomAppBar(
          title: "Generate Chart",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(24)),
          ),
        ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _stepBar(true),
                  _stepBar(true),
                  _stepBar(true),
                  _stepBar(false),
                ],
              ),
              SizedBox(height: ResponsiveHelper.space(20)),
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      "${controller.selectedChartType.value} Chart (Platinum Plan)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    SizedBox(height: ResponsiveHelper.space(20)),
                    Obx(() {
                      final isNatal = controller.selectedChartType.value == 'Natal';
                      final isTransit = controller.selectedChartType.value == 'Transit';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _chartBox("Western Astrology", 'Western'),
                          _chartBox("Vedic Astrology", 'Vedic'),
                          _chartBox("13-Signs (Ophiuchus)", 'Ophiuchus'),

                          if (isNatal || isTransit)
                            _chartBox("Evolutionary", 'Evolutionary'),

                          if (isNatal) ...[
                            _chartBox("Galactic Astrology", 'Galactic'),
                            _chartBox(
                                "Human Design Profile (Type, Strategy, Authority, Profile, Cross)",
                                'Human Design'),
                          ],
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: "Review & Generate",
                onpress: _handleNext,
              ),
              SizedBox(height: ResponsiveHelper.space(20)),
            ],
          ),
        ),
      ),
     ),
    );
  }

  Widget _stepBar(bool active) {
    return Expanded(
      child: Container(
        height: ResponsiveHelper.height(4),
        margin: EdgeInsets.only(right: ResponsiveHelper.space(8)),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF8A2BE2) : Colors.white24,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        ),
      ),
    );
  }

  Widget _chartBox(String title, String systemKey) {
    return Obx(() {
      final isSelected = controller.selectedSystems.contains(systemKey);

      return InkWell(
        onTap: () => controller.toggleSystem(systemKey),
        child: Padding(
          padding: EdgeInsets.only(bottom: ResponsiveHelper.padding(16)),
          child: Row(
            children: [
              SizedBox(
                width: ResponsiveHelper.width(22),
                height: ResponsiveHelper.height(22),
                child: Checkbox(
                  value: isSelected,
                  onChanged: (v) => controller.toggleSystem(systemKey),
                  activeColor: Colors.transparent,
                  fillColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.radius(4))),
                ),
              ),
              SizedBox(width: ResponsiveHelper.space(12)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: ResponsiveHelper.fontSize(14),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDescriptionDialog(String content) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          backgroundColor:Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () {
            Navigator.of(context).pop();
          },
            child: Text(
              "Close",
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: ResponsiveHelper.fontSize(14)
              ),
            ),
          ),
          ],
        );
      },
    );
  }
}
