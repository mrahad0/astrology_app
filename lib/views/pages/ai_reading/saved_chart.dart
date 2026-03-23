// lib/views/pages/ai_reading/saved_chart.dart
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chart_controller/saved_chart_controller.dart';
import '../../../data/models/chart_models/saved_chart_model.dart';
import '../../base/custom_appBar.dart';
import '../../base/custom_button.dart';
import '../../base/pagination_widget.dart';
import '../../../utils/color.dart';
import 'saved_charts_details.dart';

class SavedChart extends StatefulWidget {
  const SavedChart({super.key});

  @override
  State<SavedChart> createState() => _SavedChartState();
}

class _SavedChartState extends State<SavedChart> {
  final controller = Get.put(SavedChartController());

  @override
  void initState() {
    super.initState();
    controller.fetchSavedCharts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Saved Chart",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF9A3BFF),
                strokeWidth: ResponsiveHelper.width(4),
              ),
            );
          }
          if (controller.savedCharts.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => controller.fetchSavedCharts(),
              color: const Color(0xFF9A3BFF),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Text(
                      "No saved charts",
                      style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
                    ),
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => controller.fetchSavedCharts(),
            color: const Color(0xFF9A3BFF),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ResponsiveHelper.space(22)),

                  // Chart cards for current page
                  ...controller.paginatedCharts.map((chart) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(14)),
                      child: _chartCard(chart: chart),
                    );
                  }),

                  // Pagination widget
                  if (controller.totalPages > 1)
                    PaginationWidget(
                      currentPage: controller.currentPage.value,
                      totalPages: controller.totalPages,
                      onPageChanged: (page) => controller.changePage(page),
                    ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _chartCard({required SavedChartModel chart}) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(18)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${chart.chartCategory} (${chart.systemDisplayName})",
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(16),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(4)),
          Text(
            chart.name,
            style: TextStyle(fontSize: ResponsiveHelper.fontSize(13), color: const Color(
                0xffa0a3b8)),
          ),
          SizedBox(height: ResponsiveHelper.space(4)),
          Text(
            chart.date,
            style: TextStyle(fontSize: ResponsiveHelper.fontSize(13), color: const Color(0xffA0A4B8)),
          ),
          SizedBox(height: ResponsiveHelper.space(4)),
          Text(
            "${chart.city}, ${chart.country}",
            style: TextStyle(fontSize: ResponsiveHelper.fontSize(13), color: const Color(0xffA0A4B8)),
          ),
          SizedBox(height: ResponsiveHelper.space(18)),
          CustomButton(
            text: "View",
            onpress: () {
              Get.to(() => SavedChartsDetails(savedChart: chart));
            },
          ),
        ],
      ),
    );
  }
}
