import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/notification_controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
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

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: ResponsiveHelper.padding(10),
              right: ResponsiveHelper.padding(10),
              top: ResponsiveHelper.padding(10),
              bottom: ResponsiveHelper.padding(70),
            ),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
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
            },
          ),
        );
      }),
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
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.padding(16)),
        decoration: BoxDecoration(
          color: CustomColors.secondbackgroundColor,
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          border: Border.all(
            color: Color(0xff2E334A),
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
              width: ResponsiveHelper.width(50),
              height: ResponsiveHelper.height(50),
              child: Center(
                child: Image.asset("assets/images/logo.png1.png"),
              ),
            ),

            SizedBox(width: ResponsiveHelper.space(16)),
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
                            color: Color(0xff8B8B8B),
                            fontSize: ResponsiveHelper.fontSize(12),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.space(4)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color(0xffABABAB),
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
    );
  }
}