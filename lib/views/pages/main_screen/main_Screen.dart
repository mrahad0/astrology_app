import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrology_app/views/base/custom_bottomBar.dart';
import 'package:astrology_app/views/pages/chartPage/chart_Screen.dart';
import 'package:astrology_app/views/pages/notification/notification_Screen.dart';
import 'package:astrology_app/views/pages/profile/profile_Screen.dart';
import 'package:astrology_app/views/pages/ai_reading/ai_reading.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Reactive current tab index
  final currentIndex = 0.obs;

  // Pages
  final List<Widget> pages = [
    const ChartScreen(),
    const AiReadingScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Background + IndexedStack
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/astrology_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Obx(() => IndexedStack(
                index: currentIndex.value,
                children: pages,
              )),
            ),

            // Bottom bar
            Positioned(
              bottom: 0,
              left: 10,
              right: 10,
              child: Obx(() => CustomBottomBar(
                selectedIndex: currentIndex.value,
                onItemTapped: (index) {
                  currentIndex.value = index;
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
