// lib/views/pages/generateChart/details_chart/evolutionary_details.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/ai_compresive/ai_compresive_controller.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/chart_models/natal_chart_model.dart';

class EvolutionaryDetails extends StatefulWidget {
  const EvolutionaryDetails({super.key});

  @override
  State<EvolutionaryDetails> createState() => _EvolutionaryDetailsState();
}

class _EvolutionaryDetailsState extends State<EvolutionaryDetails> {
  final ChartController controller = Get.find<ChartController>();
  bool isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          NatalChartModel? evolutionaryData;

          if (controller.selectedChartType.value == 'Natal' &&
              controller.natalResponse.value != null) {
            evolutionaryData = controller.natalResponse.value!.charts['evolutionary'];
          }

          if (evolutionaryData == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF9A3BFF)),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        Center(child:
                        Text("About Evolutionary Chart",style: TextStyle(color: Colors.white),),),
                        const SizedBox(height: 10),
                        Text("Less about personality traits and more about soul purpose – what you are here to learn this lifetime.\nIt views your chart as a story of growth: the patterns you carry from the past and what you are meant to evolve toward.",
                          style:TextStyle(color: Colors.white) ,
                        ),
                      ]
                  ),
                ),
                const SizedBox(height: 24),
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
                      _infoRow("Name:", evolutionaryData.name),
                      _infoRow("Date of Birth:", evolutionaryData.birthDate),
                      _infoRow("Birth Time:", evolutionaryData.birthTime),
                      _infoRow("Sun Sign:", evolutionaryData.sunSign),
                      _infoRow("Moon Sign:", evolutionaryData.moonSign),
                      _infoRow("Rising Sign:", evolutionaryData.risingSign),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ---- EVOLUTIONARY POINTS CHART ----
                const Text(
                  "Evolutionary Chart",
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
                    child: evolutionaryData.imageUrl.isNotEmpty
                        ? Image.network(
                      evolutionaryData.imageUrl,
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
                        "North Node",
                        evolutionaryData.planets['North Node']?.sign ?? '-',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _pointCard(
                        "South Node",
                        evolutionaryData.planets['South Node']?.sign ?? '-',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _pointCard(
                        "Pluto",
                        evolutionaryData.planets['Pluto']?.sign ?? '-',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _pointCard(
                        "Chiron",
                        evolutionaryData.planets['Chiron']?.sign ?? '-',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                CustomButton(
                  text: "Generate",
                  isLoading: isGenerating,
                  onpress: () async {
                    setState(() => isGenerating = true);
                    final interpretationController = Get.put(InterpretationController());
                    final charts = controller.getChartIdsForInterpretation();
                    final info = controller.getChartInfo();
                    await interpretationController.getMultipleInterpretations(charts, info);
                    setState(() => isGenerating = false);
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