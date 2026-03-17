// lib/views/pages/subscription/single_report.dart
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/13sign_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/evolutionary_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/glactic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/humanDesign_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/vedic_details.dart';
import 'package:astrology_app/views/pages/generateChart/details_chart/western_datails.dart';
import 'package:flutter/material.dart';

// -----------------------------------------------------------

class SingleReport extends StatefulWidget {
  const SingleReport({super.key});

  @override
  State<SingleReport> createState() => _SingleReport();
}

class _SingleReport extends State<SingleReport> {
  int selected = 0;

  final tabs = [
    "Western",
    "Vedic",
    "13-Sign",
    "Evolutionary",
    "Galactic",
    "Human Design",
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
              padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ----------- BACK BUTTON + TITLE ------------
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: ResponsiveHelper.iconSize(20),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.space(10)),
                      Text(
                        "Generated Chart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.fontSize(20),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.space(30)),

                  /// --------- CUSTOM TAB BAR CONTAINER (Image Style) ----------
                  Container(
                    height: ResponsiveHelper.height(60),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1C3A),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(5), horizontal: ResponsiveHelper.padding(5)),
                      itemCount: tabs.length,
                      separatorBuilder: (_, index) {
                        if (index == tabs.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return selected == index || selected == index + 1
                            ? const SizedBox(width: 0)
                            : Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(5)),
                          child: Center(
                            child: Text(
                              "|",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: ResponsiveHelper.fontSize(16),
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
                                ? EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.padding(20), vertical: ResponsiveHelper.padding(10))
                                : EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.padding(10), vertical: ResponsiveHelper.padding(10)),
                            decoration: isSelected
                                ? BoxDecoration(
                              // The vibrant purple color from the image
                              color: const Color(0xFF9A3BFF),
                              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
                            )
                                : null,
                            child: Center(
                              child: Text(
                                tabs[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(16),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.space(20)),

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