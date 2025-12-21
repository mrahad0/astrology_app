import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sign13Details extends StatelessWidget {
  const Sign13Details({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.find<ChartController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final response = controller.natalResponse.value;

          if (response == null ||
              !response.charts.containsKey('13_sign')) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9A3BFF),
              ),
            );
          }

          final sign13 = response.charts['13_sign']!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ---------- INFO CARD ----------
                _infoCard(sign13),

                const SizedBox(height: 24),

                /// ---------- CHART IMAGE ----------
                const Text(
                  "13-Signs Chart Wheel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CustomColors.secondbackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: sign13.imageUrl.isNotEmpty
                      ? Image.network(
                    sign13.imageUrl,
                    fit: BoxFit.contain,
                  )
                      : Image.asset(
                    "assets/images/chartimage.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 24),

                /// ---------- PLANETS ----------
                const Text(
                  "Planetary Positions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                ...sign13.planets.entries.map((entry) {
                  final planet = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CustomColors.secondbackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xff2B2F45)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            planet.name,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          "${planet.sign}  ${planet.degree}°",
                          style: const TextStyle(
                            color: Color(0xffA855F7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 40),

                CustomButton(
                  text: "Generate AI Interpretation",
                  onpress: () {
                    Get.toNamed('/ai-comprehensive');
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// ---------- INFO CARD ----------
  Widget _infoCard(sign13) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff262A40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Info",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _infoRow("Name", sign13.name),
          _infoRow("Birth Date", sign13.birthDate),
          _infoRow("Birth Time", sign13.birthTime),
          _infoRow("Sun Sign", sign13.sunSign),
          _infoRow("Moon Sign", sign13.moonSign),
          _infoRow("Rising Sign", sign13.risingSign),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
