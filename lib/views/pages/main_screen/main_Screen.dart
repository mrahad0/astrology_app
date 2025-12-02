import 'package:astrology_app/views/pages/ai_reading/ai_reading.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/views/base/custom_bottomBar.dart';
import 'package:astrology_app/views/pages/chartPage/chart_Screen.dart';
import 'package:astrology_app/views/pages/notification/notification_Screen.dart';
import 'package:astrology_app/views/pages/profile/profile_Screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    ChartScreen(),
    AiReadingScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/astrology_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: IndexedStack(index: currentIndex, children: pages),
            ),
            Positioned(
              child: CustomBottomBar(
                selectedIndex: currentIndex,
                onItemTapped: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              bottom: 0,
              left: 10,
              right: 10,
            ),
          ],
        ),
      ),
    );
  }
}
