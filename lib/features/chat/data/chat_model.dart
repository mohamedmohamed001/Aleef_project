import '../../auth/data/models/user_model.dart';
import 'message_model.dart';

class ChatModel {
  final String id;
  final MessageModel? lastMessage;
  final UserModel person;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.lastMessage,
    required this.person,
    required this.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? '',
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      person: UserModel.fromJson(json['person'] ?? {}),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
