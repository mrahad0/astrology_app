import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600,color: Colors.white),
          ),
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           CustomSubscriptionContainer(),

            SizedBox(height: 20,),

            Text("Account", style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white),),

            SizedBox(height: 20,),

            CustomCard(title: "Personal Information", url: "assets/icons/user.svg",onTap: (){Get.toNamed(Routes.personalInfo);},),

            SizedBox(height: 12,),

            CustomCard(title: "Change Password", url: "assets/icons/square-lock-password.svg",onTap: (){Get.toNamed(Routes.changePass);},),

            SizedBox(height: 12,),

            CustomCard(title: "Astro Data", url: "assets/icons/astronaut.svg",onTap: (){Get.toNamed(Routes.astroData);},),

            SizedBox(height: 12,),

            CustomCard(title: "Privacy & Policy", url: "assets/icons/policy.svg",onTap: (){Get.toNamed(Routes.privacyPolicy);},),

            SizedBox(height: 20,),

            CustomCard(title: "Logout", url: "assets/icons/logout-05.svg",onTap: (){showLogoutBottomSheet(context);},),
          ],
        ),
      )
    );
  }
}

////====================== Custom Container=========================///

class CustomCard extends StatelessWidget {
  final String title;
  final String url;
  final void Function()? onTap;

  const CustomCard({
    required this.title,
    required this.url,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xff2E334A),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(url),

            SizedBox(width: 10),
            // Text content
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///====================Custom Subscription Container======================///


class CustomSubscriptionContainer extends StatelessWidget {
  const CustomSubscriptionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 170,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.secondbackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xff2E334A),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Subscription", style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500),),

          SizedBox(height: 8,),

          Text("Free", style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700),),

          SizedBox(height: 8,),

          Text("\$0/month", style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500),),

          SizedBox(height: 8,),

          GestureDetector(
            onTap: (){
              Get.toNamed(Routes.subscriptionPage);
            },
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color:  CustomColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icons/crown-03.svg"),
                  SizedBox(width: 10,),
                  Text(
                    "Manage Subscription",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}