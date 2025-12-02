import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_alertDialog.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartTypeTab extends StatefulWidget {
  final VoidCallback onNext;
  const ChartTypeTab({super.key, required this.onNext});

  @override
  State<ChartTypeTab> createState() => _ChartTypeTabState();
}

class _ChartTypeTabState extends State<ChartTypeTab> {
  bool western = false;
  bool vedic = false;
  bool sign13 = false;
  bool evolutionary = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Generate Chart", leading:IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ///---------------- Progress Bar ----------------
              Row(
                children: [
                  _stepBar(true),
                  _stepBar(true),
                  _stepBar(true),
                  _stepBar(false),
                ],
              ),

              const SizedBox(height: 20),

              ///---------------- Card ----------------
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

                    ///---------------- Vertical List ----------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _chartBox("Western Astrology", western, (v) {
                          setState(() => western = v!);
                        }),

                        const SizedBox(height: 10),

                        _chartBox("Vedic Astrology", vedic, (v) {
                          setState(() => vedic = v!);
                        }),

                        const SizedBox(height: 10),

                        _chartBox("13-Signs (Ophiuchus)", sign13, (v) {
                          setState(() => sign13 = v!);
                        }),

                        const SizedBox(height: 10),

                        _chartBox("Evolutionary", evolutionary, (v) {
                          setState(() => evolutionary = v!);
                        }),

                        const SizedBox(height: 10),

                        _lockedBox("Galactic Astrology"),

                        const SizedBox(height: 10),

                        _lockedBox("Human Design Profile  (Type, Strategy, Authority, Profile, Cross)"),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(
                text: "Next",
                onpress: (){Get.toNamed(Routes.reviewPage);},
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  ///---------------- Step Bar ----------------
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

  ///---------------- Enabled Chart Box ----------------
  Widget _chartBox(String title, bool value, Function(bool?) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
            color: CustomColors.secondbackgroundColor
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF8A2BE2),
              checkColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  ///---------------- Locked Premium Box ----------------
  Widget _lockedBox(String title) {
    return InkWell(
      onTap: () {
        CustomAlertdialog(
          onPressed: (){Get.toNamed(Routes.subscriptionPage);},
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
