// lib/views/pages/subscription/subscription_page.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportModel {
  final String title;
  final String price;
  final String description;

  ReportModel({
    required this.title,
    required this.price,
    required this.description,
  });
}

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _visibleCount = 3;

  final List<ReportModel> reports = [
    ReportModel(
      title: "Western Astrology Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Vedic Astrology Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "13 Sign + Zodiac Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Evolution Astrology Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Human Design report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Galactic Astrology Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Synastry Single Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Child Natal Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Transit 6 Month Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Transit 12 Month Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Synastry Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Solar Return Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
    ReportModel(
      title: "Progression Chart Report",
      price: "\$12.99",
      description: "Your complete Astrology report gives you every chart, analysis, and deep-dive overview across all systems—fully unlocked. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine which reports to show
    final visibleReports = reports.take(_visibleCount).toList();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/subcription_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Single Report",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(22),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Get your comprehensive astrology birth chart report depth analysis and discover what the stars have for you",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              SizedBox(height: ResponsiveHelper.space(24)),
              
              // Reports List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleReports.length,
                separatorBuilder: (context, index) => SizedBox(height: ResponsiveHelper.space(16)),
                itemBuilder: (context, index) {
                  final report = visibleReports[index];
                  return _buildReportCard(report);
                },
              ),
              
              SizedBox(height: ResponsiveHelper.space(24)),

              // Buttons Section (Always shows "Subscription Plan", shows "See more" conditionally)
              Column(
                children: [
                  if (_visibleCount < reports.length)
                    Row(
                      children: [
                        // See more button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _visibleCount += 3;
                                if (_visibleCount > reports.length) {
                                  _visibleCount = reports.length;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(14)),
                              decoration: BoxDecoration(
                                color: CustomColors.primaryColor,
                                borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
                              ),
                              child: Center(
                                child: Text(
                                  "See more",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveHelper.fontSize(16),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.space(12)),
                        // Subscription Plan button
                        Expanded(child: _buildSubscriptionPlanButton()),
                      ],
                    )
                  else
                    // Only Subscription Plan button when everything is visible
                    _buildSubscriptionPlanButton(fullWidth: true),
                ],
              ),
              
              SizedBox(height: ResponsiveHelper.space(40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionPlanButton({bool fullWidth = false}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.singlePurchasePlan);
      },
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(14)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
        ),
        child: Center(
          child: Text(
            "Subscription Plan →",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(18)),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2442).withOpacity(0.8), // Card background color
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  report.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                report.price,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.space(12)),
          Text(
            report.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: ResponsiveHelper.fontSize(14),
              height: 1.4,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(20)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.paymentCard);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10)),
                ),
                elevation: 0,
              ),
              child: Text(
                "Purchase",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
