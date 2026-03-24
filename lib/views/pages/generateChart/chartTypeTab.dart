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
                padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Astrology Systems",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.space(16)),
                    Obx(() {
                      final availableSystems = controller.availableSystems;
                      final isNatal =
                          controller.selectedChartType.value == 'Natal';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (availableSystems.contains('Western'))
                            _chartBox("Western Astrology", 'Western'),
                          if (availableSystems.contains('Western'))
                            SizedBox(height: ResponsiveHelper.space(10)),
                          if (availableSystems.contains('Vedic'))
                            _chartBox("Vedic Astrology", 'Vedic'),
                          if (isNatal) ...[
                            SizedBox(height: ResponsiveHelper.space(10)),
                            _chartBox("13-Signs (Ophiuchus)", '13_sign'),
                            SizedBox(height: ResponsiveHelper.space(10)),
                            _chartBox("Evolutionary", 'Evolutionary'),
                            SizedBox(height: ResponsiveHelper.space(10)),
                            _chartBox("Galactic Astrology", 'Galactic'),
                            SizedBox(height: ResponsiveHelper.space(10)),
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
                text: "Next",
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
        child: Container(
          height: ResponsiveHelper.height(65), // Adjusted height for potential text wrapping
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(12),
            vertical: ResponsiveHelper.padding(10),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
            border: Border.all(color: Colors.white24),
            color: CustomColors.secondbackgroundColor,
          ),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (v) => controller.toggleSystem(systemKey),
                activeColor: const Color(0xFF8A2BE2),
                checkColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              Expanded(
                  child: Text(title,
                      style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)))),
              IconButton(
                onPressed: () {
                  final description =
                      ChartDescriptions.descriptions[systemKey] ?? '';
                  _showDescriptionDialog(description);
                },
                icon: Icon(Icons.info_outline,
                    color: CustomColors.primaryColor, size: ResponsiveHelper.iconSize(18),),
              )
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
