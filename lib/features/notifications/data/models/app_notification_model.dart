class AppNotificationModel {
  final String id;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  AppNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.data,
  });

  factory AppNotificationModel.fromApi(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      isRead: json['is_read'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      data: {
        'orderId': json['order_id'],
        'appointmentId': json['appointment_id'],
        'petId': json['pet_id'],
        'chatId': json['chat_id'],
      },
    );
  }

  factory AppNotificationModel.fromSocket(Map<String, dynamic> json) {
    final socketData = json['data'];

    return AppNotificationModel(
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      type: json['type']?.toString() ??
          (socketData is Map ? socketData['type']?.toString() : '') ??
          '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      isRead: false,
      createdAt: DateTime.now(),
      data: socketData is Map<String, dynamic> ? socketData : null,
    );
  }
}