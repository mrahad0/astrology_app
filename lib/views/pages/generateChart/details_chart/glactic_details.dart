// lib/views/pages/generateChart/details_chart/glactic_details.dart
import 'package:astrology_app/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart';
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/controllers/ai_compresive/ai_compresive_controller.dart';
import 'package:astrology_app/controllers/chart_controller/chart_controller.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
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

  // Ordered section keys matching the user's requirements
  static const List<String> _sectionOrder = [
    'Celestial',
    'Royal Stars',
    'Galactic Fixed Stars',
    'Starseed Origin Indicator',
    'Black Holes',
    'Dwarf Planets',
    'Asteroids',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/generateChart_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: Obx(() {
          NatalChartModel? galacticData;

          if (controller.selectedChartType.value == 'Natal' &&
              controller.natalResponse.value != null) {
            galacticData = controller.natalResponse.value!.charts['galactic'];
          }

          if (galacticData == null) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF9A3BFF),
                strokeWidth: ResponsiveHelper.width(4),
              ),
            );
          }

          final sections = galacticData.sections;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- INFO CARD ----
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff262A40)),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                    color: CustomColors.secondbackgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Info",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(18),
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: ResponsiveHelper.space(20)),
                      _infoRow("Name:", galacticData.name),
                      _infoRow("Date of Birth:", galacticData.birthDate),
                      _infoRow("Birth Time:", galacticData.birthTime),
                      _infoRow("Time Zone:", galacticData.location.timezone.isNotEmpty ? galacticData.location.timezone : "N/A"),
                      _infoRow("Birth City:", galacticData.location.city.isNotEmpty ? galacticData.location.city : "N/A"),
                      _infoRow("Birth Country:", galacticData.location.country.isNotEmpty ? galacticData.location.country : "N/A"),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- GALACTIC ASTROLOGY CHART ----
                Text(
                  "Galactic Astrology",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(17),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: ResponsiveHelper.space(16)),

                ZoomableChartImage(
                  imageUrl: galacticData.imageUrl,
                  height: ResponsiveHelper.height(350),
                ),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- DYNAMIC SECTIONS ----
                ..._sectionOrder.where((key) => sections.containsKey(key)).map((sectionKey) {
                  final items = sections[sectionKey]!;
                  if (items.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sectionKey,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(17),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.space(12)),
                      ...items.map((item) {
                        if (item is Map) {
                          final data = Map<String, dynamic>.from(item);
                          return _buildSectionItem(sectionKey, data);
                        }
                        return const SizedBox.shrink();
                      }),
                      SizedBox(height: ResponsiveHelper.space(16)),
                    ],
                  );
                }),

                SizedBox(height: ResponsiveHelper.space(24)),

                /// ---- GENERATE READING ----
                Obx(() => CustomButton(
                  text: "Generate Reading",
                  isLoading: controller.isGeneratingInterpretation.value,
                  onpress: () async {
                    controller.isGeneratingInterpretation.value = true;
                    final interpretationController = Get.find<InterpretationController>();
                    final charts = controller.getChartIdsForInterpretation();
                    final info = controller.getChartInfo();
                    await interpretationController.getMultipleInterpretations(charts, info);
                    controller.isGeneratingInterpretation.value = false;
                    Get.toNamed(Routes.aiComprehensive);
                  },
                )),

                SizedBox(height: ResponsiveHelper.space(20)),
              ],
            ),
          );
        }),
      ),
     ),
    );
  }

  // ==================== SECTION ITEM BUILDERS ====================

  Widget _buildSectionItem(String sectionKey, Map<String, dynamic> data) {
    switch (sectionKey) {
      case 'Celestial':
        return _celestialTile(data);
      case 'Royal Stars':
        return _celestialTile(data);
      case 'Galactic Fixed Stars':
        return _fixedStarTile(data);
      case 'Starseed Origin Indicator':
        return _starseedTile(data);
      case 'Black Holes':
        return _blackHoleTile(data);
      case 'Dwarf Planets':
        return _dwarfPlanetTile(data);
      case 'Asteroids':
        return _dwarfPlanetTile(data);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Celestial & Royal Stars: name, sign, degree, house_label, meaning
  Widget _celestialTile(Map<String, dynamic> data) {
    final name = data['name'] ?? '';
    final sign = data['sign'] ?? '';
    final degree = data['degree']?.toString() ?? '';
    final houseLabel = data['house_label'] ?? data['house_name'] ?? '';
    final meaning = data['meaning'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '$name: ',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              ),
              TextSpan(
                text: sign,
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: ResponsiveHelper.fontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (degree.isNotEmpty)
                TextSpan(
                  text: ' $degree°',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
              if (houseLabel.isNotEmpty)
                TextSpan(
                  text: ' in $houseLabel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
            ]),
          ),
          if (meaning.isNotEmpty) ...[
            SizedBox(height: ResponsiveHelper.space(4)),
            Text(
              meaning,
              style: TextStyle(
                color: Colors.white38,
                fontSize: ResponsiveHelper.fontSize(12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Galactic Fixed Stars: star, planet, constellation, separation, meaning
  Widget _fixedStarTile(Map<String, dynamic> data) {
    final star = data['star'] ?? '';
    final planet = data['planet'] ?? '';
    final constellation = data['constellation'] ?? '';
    final separation = data['separation']?.toString() ?? '';
    final meaning = data['meaning'] ?? '';
    final exact = data['exact'] == true;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: star,
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: ResponsiveHelper.fontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' conjunct $planet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              ),
              if (constellation.isNotEmpty)
                TextSpan(
                  text: ' ($constellation)',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: ResponsiveHelper.fontSize(13),
                  ),
                ),
            ]),
          ),
          SizedBox(height: ResponsiveHelper.space(4)),
          Row(
            children: [
              Text(
                'Orb: $separation°',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: ResponsiveHelper.fontSize(12),
                ),
              ),
              if (exact) ...[
                SizedBox(width: ResponsiveHelper.space(8)),
                Text(
                  '(Exact)',
                  style: TextStyle(
                    color: CustomColors.primaryColor,
                    fontSize: ResponsiveHelper.fontSize(12),
                  ),
                ),
              ],
            ],
          ),
          if (meaning.isNotEmpty) ...[
            SizedBox(height: ResponsiveHelper.space(4)),
            Text(
              meaning,
              style: TextStyle(
                color: Colors.white38,
                fontSize: ResponsiveHelper.fontSize(12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Starseed Origin Indicator: display text, meaning
  Widget _starseedTile(Map<String, dynamic> data) {
    final display = data['display'] ?? '';
    final meaning = data['meaning'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            display,
            style: TextStyle(
              color: CustomColors.primaryColor,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (meaning.isNotEmpty) ...[
            SizedBox(height: ResponsiveHelper.space(4)),
            Text(
              meaning,
              style: TextStyle(
                color: Colors.white54,
                fontSize: ResponsiveHelper.fontSize(12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Black Holes: title, subtitle, planet, orb_text, display
  Widget _blackHoleTile(Map<String, dynamic> data) {
    final title = data['title'] ?? data['name'] ?? '';
    final subtitle = data['subtitle'] ?? '';
    final planet = data['planet'] ?? '';
    final orbText = data['orb_text'] ?? '';
    final exact = data['exact'] == true;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: title,
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: ResponsiveHelper.fontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' conjunct $planet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              ),
            ]),
          ),
          SizedBox(height: ResponsiveHelper.space(4)),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white54,
              fontSize: ResponsiveHelper.fontSize(13),
            ),
          ),
          if (orbText.isNotEmpty) ...[
            SizedBox(height: ResponsiveHelper.space(2)),
            Row(
              children: [
                Text(
                  'Orb: $orbText',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: ResponsiveHelper.fontSize(12),
                  ),
                ),
                if (exact) ...[
                  SizedBox(width: ResponsiveHelper.space(8)),
                  Text(
                    '(Exact)',
                    style: TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: ResponsiveHelper.fontSize(12),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Dwarf Planets & Asteroids: name, sign, house_label, placement, display
  Widget _dwarfPlanetTile(Map<String, dynamic> data) {
    final name = data['name'] ?? '';
    final sign = data['sign'] ?? '';
    final houseLabel = data['house_label'] ?? data['house_name'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(14)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '$name: ',
            style: TextStyle(
              color: Colors.white70,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          TextSpan(
            text: sign,
            style: TextStyle(
              color: CustomColors.primaryColor,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (houseLabel.isNotEmpty)
            TextSpan(
              text: ' in $houseLabel',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
        ]),
      ),
    );
  }

  // ==================== COMMON WIDGETS ====================

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveHelper.width(110),
            child: Text(key,
                style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14))),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
          ),
        ],
      ),
    );
  }
}
