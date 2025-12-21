// lib/views/pages/generateChart/details_chart/humanDesign_details.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HumandesignDetails extends StatefulWidget {
  const HumandesignDetails({super.key});

  @override
  State<HumandesignDetails> createState() => _HumandesignDetails();
}

class _HumandesignDetails extends State<HumandesignDetails> {
  final ChartController controller = Get.find<ChartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // Human Design has different structure - needs special handling
          var humanDesignData;

          if (controller.selectedChartType.value == 'Natal' &&
              controller.natalResponse.value != null) {
            humanDesignData = controller.natalResponse.value!.charts['human_design'];
          }

          if (humanDesignData == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF9A3BFF)),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- INFO CARD ----
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff262A40)),
                    borderRadius: BorderRadius.circular(14),
                    color: CustomColors.secondbackgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Info",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                      _infoRow("Name:", humanDesignData.name),
                      _infoRow("Date of Birth:", humanDesignData.birthDate),
                      _infoRow("Birth Time:", humanDesignData.birthTime),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ---- HUMAN DESIGN CHART ----
                const Text(
                  "Human Design Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                Center(
                  child: Container(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: humanDesignData.imageUrl.isNotEmpty
                        ? Image.network(
                      humanDesignData.imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF9A3BFF),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error,
                              color: Colors.red, size: 50),
                        );
                      },
                    )
                        : Image.asset(
                      "assets/images/chartimage.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// ---- POINTS GRID ----
                Row(
                  children: [
                    Expanded(
                      child: _pointCard(
                        "Type",
                        "Generator",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _pointCard(
                        "Strategy",
                        "To Respond",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _pointCard(
                        "Authority",
                        "Sacral",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _pointCard(
                        "Profile",
                        "3/5",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                CustomButton(
                  text: "Generate",
                  onpress: () {
                    Get.toNamed(Routes.aiComprehensive);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(key,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _pointCard(String title, String subtitle) {
    return Container(
      height: 100,
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}