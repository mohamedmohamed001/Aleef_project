import '../../auth/data/models/user_model.dart';

class MessageModel {
  final String id;
  final String chatId;
  final dynamic sender;
  final String? senderModel;
  final bool isDeleted;
  final String text;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.senderModel,
    required this.isDeleted,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      sender: json['sender'] is Map<String, dynamic>
          ? UserModel.fromJson(json['sender'])
          : (json['sender'] ?? ''),
      senderModel: json['senderModel'],
      isDeleted: json['isDeleted'] ?? false,
      text: json['text'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isSenderUserModel => sender is UserModel;

  UserModel? get senderUser => sender is UserModel ? sender as UserModel : null;

  String get senderId {
    if (sender is UserModel) {
      return (sender as UserModel).id;
    }
    return sender.toString();
  }
}