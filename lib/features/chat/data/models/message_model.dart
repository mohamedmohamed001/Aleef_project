import '../../../auth/data/models/user_model.dart';

class MessageModel {
  final String id;
  final String chatId;
  final dynamic sender;
  final String? senderModel;
  final bool isDeleted;
  final String text;
  final DateTime createdAt;

  const MessageModel({
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
      id: _readString(json, ['id', 'id']),
      chatId: _readChatId(json),
      sender: _readSender(json['sender']),
      senderModel: json['senderModel']?.toString(),
      isDeleted: json['isDeleted'] == true,
      text: json['text']?.toString() ?? '',
      createdAt: _readDate(json['createdAt']) ?? DateTime.now(),
    );
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    dynamic sender,
    String? senderModel,
    bool? isDeleted,
    String? text,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      sender: sender ?? this.sender,
      senderModel: senderModel ?? this.senderModel,
      isDeleted: isDeleted ?? this.isDeleted,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get hasText => text.trim().isNotEmpty;

  bool get isSenderUserModel => sender is UserModel;

  UserModel? get senderUser {
    if (sender is UserModel) return sender as UserModel;
    return null;
  }

  String get senderId {
    if (sender is UserModel) {
      return (sender as UserModel).id;
    }

    return sender?.toString() ?? '';
  }

  String get senderName {
    if (sender is UserModel) {
      return (sender as UserModel).name;
    }

    return '';
  }

  String get senderProfilePic {
    if (sender is UserModel) {
      return (sender as UserModel).profilePic;
    }

    return '';
  }

  static dynamic _readSender(dynamic value) {
    if (value is Map<String, dynamic>) {
      return UserModel.fromJson(value);
    }

    return value?.toString() ?? '';
  }

  static String _readChatId(Map<String, dynamic> json) {
    final directChatId = json['chatId'];

    if (directChatId is Map<String, dynamic>) {
      return _readString(directChatId, ['id', 'id']);
    }

    if (directChatId != null && directChatId.toString().trim().isNotEmpty) {
      return directChatId.toString();
    }

    final chat = json['chat'];

    if (chat is Map<String, dynamic>) {
      return _readString(chat, ['id', 'id']);
    }

    return '';
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

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}