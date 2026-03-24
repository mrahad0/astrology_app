// lib/views/pages/generateChart/review_Tab.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/chart_controller/chart_controller.dart';
import '../../base/custom_snackBar.dart';

class ReviewGeneratePage extends StatelessWidget {
  const ReviewGeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

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
            onPressed: () => Navigator.pop(context),
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
                  _stepBar(true),
                ],
              ),

              SizedBox(height: ResponsiveHelper.space(20)),

              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
                    decoration: BoxDecoration(
                      color: CustomColors.secondbackgroundColor,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
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

              SizedBox(height: ResponsiveHelper.space(20)),

              // GENERATE BUTTON API CALL
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Generating charts...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(24)
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.space(10)),
                          CircularProgressIndicator(color: Colors.white,)
                        ],
                      )
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  height: ResponsiveHelper.height(52),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A2BE2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                      ),
                    ),
                    onPressed: () async {
                      bool success = await controller.generateChart();
                      if (success) {
                        Get.toNamed(Routes.mainDetailChart);
                      } else {
                        showCustomSnackBar("Failed to generate chart",
                            isError: true);
                      }
                    },
                    child: Text(
                      "Generate Chart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(16),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }),

              SizedBox(height: ResponsiveHelper.space(20)),
            ],
          ),
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
        Text(
          "Review & Generate",
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.fontSize(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveHelper.space(20)),
        _infoRow("Chart Type:", "Natal Chart"),
        _infoRow("Name:", data['name'] ?? '-'),
        _infoRow("Date of Birth:",
            date != null ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}" : '-'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Review & Generate",
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.fontSize(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveHelper.space(20)),
        _infoRow("Chart Type:", "Transit Chart"),
        _infoRow("Transit Date:", futureDate != null
            ? "${futureDate.day.toString().padLeft(2, '0')}/${futureDate.month.toString().padLeft(2, '0')}/${futureDate.year}"
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
        Text(
          "Review & Generate",
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.fontSize(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveHelper.space(20)),
        _infoRow("Chart Type:", "Synastry Chart"),
        SizedBox(height: ResponsiveHelper.space(10)),
        Text(
          "Partner 1:",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.space(8)),
        _infoRow("Name:", partner1?['name'] ?? '-'),
        _infoRow("Date of Birth:", date1 != null
            ? "${date1.day.toString().padLeft(2, '0')}/${date1.month.toString().padLeft(2, '0')}/${date1.year}"
            : '-'),
        _infoRow("Birth Time:", time1 != null
            ? "${time1.hour}:${time1.minute.toString().padLeft(2, '0')}"
            : '-'),
        _infoRow("Birth City:", partner1?['birthCity'] ?? '-'),
        _infoRow("Birth Country:", partner1?['birthCountry'] ?? '-'),
        SizedBox(height: ResponsiveHelper.space(15)),
        Text(
          "Partner 2:",
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveHelper.space(8)),
        _infoRow("Name:", partner2?['name'] ?? '-'),
        _infoRow("Date of Birth:", date2 != null
            ? "${date2.day.toString().padLeft(2, '0')}/${date2.month.toString().padLeft(2, '0')}/${date2.year}"
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
        height: ResponsiveHelper.height(4),
        margin: EdgeInsets.only(right: ResponsiveHelper.space(8)),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF8A2BE2) : Colors.white24,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.width(120),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          )
        ],
      ),
    );
  }
}