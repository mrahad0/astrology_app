import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReviewGeneratePage extends StatelessWidget {
  const ReviewGeneratePage({super.key});

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

              /// ----------- PROGRESS BAR -----------
              Row(
                children: [
                  _stepBar(true),
                  _stepBar(true),
                  _stepBar(true),
                  _stepBar(true),
                ],
              ),

              const SizedBox(height: 20),

              /// ----------- DETAILS CARD -----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2F3448)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Review & Generate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _infoRow("Chart Type:", "Natal Chart"),
                    _infoRow("Name:", "Sadiqul"),
                    _infoRow("Date of Birth:", "11/13/2005"),
                    _infoRow("Birth Time:", "7:00 pm"),
                    _infoRow("Time Zone:", "GMT+6"),
                    _infoRow("Birth City:", "Dhaka"),
                    _infoRow("Birth Country:", "Bangladesh"),
                  ],
                ),
              ),

              const SizedBox(height: 60),


              /// ----------- BUTTON -----------

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2BE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {Get.toNamed(Routes.mainDetailChart);},
                  child: const Text(
                    "Generate Chart",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// PROGRESS BAR ITEM
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

  /// INFO ROW
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
