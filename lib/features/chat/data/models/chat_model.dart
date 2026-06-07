import '../../../auth/data/models/user_model.dart';
import 'message_model.dart';

class ChatModel {
  final String id;
  final MessageModel? lastMessage;
  final UserModel person;
  final int unreadCount;
  final DateTime? updatedAt;

  const ChatModel({
    required this.id,
    required this.lastMessage,
    required this.person,
    required this.unreadCount,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: _readString(json, ['id', 'id', 'chatId']),
      lastMessage: json['lastMessage'] is Map<String, dynamic>
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      person: json['person'] is Map<String, dynamic>
          ? UserModel.fromJson(json['person'])
          : UserModel.fromJson(const {}),
      unreadCount: _readInt(json['unreadCount']),
      updatedAt: _readDate(json['updatedAt']),
    );
  }

  ChatModel copyWith({
    String? id,
    MessageModel? lastMessage,
    UserModel? person,
    int? unreadCount,
    DateTime? updatedAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      person: person ?? this.person,
      unreadCount: unreadCount ?? this.unreadCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}