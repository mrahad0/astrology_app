import 'package:astrology_app/views/pages/generateChart/details_chart/evolutionary_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/glactic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/humanDesign_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/vedic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/western_datails.dart';
import 'package:flutter/material.dart';
import '../13sign_details.dart' show Sign13Details;

// -----------------------------------------------------------

class MainDetailChart extends StatefulWidget {
  const MainDetailChart({super.key, required List selectedCharts});

  @override
  State<MainDetailChart> createState() => _MainDetailChart();
}

class _MainDetailChart extends State<MainDetailChart> {
  int selected = 0;

  final tabs = [
    "Western",
    "Vedic",
    "13-Signs",
    "Evolutionary",
    "Galactic",
    "Human Design profile",
  ];

  final pages = const [
    WesternDatails(),
    VedicDetails(),
    Sign13Details(),
    EvolutionaryDetails(),
    GalacticDetails(),
    HumandesignDetails(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ---------------- CONTENT ----------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ----------- BACK BUTTON + TITLE ------------
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Generated Chart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// --------- CUSTOM TAB BAR CONTAINER (Image Style) ----------
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1C3A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                      itemCount: tabs.length,
                      separatorBuilder: (_, index) {
                        if (index == tabs.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return selected == index || selected == index + 1
                            ? const SizedBox(width: 0)
                            : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Center(
                            child: Text(
                              "|",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context, index) {
                        final isSelected = selected == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() => selected = index);

                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: isSelected
                                ? const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10)
                                : const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: isSelected
                                ? BoxDecoration(
                              // The vibrant purple color from the image
                              color: const Color(0xFF9A3BFF),
                              borderRadius: BorderRadius.circular(14),
                            )
                                : null,
                            child: Center(
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// --------- PAGE CONTENT DISPLAY ----------
                  Expanded(
                    child: pages[selected],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
