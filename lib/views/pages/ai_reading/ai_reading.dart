import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/color.dart' show CustomColors;

class AiReadingScreen extends StatefulWidget {
  const AiReadingScreen({super.key});

  @override
  State<AiReadingScreen> createState() => _AiReadingScreenState();
}

class _AiReadingScreenState extends State<AiReadingScreen> {
  bool showBackButton = false;

  int selectedFilter = 0; // All selected

  final List<String> filters = [
    "All",
    "Western",
    "Vedic",
    "13-Signs",
    "Galactic",
    "Human Design Profile"
  ];

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
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is Map) {
      showBackButton = Get.arguments['showBackButton'] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
          onPressed: () {
            Get.back();
          },
        )
            : null,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Reading",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your chart collection",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 20),

              // ------------------ HORIZONTAL FILTER BUTTONS ---------------------
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: List.generate(filters.length, (index) {
              //       bool isSelected = selectedFilter == index;
              //
              //       return Padding(
              //         padding: const EdgeInsets.only(right: 10),
              //         child: GestureDetector(
              //           onTap: () {
              //             setState(() => selectedFilter = index);
              //           },
              //           child: Container(
              //             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              //             decoration: BoxDecoration(
              //               color: isSelected ? Colors.purple : CustomColors.secondbackgroundColor,
              //               borderRadius: BorderRadius.circular(12),
              //               border: Border.all(
              //                 color: isSelected ? Colors.purple : const Color(0xff2A2F45),
              //               ),
              //             ),
              //             child: Text(
              //               filters[index],
              //               style: TextStyle(
              //                 color: isSelected ? Colors.white : Colors.white,
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
              //   ),
              // ),

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
              Get.toNamed("/SavedChart");
            },
          )
        ],
      ),
    );
  }
}