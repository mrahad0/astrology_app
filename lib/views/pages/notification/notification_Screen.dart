import 'dart:ui';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/notification_controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/notification_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: ResponsiveHelper.padding(20),
        title: Text(
          'Notification',
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(24),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: ResponsiveHelper.padding(20),
              right: ResponsiveHelper.padding(20),
              top: ResponsiveHelper.padding(10),
              bottom: ResponsiveHelper.padding(90),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notifications List
                if (controller.notifications.isNotEmpty)
                  ...controller.notifications.map((notification) {
                    return InkWell(
                      onTap: () {
                        if (notification.id != null && notification.isRead == false) {
                          int idx = controller.notifications.indexWhere((n) => n.id == notification.id);
                          if (idx != -1) {
                            controller.notifications[idx].isRead = true;
                            controller.notifications.refresh();
                            controller.calculateUnreadCount();
                          }
                        }
                      },
                      child: NotificationCard(
                        title: notification.title ?? 'Notification',
                        subtitle: notification.message ?? '',
                        time: controller.getFormattedTime(notification.createdAt),
                        isRead: notification.isRead ?? false,
                        notificationType: notification.notificationType ?? 'success',
                      ),
                    );
                  }).toList()
                else
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.height(40)),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: ResponsiveHelper.iconSize(64),
                            color: Colors.grey,
                          ),
                          SizedBox(height: ResponsiveHelper.space(16)),
                          Text(
                            'No notifications yet',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: ResponsiveHelper.fontSize(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: ResponsiveHelper.space(20)),

                // Notification Preferences Header
                Text(
                  'Notification Preferences',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(20),
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.space(16)),

                // Preference Cards
                PreferenceCard(
                  title: "Major Transit Alerts",
                  subtitle: "Get notified when significant planets activate your natal chart.",
                  value: controller.majorTransitAlerts,
                ),
                PreferenceCard(
                  title: "Daily Cosmic Update",
                  subtitle: "Receive your daily personalised cosmic guidance each morning.",
                  value: controller.dailyCosmicUpdate,
                ),
                PreferenceCard(
                  title: "Reading Ready Alert",
                  subtitle: "Get notified when your Combined Interpretation is generated.",
                  value: controller.readingReadyAlert,
                ),
                PreferenceCard(
                  title: "Monthly Reminder",
                  subtitle: "Get reminded when your monthly Combined Interpretations reset.",
                  value: controller.monthlyReminder,
                ),
              ],
            ),
          ),
        );
      }),
    ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;
  final String notificationType;

  const NotificationCard({
    required this.title,
    required this.subtitle,
    this.time = '',
    this.isRead = false,
    this.notificationType = 'success',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
            decoration: BoxDecoration(
              color: const Color(0xFF15192D).withOpacity(0.7),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              border: Border.all(
                color: const Color(0xFF2D3554),
                width: 1,
              ),
              boxShadow: !isRead
                  ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ResponsiveHelper.width(48),
                  height: ResponsiveHelper.height(48),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
                  ),
                  child: Center(
                    child: Image.asset("assets/images/logo.png1.png"),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.space(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveHelper.fontSize(16),
                              ),
                            ),
                          ),
                          if (time.isNotEmpty)
                            Text(
                              time,
                              style: TextStyle(
                                color: const Color(0xff8B8B8B),
                                fontSize: ResponsiveHelper.fontSize(12),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.space(4)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: const Color(0xffABABAB),
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveHelper.fontSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PreferenceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final RxBool value;

  const PreferenceCard({
    required this.title,
    required this.subtitle,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.space(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
            decoration: BoxDecoration(
              color: const Color(0xFF15192D).withOpacity(0.7),
              borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
              border: Border.all(
                color: const Color(0xFF2D3554),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: ResponsiveHelper.width(48),
                  height: ResponsiveHelper.height(48),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.radius(8)),
                  ),
                  child: Center(
                    child: Image.asset("assets/images/logo.png1.png"),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.space(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.fontSize(16),
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.space(4)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: const Color(0xffABABAB),
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveHelper.fontSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.space(8)),
                Obx(() => CupertinoSwitch(
                    value: value.value,
                    activeColor:  const Color(0xff22C55E),
                    onChanged: (bool newValue) {
                      value.value = newValue;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
