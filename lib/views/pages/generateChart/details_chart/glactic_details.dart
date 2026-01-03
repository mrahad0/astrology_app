// lib/views/pages/generateChart/details_chart/glactic_details.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/chart_models/natal_chart_model.dart';

class GalacticDetails extends StatefulWidget {
  const GalacticDetails({super.key});

  @override
  State<GalacticDetails> createState() => _GalacticDetailsState();
}

class _GalacticDetailsState extends State<GalacticDetails> {
  final ChartController controller = Get.find<ChartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {

          NatalChartModel? galacticData;

          if (controller.selectedChartType.value == 'Natal' &&
              controller.natalResponse.value != null) {
            galacticData = controller.natalResponse.value!.charts['galactic'];
          }

          if (galacticData == null) {
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
                        Text("About Galactic Chart",style: TextStyle(color: Colors.white),),),
                        const SizedBox(height: 10),
                        Text("Expands beyond the 12 signs to include stars, galaxies, and cosmic points. Often connected to the concept of “starseeds” – the idea that some souls originated from other star systems like the Pleiades or Sirius, with the chart revealing clues about that origin.",
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
                      _infoRow("Name:", galacticData.name),
                      _infoRow("Date of Birth:", galacticData.birthDate),
                      _infoRow("Birth Time:", galacticData.birthTime),
                      _infoRow("Sun Sign:", galacticData.sunSign),
                      _infoRow("Moon Sign:", galacticData.moonSign),
                      _infoRow("Rising Sign:", galacticData.risingSign),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ---- GALACTIC CHART WHEEL ----
                const Text(
                  "Galactic Chart Wheel",
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
                    child: galacticData.imageUrl.isNotEmpty
                        ? Image.network(
                      galacticData.imageUrl,
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

                /// ---- PLANETARY POSITIONS ----
                const Text(
                  "Galactic Positions",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                ...galacticData.planets.entries.take(8).map((entry) {
                  final planet = entry.value;
                  return _starTile("${planet.name}: ${planet.sign} ${planet.degree.toStringAsFixed(1)}°");
                }),

                const SizedBox(height: 24),

                /// ---- KEY ASPECTS ----
                const Text(
                  "Key Aspects",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                ...galacticData.aspects.take(5).map((aspect) {
                  return _starTile("${aspect.point1} ${aspect.aspect} ${aspect.point2}");
                }),

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

  Widget _starTile(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}