// lib/views/pages/ai_reading/ai_comprehensive.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/ai_compresive/ai_compresive_controller.dart';

class AiComprehensive extends StatelessWidget {
  const AiComprehensive({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/reading_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
          ),
          title: Text(
            "Comprehensive Reading",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(24),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: GetBuilder<InterpretationController>(
            init: Get.find<InterpretationController>(),
            builder: (controller) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              // MOCK DATA as requested from image
              final mockInfo = {
                'Name': 'Sadiqul',
                'Date of Birth': '11/13/2005',
                'Birth Time': '7:00 pm',
                'Time Zone': 'GMT+6',
                'Birth City / Birth Country': 'Dhaka, Bangladesh',
              };

              final mockSections = [
                {
                  'title': 'Vedic Perspective',
                  'content': 'In the Vedic system, your Taurus Sun places emphasis on stability and material security...'
                },
                {
                  'title': '13-Signs Interpretation',
                  'content': 'The 13-sign system reveals nuances often missed in traditional 12-sign astrology. Your adjusted placements show.....'
                },
              ];

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(16)),
                  child: Column(
                    children: [
                      SizedBox(height: ResponsiveHelper.space(10)),
                      // --- Share & Download Row ---
                      _buildActionRow(controller),
                      SizedBox(height: ResponsiveHelper.space(20)),

                      // --- Info Card ---
                      _buildInfoCard(mockInfo),
                      SizedBox(height: ResponsiveHelper.space(20)),

                      // --- AI Sections ---
                      ...mockSections.asMap().entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: ResponsiveHelper.space(16)),
                          child: _SectionCard(
                            index: entry.key + 1,
                            title: entry.value['title']!,
                            content: entry.value['content']!,
                          ),
                        );
                      }),

                      SizedBox(height: ResponsiveHelper.space(10)),
                      _buildMainButton("Combined Interpretation", () {
                        Get.toNamed(Routes.combinedInterpretation);
                      }),
                      SizedBox(height: ResponsiveHelper.space(16)),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMainButton("Save Reading", () {}),
                          ),
                          SizedBox(width: ResponsiveHelper.space(12)),
                          Expanded(
                            child: _buildSecondaryButton("View Reading", () {
                              Get.toNamed(Routes.aiReading, arguments: {'showBackButton': true});
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.space(30)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow(InterpretationController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(12), horizontal: ResponsiveHelper.padding(8)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionItem(Icons.share_outlined, "Share", () {}),
          Container(width: 1, height: 24, color: Colors.white24),
          _actionItem(Icons.file_download_outlined, "Download", () {}),
        ],
      ),
    );
  }

  Widget _actionItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
          SizedBox(width: ResponsiveHelper.space(8)),
          Text(label, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, String> info) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Info",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(20)),
          ...info.entries.map((e) => Padding(
                padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ResponsiveHelper.width(130),
                      child: Text(e.key + ":", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
                    ),
                    Expanded(
                      child: Text(e.value, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onPress) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10))),
        ),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(15), fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPress) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.secondbackgroundColor,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
            side: const BorderSide(color: Color(0xFF2F3448)),
          ),
        ),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(15), fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final int index;
  final String title;
  final String content;

  const _SectionCard({required this.index, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: const Color(0xFF2F3448)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Section $index", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(13))),
          SizedBox(height: ResponsiveHelper.space(8)),
          Text(title,
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(17), fontWeight: FontWeight.w600)),
          SizedBox(height: ResponsiveHelper.space(12)),
          Text(content,
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14), height: 1.4)),
        ],
      ),
    );
  }
}
