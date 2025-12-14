import 'package:astrology_app/routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  // List of different chart details
  final List<Map<String, String>> recentCharts = [
    {
      'type': 'Western Chart',
      'name': 'Mousud Vhai',
      'date': '12/10/2025',
      'location': 'Jurong Town, Singapore',
    },
    {
      'type': 'Vedic Chart',
      'name': 'Sarah Johnson',
      'date': '05/15/1995',
      'location': 'Mumbai, India',
    },
    {
      'type': 'Synastry Chart',
      'name': 'John & Emily',
      'date': '08/22/2024',
      'location': 'London, UK',
    },
    {
      'type': '13-Sign Chart',
      'name': 'Ahmed Khan',
      'date': '03/18/2000',
      'location': 'Dhaka, Bangladesh',
    },
    {
      'type': 'Transit Chart',
      'name': 'Maria Garcia',
      'date': '11/28/2025',
      'location': 'New York, USA',
    },
    {
      'type': 'Galactic Chart',
      'name': 'Chen Wei',
      'date': '07/09/1988',
      'location': 'Tokyo, Japan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: const Text(
          'Chart',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0, bottom: 20, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create your chart", style: TextStyle(color: Colors.grey, fontSize: 20)),

            SizedBox(height: 24),

            /// --- Action Cards ---
            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    onTap: () {
                      Get.toNamed(Routes.generateChartScreen);
                    },
                    icon: Icons.auto_awesome_outlined,
                    title: "Generate New chart",
                    subtitle: "Create natal, synastry,or transit",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _actionCard(
                    onTap: () {
                      Get.toNamed(Routes.savedChart);
                    },
                    icon: Icons.insert_drive_file_outlined,
                    title: "Saved Charts",
                    subtitle: "Access your collection here",
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            Text(
              "Recent Charts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),

            SizedBox(height: 16),

            /// Recent Chart List - Dynamic from list
            ...recentCharts.map((chart) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _chartCard(
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
    );
  }

  /// ----------------------------------------------------------
  /// ACTION CARD
  /// ----------------------------------------------------------
  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 170,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xff2A2F45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Icon(icon, color: Colors.white, size: 40)),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
  /// ----------------------------------------------------------
  /// CHART CARD - Now accepts dynamic data
  /// ----------------------------------------------------------
  Widget _chartCard({
    required String type,
    required String name,
    required String date,
    required String location,
  }) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xffA0A4B8),
            ),
          ),
          SizedBox(height: 6),
          Text(
            date,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xffA0A4B8),
            ),
          ),
          SizedBox(height: 6),
          Text(
            location,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xffA0A4B8),
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.savedChart);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: CustomColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "View",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.aiReading,
                      arguments: {"showBackButton": true},
                    );
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xffA0A4B8)),
                    ),
                    child: Center(
                      child: Text(
                        "Reading",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
