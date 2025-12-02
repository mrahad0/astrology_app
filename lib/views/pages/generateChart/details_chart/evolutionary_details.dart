import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EvolutionaryDetails extends StatefulWidget {
  const EvolutionaryDetails({super.key});

  @override
  State<EvolutionaryDetails> createState() => _EvolutionaryDetailsState();
}

class _EvolutionaryDetailsState extends State<EvolutionaryDetails> {
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

              /// ---- POINTS GRID ----
              Row(
                children: [
                  Expanded(
                    child: _pointCard(
                      "North Node",
                      "Taurus 9th House",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pointCard(
                      "South Node",
                      "Scorpio 3rd House",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _pointCard(
                      "Pluto Polar",
                      "Scorpio 3rd House",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pointCard(
                      "Chiron",
                      "Libra 1st House",
                    ),
                  ),
                ],
              ),

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
  /// POINT CARD WIDGET
  /// ----------------------------
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