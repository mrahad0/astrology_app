// lib/views/pages/subscription/single_purchase.dart
// lib/views/pages/subscription/single_purchase.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SinglePurchasePlan extends StatelessWidget {
  const SinglePurchasePlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/subcription_bg.png"),
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Colors.white, size: ResponsiveHelper.iconSize(20)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Subscription",
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
              _buildCurrentPlanCard(),
              SizedBox(height: ResponsiveHelper.space(30)),
              _buildPlanCard(
                title: "FREE PLAN",
                price: "\$0",
                subtitle: "Explore astrology at no cost.\nYour cosmic journey starts here.",
                features: [
                  FeatureItem("Western Astrology - complete", true),
                  FeatureItem("Unlimited chart generation", true),
                  FeatureItem("1 saved chart (local storage)", true),
                  FeatureItem("Daily Cosmic Update", true),
                  FeatureItem("Ad supported", true),
                  FeatureItem("No Combined Interpretation", false),
                  FeatureItem("No Transit Charts", false),
                  FeatureItem("No Synastry Charts", false),
                ],
                bottomPrice: "\$0/month",
                bgAsset: "assets/images/Free Plan.webp",
              ),
              SizedBox(height: ResponsiveHelper.space(24)),
              _buildPlanCard(
                title: "STANDARD PLAN",
                price: "\$29.99/month\n\$299/year (save \$60)",
                subtitle: "For astrology enthusiasts\n\nAccess 5 complete astrological systems for yourself and the people you care about.",
                features: [
                  FeatureItem("Western Astrology Report", true),
                  FeatureItem("Vedic Astrology Report\n(includes D9 Navamsa, D10 Dasamsa, Ashtakavarga, Graha Strengths, Graha Drishti)", true),
                  FeatureItem("13-Sign Zodiac Report", true),
                  FeatureItem("Evolutionary Astrology Report", true),
                  FeatureItem("Human Design Essentials Report", true),
                  FeatureItem("5 Combined Interpretations/month", true),
                  FeatureItem("20 saved charts (cloud)", true),
                  FeatureItem("Unlimited chart generation", true),
                  FeatureItem("Daily Cosmic Update", true),
                  FeatureItem("Ad free", true),
                  FeatureItem("PDF download", true),
                  FeatureItem("No Galactic Astrology", false),
                  FeatureItem("No Transit Charts", false),
                  FeatureItem("No Synastry Charts", false),
                ],
                bottomNote: "Buying these reports separately costs \$174.95 per person.\nSubscribe and save over \$144 on your very first chart alone.",
                bottomPrice: "\$29.99/month",
                bgAsset: "assets/images/Standard Plan.webp",
              ),
              SizedBox(height: ResponsiveHelper.space(24)),
              _buildPlanCard(
                title: "PREMIUM PLAN",
                price: "\$49.99/month\n\$499/year (save \$100)",
                subtitle: "For serious practitioners\n\nEverything in Standard plus our exclusive Galactic Astrology - unavailable anywhere else in the world.",
                features: [
                  FeatureItem("Western Astrology Report", true),
                  FeatureItem("Vedic Astrology Report\n(includes D9 Navamsa, D10 Dasamsa, Ashtakavarga, Graha Strengths, Graha Drishti)", true),
                  FeatureItem("13-Sign Zodiac Report", true),
                  FeatureItem("Evolutionary Astrology Report", true),
                  FeatureItem("Human Design Essentials Report", true),
                  FeatureItem("Galactic Astrology Report 88 constellations, Royal Stars, 43 black holes, 25+ dwarf planets, starseed indicators and more", true),
                  FeatureItem("15 Combined Interpretations/month", true),
                  FeatureItem("50 saved charts (cloud)", true),
                  FeatureItem("Unlimited chart generation", true),
                  FeatureItem("Daily Cosmic Update", true),
                  FeatureItem("Ad free", true),
                  FeatureItem("PDF download", true),
                  FeatureItem("No Transit Charts", false),
                  FeatureItem("No Synastry Charts", false),
                ],
                bottomNote: "Buying these reports separately costs \$234.94 per person.\nSubscribe and save over \$184 on your very first chart alone.",
                bottomPrice: "\$49.99/month",
                bgAsset: "assets/images/Premium Plan.webp",
              ),
              SizedBox(height: ResponsiveHelper.space(24)),
              _buildPlanCard(
                title: "PLATINUM PLAN",
                price: "\$99/month\n\$999/year (save \$189)",
                subtitle: "For professional astrologers\n\nThe complete professional platform. Everything in Premium plus Transit, Synastry and tools built for running a successful astrology practice.",
                features: [
                  FeatureItem("Western Astrology Report", true),
                  FeatureItem("Vedic Astrology Report", true),
                  FeatureItem("13-Sign Zodiac Report", true),
                  FeatureItem("Evolutionary Astrology Report", true),
                  FeatureItem("Human Design Essentials Report", true),
                  FeatureItem("Galactic Astrology Report", true),
                  FeatureItem("Transit Charts included", true),
                  FeatureItem("Synastry Charts included", true),
                  FeatureItem("30 Combined Interpretations/month", true),
                  FeatureItem("100 saved charts (cloud)", true),
                  FeatureItem("Unlimited chart generation", true),
                  FeatureItem("Daily Cosmic Update", true),
                  FeatureItem("Client management system", true),
                  FeatureItem("Professional tools", true),
                  FeatureItem("Priority support", true),
                  FeatureItem("Ad free", true),
                  FeatureItem("PDF download", true),
                ],
                bottomNote: "Your subscription pays for itself after your very first client reading.",
                bottomPrice: "\$99.99/month",
                bgAsset: "assets/images/Platinum Plan.webp",
              ),
              SizedBox(height: ResponsiveHelper.space(32)),

              // Bottom Row (See more + Single Report)
              Row(
                children: [
                  // See more button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Already on the plans page showing all
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.padding(14)),
                        decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                              ResponsiveHelper.radius(10)),
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
                  // Single Report button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.subscriptionPage);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.padding(14)),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.white.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(
                              ResponsiveHelper.radius(10)),
                        ),
                        child: Center(
                          child: Text(
                            "Single Report →",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.space(40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1C2C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(16)),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Plan",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(20)),
          _buildFeatureItem("Western Astrology - complete", true),
          _buildFeatureItem("Unlimited chart generation", true),
          _buildFeatureItem("1 saved chart (local storage)", true),
          _buildFeatureItem("Daily Cosmic Update", true),
          _buildFeatureItem("Ad supported", true),
          _buildFeatureItem("No Combined Interpretation", false),
          _buildFeatureItem("No Transit Charts", false),
          _buildFeatureItem("No Synastry Charts", false),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String subtitle,
    required List<FeatureItem> features,
    String? bottomNote,
    required String bottomPrice,
    required String bgAsset,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(24)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(20)),
        image: DecorationImage(
          image: AssetImage(bgAsset),
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),
          Text(
            price,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(30),
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: ResponsiveHelper.fontSize(14),
              height: 1.4,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(20)),
          ...features.map((f) => _buildFeatureItem(f.text, f.isAvailable)),
          if (bottomNote != null) ...[
            SizedBox(height: ResponsiveHelper.space(16)),
            Text(
              bottomNote,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: ResponsiveHelper.fontSize(13),
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ],
          SizedBox(height: ResponsiveHelper.space(24)),
          Text(
            bottomPrice,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(32),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveHelper.space(16)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.paymentCard);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9A3BFF),
                padding:
                    EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(14)),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ResponsiveHelper.radius(14)),
                ),
              ),
              child: Text(
                "Upgrade",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isAvailable) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isAvailable ? Icons.check : Icons.close,
            color: isAvailable ? const Color(0xFF4ADE80) : Colors.redAccent,
            size: ResponsiveHelper.iconSize(18),
          ),
          SizedBox(width: ResponsiveHelper.space(12)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: ResponsiveHelper.fontSize(14),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem {
  final String text;
  final bool isAvailable;
  FeatureItem(this.text, this.isAvailable);
}
