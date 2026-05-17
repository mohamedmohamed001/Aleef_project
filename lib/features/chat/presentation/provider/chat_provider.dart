import 'package:flutter/material.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/services/socket_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/chat_model.dart';
import '../../data/message_model.dart';
import '../../services/chat_api.dart';

class ChatProvider extends ChangeNotifier {
  final ChatApi chatApi = ChatApi();
  final SocketService socketService = getIt<SocketService>();

  List<ChatModel> chats = [];
  List<MessageModel> messages = [];

  UserModel? selectedChatUser;

  bool isLoading = false;
  String? errorMessage;

  String? currentChatId;

  bool _isListeningToMessages = false;
  bool _isListeningToChatUpdates = false;

  // ================= GET CHATS =================

  Future<bool> getChats() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await chatApi.getChats();

      print("FULL RESPONSE: $response");

      if (response["status"] == "success") {
        final List chatsData = response["data"] ?? [];
        chats = chatsData.map((e) => ChatModel.fromJson(e)).toList();

        listenToChatUpdates();

        return true;
      } else if (response["status"] == "unauthorized") {
        return false;
      } else {
        errorMessage = response["message"] ?? "Something went wrong";
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
      return true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= GET CHAT MESSAGES =================

  Future<bool> getChatMessages(String chatId) async {
    isLoading = true;
    errorMessage = null;
    currentChatId = chatId;
    notifyListeners();

    try {
      final response = await chatApi.getChatMessages(chatId);

      print("FULL RESPONSE: $response");

      if (response["status"] == "success") {
        final List messagesData = response["messages"] ?? [];
        messages = messagesData.map((e) => MessageModel.fromJson(e)).toList();

        if (response["user"] != null) {
          selectedChatUser = UserModel.fromJson(response["user"]);
        }

        joinChat(chatId);
        listenToIncomingMessages(chatId);

        return true;
      } else if (response["status"] == "unauthorized") {
        return false;
      } else {
        errorMessage = response["message"] ?? "Something went wrong";
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
      return true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================= JOIN CHAT =================

  void joinChat(String chatId) {
    socketService.emit('join_chat', chatId);
    print("📥 Joined chat: $chatId");
  }

  // ================= RECEIVE MESSAGE IN DETAILS =================

  void listenToIncomingMessages(String chatId) {
    socketService.off('receive_message');
    socketService.off('error_message');

    _isListeningToMessages = true;

    socketService.on('receive_message', (data) {
      print("📩 receive_message: $data");

      try {
        final map = Map<String, dynamic>.from(data);
        final newMessage = MessageModel.fromJson(map);

        final alreadyExists = messages.any((m) => m.id == newMessage.id);

        print("newMessage.id = ${newMessage.id}");
        print("alreadyExists = $alreadyExists");

        if (newMessage.chatId == chatId && !alreadyExists) {
          messages.add(newMessage);
          notifyListeners();
        }

        _updateChatLastMessage(newMessage);
      } catch (e) {
        print("❌ Error parsing receive_message: $e");
      }
    });

    socketService.on('error_message', (data) {
      print("❌ error_message: $data");
      errorMessage = data['errMessage']?.toString() ?? "Something went wrong";
      notifyListeners();
    });
  }

  // ================= CHAT LIST UPDATES =================

  void listenToChatUpdates() {
    if (_isListeningToChatUpdates) return;

    _isListeningToChatUpdates = true;

    socketService.off('chat_updated');

    socketService.on('chat_updated', (data) {
      print("💬 chat_updated: $data");

      try {
        final map = Map<String, dynamic>.from(data);

        final chatId = map['id']?.toString();
        if (chatId == null || chatId.isEmpty) return;

        final personMap = Map<String, dynamic>.from(map['person'] ?? {});
        final lastMessageMap =
        Map<String, dynamic>.from(map['lastMessage'] ?? {});

        final lastMessage = MessageModel.fromJson({
          '_id': lastMessageMap['_id'] ?? '',
          'chatId': chatId,
          'sender': lastMessageMap['sender'],
          'text': lastMessageMap['text'] ?? '',
          'createdAt':
          lastMessageMap['createdAt'] ?? DateTime.now().toIso8601String(),
          'isDeleted': lastMessageMap['isDeleted'] ?? false,
        });

        final updatedChat = ChatModel(
          id: chatId,
          person: UserModel.fromJson(personMap),
          lastMessage: lastMessage,
          unreadCount: currentChatId == chatId
              ? 0
              : _parseInt(map['unreadCount']) ?? 1,
        );

        final index = chats.indexWhere((chat) => chat.id == chatId);

        if (index != -1) {
          chats.removeAt(index);
        }

        chats.insert(0, updatedChat);

        notifyListeners();
      } catch (e) {
        print("❌ Error parsing chat_updated: $e");
      }
    });
  }

  // ================= UPDATE CHAT LAST MESSAGE =================

  void _updateChatLastMessage(MessageModel message) {
    final index = chats.indexWhere((chat) => chat.id == message.chatId);

    if (index != -1) {
      final oldChat = chats[index];

      final updatedChat = ChatModel(
        id: oldChat.id,
        lastMessage: message,
        person: oldChat.person,
        unreadCount: currentChatId == oldChat.id ? 0 : oldChat.unreadCount,
      );

      chats.removeAt(index);
      chats.insert(0, updatedChat);

      notifyListeners();
    }
  }

  // ================= OPEN CHAT =================

  void markChatAsOpened(String chatId) {
    final index = chats.indexWhere((chat) => chat.id == chatId);

    if (index == -1) return;

    final oldChat = chats[index];

    chats[index] = ChatModel(
      id: oldChat.id,
      lastMessage: oldChat.lastMessage,
      person: oldChat.person,
      unreadCount: 0,
    );

    notifyListeners();
  }

  // ================= SEND MESSAGE =================

  void sendMessage({
    required String content,
    required String currentUserId,
    required String chatId,
    required String receiverId,
  }) {
    final text = content.trim();
    if (text.isEmpty) return;

    socketService.emit('send_message', {
      'chatId': chatId,
      'message': text,
    });

    print("📤 send_message emitted");
  }

  // ================= CLEAR =================

  void clearChatDetails() {
    messages = [];
    selectedChatUser = null;
    currentChatId = null;
    errorMessage = null;

    socketService.off('receive_message');
    socketService.off('error_message');

    _isListeningToMessages = false;

    notifyListeners();
  }

  // ================= HELPERS =================

  int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }
}