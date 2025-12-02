import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class VedicDetails extends StatefulWidget {
  const VedicDetails({super.key});

  @override
  State<VedicDetails> createState() => _VedicDetailsState();
}

class _VedicDetailsState extends State<VedicDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    _infoRow("Name:", "Sadiqul"),
                    _infoRow("Date of Birth:", "11/13/2005"),
                    _infoRow("Birth Time:", "7:00 pm"),
                    _infoRow("Time Zone:", "GMT+6"),
                    _infoRow("Birth City:", "Dhaka"),
                    _infoRow("Birth Country:", "Bangladesh"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ---- VEDIC CHART WHEEL ----
              const Text(
                "Vedic Chart Wheel",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              Center(
                child: Container(
                  height: 350,
                  width:MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: CustomColors.secondbackgroundColor,
                    border: Border.all(color: const Color(0xff262A40)),
                  ),
                  child: Image.asset(
                    "assets/images/chartimage.png",
                    fit: BoxFit.fill,
                  ),
                ),),

              const SizedBox(height: 24),


              /// ---- SIDEREAL POSITIONS ----
              const Text(
                "Sidereal Positions",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              _siderealTile("Sun:", "Taurus", "in Rohini"),
              _siderealTile("Moon:", "Aquarius", "in Dhanishta"),

              const SizedBox(height: 10),

              /// ---- CURRENT DASHA ----
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xff2B2F45)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Current Dasha: ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'Venus',
                            style: TextStyle(
                              color: Color(0xffA855F7),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Remaining: 18 years',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ---- NAKSHATRAS ----
              const Text(
                "Nakshatras",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              _nakshtraTile("Sun Nakshatra", "Rohini (Pada 3)"),
              _nakshtraTile("Moon Nakshatra", "Dhanishta (Pada 1)"),

              const SizedBox(height: 40),

              /// ---- GENERATE BUTTON ----

              CustomButton(text: "Generate",onpress: (){Get.toNamed(Routes.aiComprehensive);},),


              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------
  /// INFO ROW WIDGET
  /// ----------------------------
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

  /// ----------------------------
  /// SIDEREAL TILE
  /// ----------------------------
  Widget _siderealTile(String planet, String sign, String nakshatra) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff2B2F45)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$planet ',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: sign,
              style: const TextStyle(
                color: Color(0xffA855F7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: ' $nakshatra',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// NAKSHATRA TILE
  /// ----------------------------
  Widget _nakshtraTile(String title, String subtitle) {
    return Container(
      width: double.infinity,
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
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          Text(subtitle, style: const TextStyle(color: Color(0xffA4A9C1))),
        ],
      ),
    );
  }

  /// ----------------------------
  /// PLANET DOT WIDGET
  /// ----------------------------
  Widget _buildPlanet(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
