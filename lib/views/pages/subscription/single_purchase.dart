// lib/views/pages/subscription/single_purchase.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SinglePurchasePlan extends StatelessWidget {
  const SinglePurchasePlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Single Report",
        leading: GestureDetector(
          onTap:() => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
        ),
      ),
      body:SafeArea(
          child: Column(
            children: [
              /// ---- SCROLLABLE CONTENT ----
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveHelper.padding(20.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title with sparkle icon
                        Row(
                          children: [
                            Text(
                              '✨',
                              style: TextStyle(fontSize: ResponsiveHelper.fontSize(18)),
                            ),
                            SizedBox(width: ResponsiveHelper.space(8)),
                            Text(
                              'All-Access Astrology Plan',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(18),
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.space(16)),

                        /// Description paragraph 1
                        Text(
                          'Unlock the complete universe of insights with one simple purchase. This all-inclusive plan gives you full access to every astrology system, including Western, Vedic, 13-Sign (Ophiuchus), Evolutionary Astrology, plus premium-tier systems like Galactic Astrology and Human Design.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.fontSize(15),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.space(16)),

                        /// Description paragraph 2
                        Text(
                          'Get every reading, chart, analysis, and deep-dive overview across all systems—fully unlocked. No limits, no separate purchases. Explore your personality, life path, cosmic patterns, karmic lessons, and multidimensional influences through every major astrological lens.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.fontSize(15),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.space(16)),

                        /// Description paragraph 3
                        Text(
                          'With the All-Access Astrology Plan, you experience:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.fontSize(15),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.space(20)),

                        /// Features list
                        _buildFeature('Full system unlocks'),
                        _buildFeature('Unlimited readings & interpretations'),
                        _buildFeature('Detailed charts & personalized breakdowns'),
                        _buildFeature('Multi-system comparisons & deeper insights'),
                        _buildFeature('Lifetime access to future enhancements'),

                        SizedBox(height: ResponsiveHelper.space(32)),

                        /// Price
                        Text(
                          '\$149.99',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(32),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '/single purchase',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: ResponsiveHelper.fontSize(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// ---- PURCHASE BUTTON ----
              Padding(
                padding: EdgeInsets.all(ResponsiveHelper.padding(20.0)),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.paymentType);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Purchase',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(18),
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  /// ----------------------------
  /// FEATURE ITEM WIDGET
  /// ----------------------------
  Widget _buildFeature(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check,
            color: const Color(0xFF4ADE80),
            size: ResponsiveHelper.iconSize(20),
          ),
          SizedBox(width: ResponsiveHelper.space(12)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(15),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}