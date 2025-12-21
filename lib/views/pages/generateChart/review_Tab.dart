// lib/views/pages/generateChart/review_Tab.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/chart_controller/chart_controller.dart';

class ReviewGeneratePage extends StatelessWidget {
  const ReviewGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

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
                  _stepBar(true),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomColors.secondbackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF2F3448)),
                    ),
                    child: Obx(() {
                      final chartType = controller.selectedChartType.value;
                      final data = controller.chartData;

                      if (chartType == 'Natal') {
                        return _buildNatalReview(data);
                      } else if (chartType == 'Transit') {
                        return _buildTransitReview(data);
                      } else if (chartType == 'Synastry') {
                        return _buildSynastryReview(data);
                      }

                      return const SizedBox.shrink();
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🚀 GENERATE BUTTON WITH API CALL
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A2BE2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      bool success = await controller.generateChart();
                      if (success) {
                        Get.toNamed(Routes.mainDetailChart);
                      } else {
                        // Show error
                        Get.snackbar(
                          'Error',
                          controller.errorMessage.value,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: const Text(
                      "Generate Chart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNatalReview(RxMap<String, dynamic> data) {
    final date = data['dateOfBirth'] as DateTime?;
    final time = data['birthTime'] as TimeOfDay?;

    return Column(
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
        _infoRow("Name:", data['name'] ?? '-'),
        _infoRow("Date of Birth:",
            date != null ? "${date.month}/${date.day}/${date.year}" : '-'),
        _infoRow("Birth Time:", time != null
            ? "${time.hour}:${time.minute.toString().padLeft(2, '0')}"
            : '-'),
        _infoRow("Time Zone:", "GMT+6"),
        _infoRow("Birth City:", data['birthCity'] ?? '-'),
        _infoRow("Birth Country:", data['birthCountry'] ?? '-'),
      ],
    );
  }

  Widget _buildTransitReview(RxMap<String, dynamic> data) {
    final futureDate = data['futureDate'] as DateTime?;
    final pastDate = data['pastDate'] as DateTime?;

    return Column(
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
        _infoRow("Chart Type:", "Transit Chart"),
        _infoRow("Future Date:", futureDate != null
            ? "${futureDate.day}/${futureDate.month}/${futureDate.year}"
            : '-'),
        _infoRow("Past Date:", pastDate != null
            ? "${pastDate.day}/${pastDate.month}/${pastDate.year}"
            : '-'),
      ],
    );
  }

  Widget _buildSynastryReview(RxMap<String, dynamic> data) {
    final partner1 = data['partner1'] as Map<String, dynamic>?;
    final partner2 = data['partner2'] as Map<String, dynamic>?;

    final date1 = partner1?['dateOfBirth'] as DateTime?;
    final time1 = partner1?['birthTime'] as TimeOfDay?;

    final date2 = partner2?['dateOfBirth'] as DateTime?;
    final time2 = partner2?['birthTime'] as TimeOfDay?;

    return Column(
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
        _infoRow("Chart Type:", "Synastry Chart"),
        const SizedBox(height: 10),
        const Text(
          "Partner 1:",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _infoRow("Name:", partner1?['name'] ?? '-'),
        _infoRow("Date of Birth:", date1 != null
            ? "${date1.month}/${date1.day}/${date1.year}"
            : '-'),
        _infoRow("Birth Time:", time1 != null
            ? "${time1.hour}:${time1.minute.toString().padLeft(2, '0')}"
            : '-'),
        _infoRow("Birth City:", partner1?['birthCity'] ?? '-'),
        _infoRow("Birth Country:", partner1?['birthCountry'] ?? '-'),
        const SizedBox(height: 15),
        const Text(
          "Partner 2:",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _infoRow("Name:", partner2?['name'] ?? '-'),
        _infoRow("Date of Birth:", date2 != null
            ? "${date2.month}/${date2.day}/${date2.year}"
            : '-'),
        _infoRow("Birth Time:", time2 != null
            ? "${time2.hour}:${time2.minute.toString().padLeft(2, '0')}"
            : '-'),
        _infoRow("Birth City:", partner2?['birthCity'] ?? '-'),
        _infoRow("Birth Country:", partner2?['birthCountry'] ?? '-'),
      ],
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