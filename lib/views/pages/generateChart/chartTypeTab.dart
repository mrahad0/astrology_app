// chart_type_tab.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_alertDialog.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      // Show SnackBar if no system is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please select at least one astrology system',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Navigate if at least one system is selected
      Get.toNamed(Routes.reviewPage);
    }
  }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Choose Astrology Systems",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Obx(() {
                      final availableSystems = controller.availableSystems;
                      final isNatal = controller.selectedChartType.value == 'Natal';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (availableSystems.contains('Western'))
                            _chartBox("Western Astrology", 'Western'),

                          if (availableSystems.contains('Western'))
                            const SizedBox(height: 10),

                          if (availableSystems.contains('Vedic'))
                            _chartBox("Vedic Astrology", 'Vedic'),

                          if (isNatal) ...[
                            const SizedBox(height: 10),
                            _chartBox("13-Signs (Ophiuchus)", '13-Signs'),

                            const SizedBox(height: 10),
                            _chartBox("Evolutionary", 'Evolutionary'),

                            const SizedBox(height: 10),
                            _chartBox("Galactic Astrology",'Galactic'),

                            const SizedBox(height: 10),
                            _chartBox("Human Design Profile  (Type, Strategy, Authority, Profile, Cross)",'Human Design'),
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepBar(bool active) {
    return Expanded(
      child: Container(
        height: 4,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF8A2BE2) : Colors.white24,
          borderRadius: BorderRadius.circular(10),
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
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white))),
            ],
          ),
        ),
      );
    });
  }

  Widget _lockedBox(String title) {
    return InkWell(
      onTap: () {
        CustomAlertdialog(
          onPressed: () {
            Get.toNamed(Routes.subscriptionPage);
          },
          context: context,
          title: "Need upgrade your plane",
          content: "You have to upgrade your subscription plane for generate this chart",
        ).show(context);
      },
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
          color: CustomColors.secondbackgroundColor,
        ),
        child: Row(
          children: [
            Icon(Icons.lock, color: Colors.white54, size: 18),
            SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white54))),
          ],
        ),
      ),
    );
  }
}




