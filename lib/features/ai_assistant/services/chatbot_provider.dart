import 'package:flutter/cupertino.dart';

import '../../../core/services/service_locator.dart';
import '../../../core/services/socket_service.dart';
import '../../chat/data/message_model.dart';
import '../../chat/services/chat_api.dart';

class ChatbotProvider extends ChangeNotifier {
  final ChatApi chatApi = ChatApi();
  final SocketService socketService = getIt<SocketService>();

  List<MessageModel> messages = [];

  bool isLoading = false;
  bool isBotTyping = false;

  String? errorMessage;
  String? chatId;

  bool _isListeningToMessages = false;

  static const String botId = '000000000000000000000000';

  Future<void> initChatbot() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await chatApi.getChatbotMessages();

      print("🤖 CHATBOT RESPONSE: $response");

      if (response["status"] == "success") {
        chatId = response["chatId"]?.toString();

        final List data = response["messages"] ?? [];

        messages = data.map((e) {
          final map = Map<String, dynamic>.from(e);

          final senderId = _getSenderId(map['sender']);
          final isBot = senderId == botId;

          return MessageModel.fromJson({
            ...map,
            'senderModel': isBot ? 'Bot' : 'User',
          });
        }).toList();

        _listenToMessages();
      } else if (response["status"] == "unauthorized") {
        errorMessage = "Unauthorized";
      } else {
        errorMessage = response["message"] ?? "Something went wrong";
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? _getSenderId(dynamic sender) {
    if (sender == null) return null;

    if (sender is String) return sender;

    if (sender is Map) {
      return sender['_id']?.toString() ?? sender['id']?.toString();
    }

    return null;
  }

  bool isMyMessage(MessageModel message) {
    return message.senderModel == 'User';
  }

  bool isBotMessage(MessageModel message) {
    return message.senderModel == 'Bot';
  }

  void _listenToMessages() {
    if (_isListeningToMessages) return;

    _isListeningToMessages = true;

    socketService.off('chat_response');
    socketService.off('error_message');

    socketService.on('chat_response', (data) {
      print("📩 chat_response: $data");

      try {
        final map = Map<String, dynamic>.from(data);

        final senderId = _getSenderId(map['sender']);
        final isBot = senderId == botId;

        final newMessage = MessageModel.fromJson({
          '_id': map['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          'chatId': map['chatId'] ?? chatId ?? '',
          'sender': map['sender'],
          'senderModel': isBot ? 'Bot' : 'User',
          'text': map['text'] ?? map['message'] ?? '',
          'isDeleted': map['isDeleted'] ?? false,
          'createdAt': map['createdAt'] ?? DateTime.now().toIso8601String(),
        });

        if (newMessage.text.trim().isEmpty) return;

        final exists = messages.any((m) => m.id == newMessage.id);

        if (!exists) {
          messages.add(newMessage);
        }

        if (isBot) {
          isBotTyping = false;
        }

        notifyListeners();
      } catch (e) {
        isBotTyping = false;
        notifyListeners();
        print("❌ Error parsing chat_response: $e");
      }
    });

    socketService.on('error_message', (data) {
      print("❌ error_message: $data");

      isBotTyping = false;
      errorMessage = data['errMessage']?.toString() ?? "Something went wrong";
      notifyListeners();
    });
  }

  void sendMessage(String message) {
    final text = message.trim();
    if (text.isEmpty) return;

    isBotTyping = true;
    errorMessage = null;
    notifyListeners();

    socketService.emit('chat_send', {
      'message': text,
    });
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}