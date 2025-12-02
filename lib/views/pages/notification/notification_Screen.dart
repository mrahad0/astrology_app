import 'package:astrology_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Different types of notifications
    final List<Map<String, String>> notifications = [
      {
        'title': 'Chart Generated',
        'subtitle': 'Your birth chart has been generated successfully.',
      },
      {
        'title': 'Premium Subscription',
        'subtitle': 'Your premium subscription will expire in 3 days.',
      },
      {
        'title': 'Daily Horoscope',
        'subtitle': 'Your daily horoscope for today is ready to read.',
      },
      {
        'title': 'Compatibility Match',
        'subtitle': 'Found a 95% compatibility match with Sarah Johnson.',
      },
      {
        'title': 'Transit Alert',
        'subtitle': 'Mercury retrograde starts tomorrow. Prepare yourself!',
      },
      {
        'title': 'New Feature',
        'subtitle': 'Vedic astrology system is now available in your app.',
      },
      {
        'title': 'Reading Complete',
        'subtitle': 'Your personalized reading has been completed.',
      },
      {
        'title': 'Weekly Forecast',
        'subtitle': 'Your weekly forecast for this week is now available.',
      },
      {
        'title': 'Special Offer',
        'subtitle': 'Get 50% off on Platinum plan. Limited time offer!',
      },
      {
        'title': 'Profile Updated',
        'subtitle': 'Your birth details have been updated successfully.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Notification',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(
            title: notification['title']!,
            subtitle: notification['subtitle']!,
          );
        },
      ),
    );
  }
}

// --- Component 1: The Individual Notification Card ---
class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationCard({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.all(16),
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
          children: [
            // Left-side image placeholder
            Container(
              width: 50,
              height: 50,
              child: Center(
                child: Image.asset("assets/icons/image 5.png"),
              ),
            ),

            SizedBox(width: 16),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color(0xffABABAB),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}