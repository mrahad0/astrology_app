import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_alertDialog.dart' show CustomAlertdialog;
import 'package:astrology_app/views/pages/payment_card/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();

  static const TextStyle labelStyle = TextStyle(color: Colors.white70, fontSize: 14);
  static const TextStyle valueStyle = TextStyle(color: Colors.white, fontSize: 14);

  static Widget infoRow(String label, String value, {bool green = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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

  static Widget planCard(String title, String subtitle, String price,String url, BuildContext context) {
    return Container(
      //height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          Text(price, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final screenWidth = MediaQuery.of(context).size.width;
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Upgrade", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- FEATURE ITEM -------------------

  static Widget featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/tick-01.svg"),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(onTap:(){Get.back();},child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                  SizedBox(width: 20,),
                  Text(
                    "Subscription",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              infoCard(),

              const SizedBox(height: 16),

              const Text(
                "Single Report",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),

              singlefeaturesCard(),

              const SizedBox(height: 16),

              const Text(
                "Upgrade Your Plan",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),

              featuresCard(),

              const SizedBox(height: 16),

              // Replace your existing plan cards section with this code:

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Row - Standard and Premium side by side
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
                      const SizedBox(width: 12),
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

                  const SizedBox(height: 12),

                  // Second Row - Platinum card (half width, left aligned)
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
                      const Expanded(flex: 1, child: SizedBox()), // Empty space on right
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),



              const SizedBox(height: 30),

              featuresCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- INFO CARD -------------------

  Widget infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Info", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xff2E334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Current Plan Features",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
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
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: CustomColors.secondbackgroundColor,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xff2E334A)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Unlock a universe of insights with one simple purchase. This all-inclusive plan grants you full access to every astrology system, including Western, Vedic, 13-Sign (Ophiuchus), and premium systems like Galactic Astrology and Human Design.\nWith the All-Access Astrology Plan, you experience:s",
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        SubscriptionPage.featureItem("Full system unlocks"),
        SubscriptionPage.featureItem("Unlimited readings & interpretations"),
        SubscriptionPage.featureItem("Detailed charts & personalized breakdowns"),
        SubscriptionPage.featureItem("Multi-system comparisons & deeper insights"),
        SubscriptionPage.featureItem("Lifetime access to future enhancements"),

        const SizedBox(height: 16),

        Text("\$149.99/single purchase", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(Routes.singlePurchasePlan);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2A2F4A)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'View Details',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.paymentType);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
              padding:  EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Purchase',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ),
        ),


      ],
    ),
  );
}