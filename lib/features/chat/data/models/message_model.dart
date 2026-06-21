import '../../../auth/data/models/user_model.dart';

class MessageModel {
  final String id;
  final String chatId;
  final dynamic sender;
  final String? senderModel;
  final bool isDeleted;
  final String text;
  final String? image;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.senderModel,
    required this.isDeleted,
    required this.text,
    this.image,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: _readString(json, ['id', '_id']),
      chatId: _readChatId(json),
      sender: _readSender(json['sender']),
      senderModel: json['senderModel']?.toString(),
      isDeleted: json['isDeleted'] == true,
      text: (json['text'] ?? json['message'] ?? '').toString(),
      image: _readNullableString(json['image']),
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
    String? image,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      sender: sender ?? this.sender,
      senderModel: senderModel ?? this.senderModel,
      isDeleted: isDeleted ?? this.isDeleted,
      text: text ?? this.text,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get hasText => text.trim().isNotEmpty;

  bool get hasImage => image != null && image!.trim().isNotEmpty;

  bool get hasContent => hasText || hasImage;

  bool get isSenderUserModel => sender is UserModel;

  UserModel? get senderUser {
    if (sender is UserModel) return sender as UserModel;
    return null;
  }

  String get senderId {
    if (sender is UserModel) {
      return (sender as UserModel).id;
    }

    if (sender is Map<String, dynamic>) {
      return _readString(sender as Map<String, dynamic>, ['id', '_id']);
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
      // لو sender فيه id بس ومفيهوش بيانات User كاملة، منعملش UserModel عشان ميكسرش
      if (value.containsKey('name') ||
          value.containsKey('email') ||
          value.containsKey('profilePic')) {
        return UserModel.fromJson(value);
      }

      return _readString(value, ['id', '_id']);
    }

    return value?.toString() ?? '';
  }

  static String _readChatId(Map<String, dynamic> json) {
    final directChatId = json['chatId'] ?? json['chatid'];

    if (directChatId is Map<String, dynamic>) {
      return _readString(directChatId, ['id', '_id']);
    }

    if (directChatId != null && directChatId.toString().trim().isNotEmpty) {
      return directChatId.toString();
    }

    final chat = json['chat'];

    if (chat is Map<String, dynamic>) {
      return _readString(chat, ['id', '_id']);
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

  static String? _readNullableString(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();

    if (text.isEmpty || text == 'null') {
      return null;
    }

    return text;
  }

  static DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}