import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalacticDetails extends StatefulWidget {
  const GalacticDetails({super.key});

  @override
  State<GalacticDetails> createState() => _GalacticDetailsState();
}

class _GalacticDetailsState extends State<GalacticDetails> {
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

              /// ---- ROYAL STARS ----
              const Text(
                "Royal Stars",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              _starTile("Aldebaran contact"),
              _starTile("Regulus in aspect"),

              const SizedBox(height: 24),

              /// ---- DWARF PLANETS ----
              const Text(
                "Dwarf Planets",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              _starTile("Eris conjunct Moon"),
              _starTile("Sedna in 12th"),

              const SizedBox(height: 24),

              /// ---- STARSEED ----
              const Text(
                "Starseed",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              _starTile("Pleiadian connection active"),

              const SizedBox(height: 40),

              /// ---- GENERATE READING BUTTON ----
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
  /// STAR TILE WIDGET
  /// ----------------------------
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