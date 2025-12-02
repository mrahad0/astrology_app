import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WesternDatails extends StatefulWidget {
  const WesternDatails({super.key});

  @override
  State<WesternDatails> createState() => _WesternDatailsState();
}

class _WesternDatailsState extends State<WesternDatails> {
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
                    _infoRow("City:", "Dhaka"),
                    _infoRow("Country:", "Bangladesh"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ---- BIRTH CHART WHEEL ----
              const Text(
                "Western Chart Wheel",
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
                ),
              ),

              const SizedBox(height: 24),

              /// ---- PLANETARY POSITIONS ----
              const Text(
                "Planetary Positions",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              _planetTile("Sun", "Gemini in 9th house"),
              _planetTile("Moon", "Pisces in 6th house"),
              _planetTile("Mercury", "Gemini in 9th house"),
              _planetTile("Venus", "Cancer in 10th house"),

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

              _aspectTile("Sun Trine Saturn", "orb: 0.5°"),
              _aspectTile("Moon Sextile Mercury", "orb: 2.1°"),

              const SizedBox(height: 40),

              /// ---- GENERATE BUTTON ----
             CustomButton(text: "Generate",onpress: (){Get.toNamed(Routes.aiComprehensive);},)

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
  /// PLANET TILE
  /// ----------------------------
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
            child: Text(detail,
                style: const TextStyle(color: Color(0xffA4A9C1))),
          ),
        ],
      ),
    );
  }

  /// ----------------------------
  /// ASPECT TILE
  /// ----------------------------
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
          Text(title,
              style: const TextStyle(
                  color: Color(0xffFF6B9D),
                  fontWeight: FontWeight.w600)),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
