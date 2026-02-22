import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/base/pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controllers/chart_controller/saved_chart_controller.dart';
import '../../../../../data/models/chart_models/saved_chart_model.dart';
import '../../../../base/custom_button.dart';
import '../../../ai_reading/saved_charts_details.dart';

class AstroDataScreen extends StatefulWidget {
  const AstroDataScreen({super.key});

  @override
  State<AstroDataScreen> createState() => AstroDataScreenState();
}

class AstroDataScreenState extends State<AstroDataScreen> {
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
        title: "Astro Data",
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.savedCharts.isEmpty) {
              return const Center(
                child: Text(
                  "No saved charts",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),

                  // Chart cards for current page
                  ...controller.paginatedCharts.map((chart) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
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

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            );
          }),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.generateChartScreen);
        },
        backgroundColor: CustomColors.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Astro Data',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _chartCard({required SavedChartModel chart}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${chart.chartCategory} (${chart.systemDisplayName})",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            chart.name,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          Text(
            chart.date,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 4),
          Text(
            "${chart.city}, ${chart.country}",
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 18),
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
