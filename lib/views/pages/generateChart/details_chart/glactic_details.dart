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

  // Ordered section keys matching the current backend model
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (controller.selectedChartType.value == 'Natal') {
          return _buildNatalChart();
        } else if (controller.selectedChartType.value == 'Transit') {
          return _buildTransitChart();
        } else if (controller.selectedChartType.value == 'Synastry') {
          return _buildSynastryChart();
        }

        return Center(
          child: Text(
            'No data available',
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(16)),
          ),
        );
      }),
    );
  }

  // ==================== NATAL VIEW ====================
  Widget _buildNatalChart() {
    final realData = controller.natalResponse.value?.charts['galactic'];
    
    // MOCK DATA for "Frontend Only" state
    final mockInfo = {
      'name': 'Sadiqul',
      'dob': '11/13/2005',
      'time': '7:00 pm',
      'timezone': 'GMT+6',
      'cityCountry': 'Dhaka, Bangladesh',
    };

    final Map<String, List<dynamic>> mockSections = {
      'Celestial': [
        {'name': 'Galactic Center', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Super Galactic Center (M87)', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Great Attractor', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Shapley Attractor', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
      ],
      'Royal Stars': [
        {'name': 'Aldebaran', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Regulus', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Antares', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Fomalhaut', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
      'Galactic Fixed Stars': [
        {'star': 'Sirius', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Vega', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Pleiades', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Arcturus', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Andromeda Galaxy', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Andromeda (Alpheratz)', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Andromeda (Almach)', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Orion', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Mintaka', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Antares', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Spica', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Lyra', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
      ],
      'Starseed Origin Indicator (0° - 2°)': [
        {'display': 'Sun conjunct Mintaka – orb 0°44\'', 'meaning': ''},
        {'display': 'Moon conjunct Merope – orb 0°44\'', 'meaning': ''},
        {'display': 'Ascendant conjunct Merope – orb 0°44\'', 'meaning': ''},
        {'display': 'MC conjunct Lyra orb 0°44\'', 'meaning': ''},
        {'display': 'Mercury conjunct Mintaka – orb 0°44\'', 'meaning': ''},
        {'display': 'Venus conjunct Mintaka – orb 0°44\'', 'meaning': ''},
        {'display': 'North Node conjunct Lyra orb 0°44\'', 'meaning': ''},
        {'display': 'South Node conjunct orb 0°44\'', 'meaning': ''},
        {'display': 'Chiron conjunct orb 0°44\'', 'meaning': ''},
        {'display': 'IC conjunct Lyra orb 0°44\'', 'meaning': ''},
        {'display': 'DC conjunct Lyra orb 0°44\'', 'meaning': ''},
      ],
      'Black Holes': [
        {'title': 'Cygnus X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'Scorpius X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'Hercules X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'Vela X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'GX 339-4', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'SS 433', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': '4U 1700-37', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'GRS 1915+105', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'Perseus Galaxy (NGC 1277)', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'Canes Venatici (TON 618)', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
      ],
      'Dwarf Planet': [
        {'name': 'Ceres', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Pallas', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Juno', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Vesta', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Pholus', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Eris', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Haumea', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Ixion', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Makemake', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Orcus', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Quaoar', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Sedna', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Varuna', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Salacia', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Varda', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Gonggong', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
      'Asteroids': [
        {'name': 'Chiron', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Hygiea', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Astraea', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Iris', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Flora', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Hebe', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Psyche', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Eros', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Lilith (H58)', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Phaethon', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Icarus', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Tisiphone', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Benu', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Ryuju', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Apophis', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Karma', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Spirit', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Angel', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Nemesis', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Fortune', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Sophrosyne', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Atlantis', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Osiris', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Amor', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Daphne', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Nessus', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Medusa', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Pandora', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Algol', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Medea', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Hecate', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Child', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Vertex', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Lilith (Mean)', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Lilith (True)', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
    };

    final List<String> currentSectionOrder = [
      'Celestial',
      'Royal Stars',
      'Galactic Fixed Stars',
      'Starseed Origin Indicator (0° - 2°)',
      'Black Holes',
      'Dwarf Planet',
      'Asteroids',
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),

          /// ---- INFO CARD ----
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
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
                _infoRow("Name:", mockInfo['name']!),
                _infoRow("Date of Birth:", mockInfo['dob']!),
                _infoRow("Birth Time:", mockInfo['time']!),
                _infoRow("Time Zone:", mockInfo['timezone']!),
                _infoRow(
                  "Birth City / Birth Country:",
                  mockInfo['cityCountry']!,
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- GALACTIC ASTROLOGY CHART TITLE ----
          Text(
            "Galactic Astrology",
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(17),
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),

          /// ---- CHART IMAGE ----
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realData?.imageUrl ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/galactic_chart.png", 
              height: ResponsiveHelper.height(320),
            ),
          ),

          SizedBox(height: ResponsiveHelper.space(24)),

          /// ---- DYNAMIC SECTIONS ----
          ...currentSectionOrder.where((key) => mockSections.containsKey(key)).map((sectionKey) {
            final items = mockSections[sectionKey]!;
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

          SizedBox(height: ResponsiveHelper.space(40)),

          CustomButton(
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
          ),

          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  // ==================== TRANSIT VIEW ====================
  Widget _buildTransitChart() {
    final realImage = controller.transitResponse.value?.images['galactic'];

    final mockTransitInfo = {
      'name': 'Sadiqul',
      'transitDate': 'June 14, 2024',
      'quality': 'Expansive',
    };

    final Map<String, List<dynamic>> mockSections = {
      'Celestial': [
        {'name': 'Galactic Center', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Super Galactic Center (M87)', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Great Attractor', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Shapley Attractor', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
      ],
      'Royal Stars': [
        {'name': 'Aldebaran', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Regulus', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Antares', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Fomalhaut', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
      'Galactic Fixed Stars': [
        {'star': 'Sirius', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Vega', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Pleiades', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Arcturus', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
      ],
      'Starseed Origin Indicator (0° - 2°)': [
        {'display': 'Sun conjunct Mintaka – orb 0°44\'', 'meaning': ''},
        {'display': 'Moon conjunct Merope – orb 0°44\'', 'meaning': ''},
      ],
      'Black Holes': [
        {'title': 'Cygnus X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'Scorpius X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
      ],
      'Dwarf Planet': [
        {'name': 'Ceres', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Pallas', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
      'Asteroids': [
        {'name': 'Chiron', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Hygiea', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
    };

    final List<String> currentSectionOrder = [
      'Celestial',
      'Royal Stars',
      'Galactic Fixed Stars',
      'Starseed Origin Indicator (0° - 2°)',
      'Black Holes',
      'Dwarf Planet',
      'Asteroids',
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Transit Info",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.w600)),
                SizedBox(height: ResponsiveHelper.space(20)),
                _infoRow("Name:", mockTransitInfo['name']!),
                _infoRow("Transit Date:", mockTransitInfo['transitDate']!),
                _infoRow("Overall Quality:", mockTransitInfo['quality']!),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Galactic Transit Chart Wheel",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/galactic_transit.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          ...currentSectionOrder.where((key) => mockSections.containsKey(key)).map((sectionKey) {
            final items = mockSections[sectionKey]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sectionKey, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
                SizedBox(height: ResponsiveHelper.space(12)),
                ...items.map((item) => _buildSectionItem(sectionKey, Map<String, dynamic>.from(item))),
                SizedBox(height: ResponsiveHelper.space(16)),
              ],
            );
          }),
          SizedBox(height: ResponsiveHelper.space(40)),
          CustomButton(
            text: "Generate Reading",
            isLoading: controller.isGeneratingInterpretation.value,
            onpress: () {},
          ),
          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  // ==================== SYNASTRY VIEW ====================
  Widget _buildSynastryChart() {
    final realImage = controller.synastryResponse.value?.images['galactic'];

    final mockSynastryInfo = {
      'partner1': 'Sadiqul',
      'partner2': 'Sarah',
      'score': '80%',
    };

    final Map<String, List<dynamic>> mockSections = {
      'Celestial': [
        {'name': 'Galactic Center', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Super Galactic Center (M87)', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Great Attractor', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
        {'name': 'Shapley Attractor', 'sign': 'Gemini', 'degree': '', 'house_label': '9th House'},
      ],
      'Royal Stars': [
        {'name': 'Aldebaran', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Regulus', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Antares', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Fomalhaut', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
      'Galactic Fixed Stars': [
        {'star': 'Sirius', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Vega', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Pleiades', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
        {'star': 'Arcturus', 'planet': 'Mars in Virgo', 'constellation': '', 'separation': "28°14'", 'house_label': '10th House'},
      ],
      'Starseed Origin Indicator (0° - 2°)': [
        {'display': 'Sun conjunct Mintaka – orb 0°44\'', 'meaning': ''},
        {'display': 'Moon conjunct Merope – orb 0°44\'', 'meaning': ''},
      ],
      'Black Holes': [
        {'title': 'Cygnus X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
        {'title': 'Scorpius X-1', 'planet': '', 'subtitle': 'Gemini in 9th house', 'orb_text': '', 'exact': false},
      ],
      'Dwarf Planet': [
        {'name': 'Ceres', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Pallas', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
      'Asteroids': [
        {'name': 'Chiron', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
        {'name': 'Hygiea', 'sign': 'Mars in Virgo', 'degree': "28°14'", 'house_label': '10th House'},
      ],
    };

    final List<String> currentSectionOrder = [
      'Celestial',
      'Royal Stars',
      'Galactic Fixed Stars',
      'Starseed Origin Indicator (0° - 2°)',
      'Black Holes',
      'Dwarf Planet',
      'Asteroids',
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.space(10)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: Column(
              children: [
                Text("Harmony Score",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(16), fontWeight: FontWeight.w400)),
                SizedBox(height: ResponsiveHelper.space(10)),
                Text(mockSynastryInfo['score']!,
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(40), fontWeight: FontWeight.bold)),
                SizedBox(height: ResponsiveHelper.space(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _partnerLabel("Partner 1", mockSynastryInfo['partner1']!),
                    Container(height: 30, width: 1, color: Colors.white24),
                    _partnerLabel("Partner 2", mockSynastryInfo['partner2']!),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          Text("Galactic Synastry Chart Wheel",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
            decoration: BoxDecoration(
              color: CustomColors.secondbackgroundColor,
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
              border: Border.all(color: const Color(0xFF2F3448)),
            ),
            child: ZoomableChartImage(
              imageUrl: realImage ?? "https://universal-astro.s3.ap-southeast-1.amazonaws.com/charts/galactic_synastry.png",
              height: ResponsiveHelper.height(320),
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(24)),
          ...currentSectionOrder.where((key) => mockSections.containsKey(key)).map((sectionKey) {
            final items = mockSections[sectionKey]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sectionKey, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
                SizedBox(height: ResponsiveHelper.space(12)),
                ...items.map((item) => _buildSectionItem(sectionKey, Map<String, dynamic>.from(item))),
                SizedBox(height: ResponsiveHelper.space(16)),
              ],
            );
          }),
          SizedBox(height: ResponsiveHelper.space(40)),
          CustomButton(
            text: "Generate Reading",
            isLoading: controller.isGeneratingInterpretation.value,
            onpress: () {},
          ),
          SizedBox(height: ResponsiveHelper.space(30)),
        ],
      ),
    );
  }

  Widget _partnerLabel(String label, String name) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(12))),
        SizedBox(height: ResponsiveHelper.space(4)),
        Text(name, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ==================== SECTION ITEM BUILDERS ====================

  Widget _buildSectionItem(String sectionKey, Map<String, dynamic> data) {
    if (sectionKey.startsWith('Starseed')) {
      return _starseedTile(data);
    }
    switch (sectionKey) {
      case 'Celestial':
      case 'Royal Stars':
        return _celestialTile(data);
      case 'Galactic Fixed Stars':
        return _fixedStarTile(data);
      case 'Black Holes':
        return _blackHoleTile(data);
      case 'Dwarf Planets':
      case 'Asteroids':
        return _dwarfPlanetTile(data);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Celestial & Royal Stars
  Widget _celestialTile(Map<String, dynamic> data) {
    final name = data['name'] ?? '';
    final sign = data['sign'] ?? '';
    final degree = data['degree']?.toString() ?? '';
    final houseLabel = data['house_label'] ?? data['house_name'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
                Text(
                  '$name : ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
              Text(
                sign,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (degree.isNotEmpty)
                Text(
                  ' $degree',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
            ],
          ),
          if (houseLabel.isNotEmpty) ...[
            SizedBox(height: ResponsiveHelper.space(4)),
            Text(
              '($houseLabel)',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Galactic Fixed Stars
  Widget _fixedStarTile(Map<String, dynamic> data) {
    final star = data['star'] ?? '';
    final planet = data['planet'] ?? '';
    final separation = data['separation']?.toString() ?? '';
    final houseLabel = data['house_label'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Wrap(
        children: [
          Text(
            '$star : ',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          Text(
            planet,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (separation.isNotEmpty)
            Text(
              ' $separation',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          if (houseLabel.isNotEmpty)
            Text(
              ' ($houseLabel)',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
        ],
      ),
    );
  }

  /// Starseed Origin Indicator
  Widget _starseedTile(Map<String, dynamic> data) {
    final display = data['display'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Text(
        display,
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveHelper.fontSize(14),
        ),
      ),
    );
  }

  /// Black Holes
  Widget _blackHoleTile(Map<String, dynamic> data) {
    final title = data['title'] ?? data['name'] ?? '';
    final subtitle = data['subtitle'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: ResponsiveHelper.space(4)),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Dwarf Planets & Asteroids
  Widget _dwarfPlanetTile(Map<String, dynamic> data) {
    final name = data['name'] ?? '';
    final sign = data['sign'] ?? '';
    final houseLabel = data['house_label'] ?? data['house_name'] ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.padding(12),
      ),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Wrap(
        children: [
          Text(
            '$name: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          Text(
            sign,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (houseLabel.isNotEmpty)
            Text(
              ' in $houseLabel',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== COMMON WIDGETS ====================

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.width(110),
            child: Text(key,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
