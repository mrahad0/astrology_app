import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:astrology_app/views/pages/ai_reading/saved_charts_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/custom_button.dart';

class SavedChart extends StatefulWidget {
  const SavedChart({super.key});

  @override
  State<SavedChart> createState() => _SavedChartState();
}

class _SavedChartState extends State<SavedChart> {
  // List of different chart readings
  final List<Map<String, String>> chartReadings = [
    {
      'type': 'Western Chart',
      'name': 'Mousud Bitkel',
      'date': '12/10/2025',
      'location': 'Jurong Town,Singapore',
    },
    {
      'type': 'Vedic Chart',
      'name': 'Priya Sharma',
      'date': '03/22/1998',
      'location': 'New Delhi, India',
    },
    {
      'type': '13-Sign Chart',
      'name': 'David Chen',
      'date': '07/15/1992',
      'location': 'Hong Kong',
    },
    {
      'type': 'Galactic Chart',
      'name': 'Emma Wilson',
      'date': '11/08/2000',
      'location': 'Los Angeles, USA',
    },
    {
      'type': 'Human Design Profile',
      'name': 'Ahmed Hassan',
      'date': '05/30/1995',
      'location': 'Cairo, Egypt',
    },
    {
      'type': 'Western Chart',
      'name': 'Sophie Martin',
      'date': '09/14/1988',
      'location': 'Paris, France',
    },
    {
      'type': 'Vedic Chart',
      'name': 'Rajesh Kumar',
      'date': '01/25/1990',
      'location': 'Mumbai, India',
    },
    {
      'type': 'Galactic Chart',
      'name': 'Maria Rodriguez',
      'date': '06/18/1997',
      'location': 'Barcelona, Spain',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Saved Chart",leading:IconButton(
          onPressed: () {
    Get.back();
    },
      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
    ),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 22),

              // ------------------ DYNAMIC LIST CARDS ---------------------
              ...chartReadings.map((chart) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: chartCard(
                    type: chart['type']!,
                    name: chart['name']!,
                    date: chart['date']!,
                    location: chart['location']!,
                  ),
                );
              }).toList(),

              SizedBox(height: MediaQuery.of(context).size.height / 6)
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------- CARD WIDGET - Now accepts dynamic data ------------------------
  Widget chartCard({
    required String type,
    required String name,
    required String date,
    required String location,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xffA0A4B8),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xffA0A4B8),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xffA0A4B8),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // button
          CustomButton(
            text: "View",
            onpress: () {
              Get.to(SavedChartScreen());
            },
          )
        ],
      ),
    );
  }
}
