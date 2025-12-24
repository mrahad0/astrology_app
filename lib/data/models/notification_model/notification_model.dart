class NotificationModel {
  int? count;
  dynamic next;
  dynamic previous;
  List<NotificationData>? results;

  NotificationModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'] != null
          ? List<NotificationData>.from(
          json['results'].map((x) => NotificationData.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results?.map((x) => x.toJson()).toList(),
    };
  }
}

class NotificationData {
  int? id;
  String? title;
  String? message;
  String? notificationType;
  bool? isRead;
  dynamic data;
  String? createdAt;

  NotificationData({
    this.id,
    this.title,
    this.message,
    this.notificationType,
    this.isRead,
    this.data,
    this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      notificationType: json['notification_type'],
      isRead: json['is_read'],
      data: json['data'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'notification_type': notificationType,
      'is_read': isRead,
      'data': data,
      'created_at': createdAt,
    };
  }
}