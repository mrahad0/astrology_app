// lib/views/pages/generateChart/details_chart/western_datails.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/chart_models/transit_chart_model.dart';

class WesternDatails extends StatefulWidget {
  const WesternDatails({super.key});

  @override
  State<WesternDatails> createState() => _WesternDatailsState();
}

class _WesternDatailsState extends State<WesternDatails> {
  final ChartController controller = Get.find<ChartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // Check which chart type is selected
          if (controller.selectedChartType.value == 'Natal') {
            return _buildNatalChart();
          } else if (controller.selectedChartType.value == 'Transit') {
            return _buildTransitChart();
          } else if (controller.selectedChartType.value == 'Synastry') {
            return _buildSynastryChart();
          }

          return const Center(
            child: Text('No data available', style: TextStyle(color: Colors.white)),
          );
        }),
      ),
    );
  }

  // ==================== NATAL CHART ====================
  Widget _buildNatalChart() {
    final westernData = controller.natalResponse.value?.charts['western'];

    if (westernData == null) {
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
                Text("About Western Chart",style: TextStyle(color: Colors.white),),),
                const SizedBox(height: 10),
                Text("Based on the seasons. Your sign reflects where the Sun was relative to the spring equinox. More focused on personality, psychology, and self-understanding.",
                     style:TextStyle(color: Colors.white) ,
                ),
              ]
            ),
          ),

          const SizedBox(height: 24),

          /// Info Card
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
                _infoRow("Name:", westernData.name),
                _infoRow("Date of Birth:", westernData.birthDate),
                _infoRow("Birth Time:", westernData.birthTime),
                _infoRow("Sun Sign:", westernData.sunSign),
                _infoRow("Moon Sign:", westernData.moonSign),
                _infoRow("Rising Sign:", westernData.risingSign),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Chart Wheel
          const Text(
            "Western Chart Wheel",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          Center(
            child: SizedBox(
              height: 350,
              width: MediaQuery.of(context).size.width,
              child: westernData.imageUrl.isNotEmpty
                  ? Image.network(
                westernData.imageUrl,
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

          /// Planetary Positions
          const Text(
            "Planetary Positions",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          ...westernData.planets.entries.take(10).map((entry) {
            final planet = entry.value;
            return _planetTile(
              planet.name,
              "${planet.sign} in ${planet.house}",
            );
          }),

          const SizedBox(height: 24),

          /// Key Aspects
          const Text(
            "Key Aspects",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          ...westernData.aspects.take(5).map((aspect) {
            return _aspectTile(
              "${aspect.point1} ${aspect.aspect} ${aspect.point2}",
              "orb: ${aspect.orb.toStringAsFixed(1)}°",
            );
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
  }

  // ==================== TRANSIT CHART ====================
  Widget _buildTransitChart() {
    final transitData = controller.transitResponse.value?.results['western'];

    if (transitData == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF9A3BFF)),
      );
    }

    final imageUrl = controller.transitResponse.value?.images['western'] ?? '';

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
                  Text("About Western Chart",style: TextStyle(color: Colors.white),),),
                  const SizedBox(height: 10),
                  Text("Based on the seasons. Your sign reflects where the Sun was relative to the spring equinox. More focused on personality, psychology, and self-understanding.",
                    style:TextStyle(color: Colors.white) ,
                  ),
                ]
            ),
          ),

          const SizedBox(height: 24),

          /// Info Card
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
                const Text("Transit Info",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                _infoRow("Name:", transitData.profileName),
                _infoRow("Transit Date:", transitData.transitDate),
                _infoRow("Overall Quality:", transitData.overallQuality),
                _infoRow("Significant Aspects:", transitData.significantAspects.toString()),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Chart Image
          const Text(
            "Transit Chart",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          Center(
            child: SizedBox(
              height: 350,
              width: MediaQuery.of(context).size.width,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
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

          /// Active Transits
          const Text(
            "Active Transits",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          if (transitData.transits.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomColors.secondbackgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xff2B2F45)),
              ),
              child: const Text(
                "No significant transits at this time",
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            ...transitData.transits.map((transit) {
              return _transitTile(transit);
            }),

          const SizedBox(height: 24),

          /// Interpretation
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
                const Text("Interpretation",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text(
                  transitData.interpretation,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
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
  }

  // ==================== SYNASTRY CHART ====================
  Widget _buildSynastryChart() {
    final synastryData = controller.synastryResponse.value?.results['western'];

    if (synastryData == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF9A3BFF)),
      );
    }

    final imageUrl = controller.synastryResponse.value?.images['western'] ?? '';

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
                  Text("About Western Chart",style: TextStyle(color: Colors.white),),),
                  const SizedBox(height: 10),
                  Text("Based on the seasons. Your sign reflects where the Sun was relative to the spring equinox. More focused on personality, psychology, and self-understanding.",
                    style:TextStyle(color: Colors.white) ,
                  ),
                ]
            ),
          ),

          const SizedBox(height: 24),

          /// Info Card
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
                const Text("Synastry Info",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                _infoRow("Partner 1:", synastryData.profile1Name),
                _infoRow("Partner 2:", synastryData.profile2Name),
                _infoRow("Compatibility Score:", "${synastryData.compatibilityScore.toStringAsFixed(1)}%"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Chart Image
          const Text(
            "Synastry Chart",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          Center(
            child: SizedBox(
              height: 350,
              width: MediaQuery.of(context).size.width,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
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

          /// Key Aspects
          const Text(
            "Relationship Aspects",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          ...synastryData.aspects.take(10).map((aspect) {
            return _aspectTile(
              "${aspect.point1} ${aspect.aspect} ${aspect.point2}",
              "orb: ${aspect.orb.toStringAsFixed(1)}°",
            );
          }),

          const SizedBox(height: 24),

          /// Interpretation
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
                const Text("Interpretation",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Text(
                  synastryData.interpretation,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
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
  }

  // ==================== HELPER WIDGETS ====================

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

  Widget _planetTile(String planet, String detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Row(
        children: [
          Text("$planet:",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child:
            Text(detail, style: const TextStyle(color: Color(0xffA4A9C1))),
          ),
        ],
      ),
    );
  }

  Widget _aspectTile(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Color(0xffFF6B9D), fontWeight: FontWeight.w600)),
          ),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _transitTile(TransitModel transit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${transit.planet} ${transit.aspect}",
                style: const TextStyle(
                    color: Color(0xffFF6B9D), fontWeight: FontWeight.w600),
              ),
              Text(
                "orb: ${transit.orb.toStringAsFixed(1)}°",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Natal: ${transit.natalPosition} → Transit: ${transit.transitPosition}",
            style: const TextStyle(color: Color(0xffA4A9C1), fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            transit.interpretation,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}