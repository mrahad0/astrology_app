// lib/views/pages/subscription/subscription_page.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();

  static TextStyle get labelStyle => TextStyle(color: Colors.white70, fontSize: ResponsiveHelper.fontSize(14));
  static TextStyle get valueStyle => TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14));

  static Widget infoRow(String label, String value, {bool green = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(
            value,
            style: valueStyle.copyWith(color: green ? Colors.greenAccent : Colors.white),
          ),
        ],
      ),
    );
  }
  // ------------------- PLAN CARD -------------------

  static Widget planCard(String title, String subtitle, String price, String url, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.black, fontSize: ResponsiveHelper.fontSize(16), fontWeight: FontWeight.bold)),
          SizedBox(height: ResponsiveHelper.space(6)),
          Text(subtitle, style: TextStyle(color: Colors.black, fontSize: ResponsiveHelper.fontSize(12))),
          SizedBox(height: ResponsiveHelper.space(10)),
          Text(price, style: TextStyle(color: Colors.black, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.bold)),
          SizedBox(height: ResponsiveHelper.space(12)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                CustomAlertdialog(
                  onPressed: (){
                    Get.toNamed(Routes.paymentCard);
                  },
                  context: context,
                  title: "Confirm Upgrade",
                  content: "You're about to upgrade to Premium for \$39.99/month. Your usage stats will reset.",
                ).show(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(8)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.radius(10))),
              ),
              child: Text("Upgrade", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14))),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- FEATURE ITEM -------------------

  static Widget featureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(10)),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/tick-01.svg", height: ResponsiveHelper.iconSize(14), width: ResponsiveHelper.iconSize(14)),
          SizedBox(width: ResponsiveHelper.space(8)),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)))),
        ],
      ),
    );
  }
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/subcription_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20))),
                  SizedBox(width: ResponsiveHelper.space(20)),
                  Text(
                    "Subscription",
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(24), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.space(16)),

              infoCard(),

              SizedBox(height: ResponsiveHelper.space(16)),

              Text(
                "Single Report",
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.w500),
              ),

              SizedBox(height: ResponsiveHelper.space(16)),

              singlefeaturesCard(),

              SizedBox(height: ResponsiveHelper.space(16)),

              Text(
                "Upgrade Your Plan",
                style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.w500),
              ),

              SizedBox(height: ResponsiveHelper.space(16)),

              featuresCard(),

              SizedBox(height: ResponsiveHelper.space(16)),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SubscriptionPage.planCard(
                            "Standard",
                            "For serious astrology enthusiasts",
                            "\$19.99/month",
                            "assets/images/standerd.png",
                            context
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.space(12)),
                      Expanded(
                        child: SubscriptionPage.planCard(
                            "Premium",
                            "For serious astrology enthusiasts",
                            "\$29.99/month",
                            "assets/images/premium.png",
                            context
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.space(12)),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SubscriptionPage.planCard(
                            "Platinum",
                            "For serious astrology enthusiasts",
                            "\$19.99/month",
                            "assets/images/platenium.png",
                            context
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox(width: ResponsiveHelper.space(12))), // Empty space on right
                    ],
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.space(30)),

              featuresCard(),
            ],
          ),
        ),
      ),
     ),
    );
  }

  // ------------------- INFO CARD -------------------

  Widget infoCard() {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Info", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.bold)),
          SizedBox(height: ResponsiveHelper.space(16)),
          SubscriptionPage.infoRow("Current Plan:", "Free"),
          SubscriptionPage.infoRow("Monthly Cost:", "\$0"),
          SubscriptionPage.infoRow("Renewal Date:", "7:00 pm"),
          SubscriptionPage.infoRow("Status:", "Active", green: true),
        ],
      ),
    );
  }

  // ------------------- FEATURES CARD -------------------

  Widget featuresCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Plan Features",
              style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.bold)),
          SizedBox(height: ResponsiveHelper.space(16)),
          SubscriptionPage.featureItem("1 chart (local storage)"),
          SubscriptionPage.featureItem("Western + Vedic astrology only"),
          SubscriptionPage.featureItem("Pre-written interpretations for individual placements"),
          SubscriptionPage.featureItem("0 AI syntheses"),
          SubscriptionPage.featureItem("Ad-supported"),
        ],
      ),
    );
  }
}

// -------------------Single FEATURES CARD -------------------


Widget singlefeaturesCard() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
    decoration: BoxDecoration(
      color: CustomColors.secondbackgroundColor,
      borderRadius: BorderRadius.circular(ResponsiveHelper.radius(14)),
      border: Border.all(color: const Color(0xff2E334A)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Unlock a universe of insights with one simple purchase. This all-inclusive plan grants you full access to every astrology system, including Western, Vedic, 13-Sign (Ophiuchus), and premium systems like Galactic Astrology and Human Design.\nWith the All-Access Astrology Plan, you experience:s",
            style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(15), fontWeight: FontWeight.w500)),
        SizedBox(height: ResponsiveHelper.space(16)),
        SubscriptionPage.featureItem("Full system unlocks"),
        SubscriptionPage.featureItem("Unlimited readings & interpretations"),
        SubscriptionPage.featureItem("Detailed charts & personalized breakdowns"),
        SubscriptionPage.featureItem("Multi-system comparisons & deeper insights"),
        SubscriptionPage.featureItem("Lifetime access to future enhancements"),

        SizedBox(height: ResponsiveHelper.space(16)),

        Text("\$149.99/single purchase", style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(18), fontWeight: FontWeight.w400)),

        SizedBox(height: ResponsiveHelper.space(16)),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(Routes.singlePurchasePlan);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2A2F4A)),
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.padding(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              ),
            ),
            child: Text(
              'View Details',
              style: TextStyle(fontSize: ResponsiveHelper.fontSize(16)),
            ),
          ),
        ),

        SizedBox(height: ResponsiveHelper.space(16)),

        SizedBox(
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
            ),
            child: Text(
              'Purchase',
              style: TextStyle(fontSize: ResponsiveHelper.fontSize(16), fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
