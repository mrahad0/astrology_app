import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedChartsDetails extends StatelessWidget {
  const SavedChartsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Saved Chart",leading:IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 32),


              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CustomColors.secondbackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color:  Color(0xff2E334A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Word Count",
                                style: TextStyle(color: Colors.grey,fontSize: 12)),
                            SizedBox(height: 4),
                            Text("654 words",
                                style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Generated",
                                style: TextStyle(color: Colors.grey,fontSize: 12)),
                            SizedBox(height: 4),
                            Text("Just Now",
                                style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.share, color: Colors.white, size: 18),
                                  SizedBox(width: 6),
                                  Text("Share",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.download, color: Colors.white, size: 18),
                                  SizedBox(width: 6),
                                  Text("Download",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔵 Info Card
              _infoCard(),

              const SizedBox(height: 16),

              // 🔵 Sections
              _sectionCard(
                title: "Vedic Perspective",
                section: "Section 1",
                words: "200 words",
                description:
                "In the Vedic system, your Taurus Sun places emphasis on stability and material security...",
              ),

              _sectionCard(
                title: "13-Signs",
                section: "Section 2",
                words: "200 words",
                description:
                "The 13-sign system reveals nuances often missed in traditional 12-sign astrology...",
              ),

              _sectionCard(
                title: "Human Design",
                section: "Section 3",
                words: "200 words",
                description:
                "The Human Design system highlights unique energetic patterns within your chart...",
              ),

            ],
          ),
        ),
      ),
    );
  }

  // 🔶 Info Card Widget
  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:  CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color:  Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("Info",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),

          _infoRow("Name:", "Sadiqul"),
          _infoRow("Date of Birth:", "11/13/2005"),
          _infoRow("Birth Time:", "7:00 pm"),
          _infoRow("Time Zone:", "GMT+6"),
          _infoRow("City:", "Dhaka"),
          _infoRow("Country:", "Bangladesh"),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 🔵 Section Card Widget
  Widget _sectionCard({
    required String title,
    required String section,
    required String words,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color:  Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(section,
                  style: const TextStyle(color: Color(0xff9726F2), fontSize: 13)),
              Text(words,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),

          const SizedBox(height: 6),

          Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),),
          const SizedBox(height: 10),

          Text(description,
              style: const TextStyle(color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }
}