import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Data/services/api_checker.dart';
import '../../Data/services/api_client.dart';
import '../../Data/services/api_constant.dart';
import '../../data/models/notification_model/notification_model.dart';

class NotificationController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final Rx<NotificationModel?> notificationModel = Rx<NotificationModel?>(null);
  final RxList<NotificationData> notifications = <NotificationData>[].obs;
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  /// Get notifications from API
  Future<void> getNotifications({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }

    try {
      Response response = await ApiClient.getData(ApiConstant.notifications);

      if (response.statusCode == 200) {
        notificationModel.value = NotificationModel.fromJson(response.body);
        notifications.value = notificationModel.value?.results ?? [];
        _calculateUnreadCount();
      } else {
        ApiChecker.checkApi(response, getXSnackBar: true);
      }
    } catch (e) {
      print('Error getting notifications: $e');
    } finally {
      if (showLoading) {
        isLoading.value = false;
      }
    }
  }

  /// Refresh notifications (for pull to refresh)
  Future<void> refreshNotifications() async {
    isRefreshing.value = true;
    await getNotifications(showLoading: false);
    isRefreshing.value = false;
  }

  /// Mark notification as read (if API supports it)
  Future<void> markAsRead(int notificationId) async {
    try {
      int index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index].isRead = true;
        notifications.refresh();
        _calculateUnreadCount();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {

      for (var notification in notifications) {
        notification.isRead = true;
      }
      notifications.refresh();
      _calculateUnreadCount();
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      // Remove trailing slash from notifications endpoint and add ID
      String endpoint = ApiConstant.notifications.endsWith('/')
          ? '${ApiConstant.notifications}$notificationId/'
          : '${ApiConstant.notifications}/$notificationId/';

      Response response = await ApiClient.deleteData(endpoint);

      if (response.statusCode == 200 || response.statusCode == 204) {
        notifications.removeWhere((n) => n.id == notificationId);
        _calculateUnreadCount();
        Get.snackbar(
          'Success',
          'Notification deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        ApiChecker.checkApi(response, getXSnackBar: true);
      }
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      // Show confirmation dialog
      bool? confirm = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Clear All Notifications'),
          content: Text('Are you sure you want to clear all notifications?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Clear All', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        notifications.clear();
        unreadCount.value = 0;
        Get.snackbar(
          'Success',
          'All notifications cleared',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }

  /// Calculate unread notification count (public method)
  void calculateUnreadCount() {
    unreadCount.value = notifications.where((n) => n.isRead == false).length;
  }

  /// Private method for internal use
  void _calculateUnreadCount() {
    calculateUnreadCount();
  }

  /// Format time to readable format
  String getFormattedTime(String? createdAt) {
    if (createdAt == null) return '';

    try {
      DateTime dateTime = DateTime.parse(createdAt);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        int years = (difference.inDays / 365).floor();
        return '${years}y ago';
      } else if (difference.inDays > 30) {
        int months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  /// Get detailed formatted date time
  String getDetailedDateTime(String? createdAt) {
    if (createdAt == null) return '';

    try {
      DateTime dateTime = DateTime.parse(createdAt);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  /// Filter notifications by type
  List<NotificationData> getNotificationsByType(String type) {
    return notifications.where((n) => n.notificationType == type).toList();
  }

  /// Get unread notifications only
  List<NotificationData> getUnreadNotifications() {
    return notifications.where((n) => n.isRead == false).toList();
  }
}