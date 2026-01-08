import 'package:astrology_app/routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/data/models/chart_models/recent_chart_model.dart';
import 'package:astrology_app/views/pages/ai_reading/saved_charts_details.dart';
import 'package:astrology_app/views/pages/ai_reading/chart_reading_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrology_app/controllers/chart_controller/recent_chart_controller.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final RecentChartController controller = Get.put(RecentChartController());

  @override
  void initState() {
    super.initState();
    controller.fetchRecentCharts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: const Text(
          'Chart',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchRecentCharts(),
        color: const Color(0xFF9A3BFF),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create your chart",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      onTap: () => Get.toNamed(Routes.generateChartScreen),
                      icon: Icons.auto_awesome_outlined,
                      title: "Generate New chart",
                      subtitle: "Create natal, synastry,or transit",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionCard(
                      onTap: () => Get.toNamed(Routes.savedChart),
                      icon: Icons.insert_drive_file_outlined,
                      title: "Saved Charts",
                      subtitle: "Access your collection here",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Charts",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(width: 20),

                  IconButton(
                    onPressed: () {
                      _showDescriptionDialog("Recent charts remove after 7 days");
                    },
                    icon: Icon(Icons.info_outline,
                      color: CustomColors.primaryColor, size: 18,),
                  )
                ],
              ),
              const SizedBox(height: 16),

              /// --- Recent Chart List from API ---
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.recentCharts.isEmpty) {
                  return const Text(
                    "No recent charts found",
                    style: TextStyle(color: Colors.grey),
                  );
                }
                return Column(
                  children: controller.recentCharts.map((chart) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _chartCard(chart: chart),
                    );
                  }).toList(),
                );
              }),

              SizedBox(height: MediaQuery.of(context).size.height / 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff2A2F45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Icon(icon, color: Colors.white, size: 40)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard({required RecentChartModel chart}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 6),
          Text(
            chart.name,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 6),
          Text(
            chart.date,
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 6),
          Text(
            "${chart.city}, ${chart.country}",
            style: const TextStyle(fontSize: 13, color: Color(0xffA0A4B8)),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(() => SavedChartsDetails(recentChart: chart)),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: CustomColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.to(() => ChartReadingPage(recentChart: chart)),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xffA0A4B8)),
                    ),
                    child: const Center(
                      child: Text(
                        "Reading",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          borderRadius: BorderRadius.circular(16),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          },
            child: const Text(
              "Close",
              style: TextStyle(
                  color: Colors.deepPurple
              ),
            ),
          ),
        ],
      );
    },
  );
}
}