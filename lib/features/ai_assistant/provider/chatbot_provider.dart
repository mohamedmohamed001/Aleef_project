import 'package:flutter/material.dart';

import '../../../core/services/service_locator.dart';
import '../../../core/services/socket_service.dart';
import '../../chat/data/models/message_model.dart';
import '../../chat/services/chat_api.dart';

class ChatbotProvider extends ChangeNotifier {
  final ChatApi _chatApi = ChatApi();
  final SocketService _socketService = getIt<SocketService>();

  List<MessageModel> messages = [];

  bool isLoading = false;
  bool isBotTyping = false;

  String? errorMessage;
  String? chatId;

  bool _isListeningToMessages = false;

  static const String botId = '000000000000000000000000';

  // ================= INIT CHATBOT =================

  Future<bool> initChatbot() async {
    _setLoading(true);
    errorMessage = null;

    try {
      final response = await _chatApi.getChatbotMessages();

      if (response['status'] == 'success') {
        chatId = response['chatId']?.toString();

        final List data = response['messages'] ?? [];

        messages = data
            .whereType<Map<String, dynamic>>()
            .map(_messageFromHistory)
            .where((message) => message.text.trim().isNotEmpty)
            .toList();

        _sortMessages();
        _listenToMessages();

        return true;
      }

      if (response['status'] == 'unauthorized') {
        errorMessage = 'Unauthorized';
        return false;
      }

      errorMessage = response['message']?.toString() ?? 'Something went wrong';
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    } finally {
      _setLoading(false);
    }
  }

  // ================= SEND MESSAGE =================

  void sendMessage(String message) {
    final text = message.trim();
    if (text.isEmpty) return;

    isBotTyping = true;
    errorMessage = null;
    notifyListeners();

    _socketService.emit('chat_send', {
      'message': text,
    });
  }

  // ================= LISTEN =================

  void _listenToMessages() {
    if (_isListeningToMessages) return;

    _isListeningToMessages = true;

    _socketService.off('chat_response');
    _socketService.off('error_message');

    _socketService.listen('chat_response', (data) {
      final newMessage = _messageFromSocket(data);

      if (newMessage == null) {
        isBotTyping = false;
        notifyListeners();
        return;
      }

      final exists = messages.any((message) => message.id == newMessage.id);

      if (!exists && newMessage.text.trim().isNotEmpty) {
        messages.add(newMessage);
        _sortMessages();
      }

      if (isBotMessage(newMessage)) {
        isBotTyping = false;
      }

      notifyListeners();
    });

    _socketService.listen('error_message', (data) {
      isBotTyping = false;

      if (data is Map) {
        errorMessage = data['errMessage']?.toString() ??
            data['message']?.toString() ??
            'Something went wrong';
      } else {
        errorMessage = 'Something went wrong';
      }

      notifyListeners();
    });
  }

  // ================= HELPERS =================

  bool isMyMessage(MessageModel message) {
    return message.senderModel == 'User';
  }

  bool isBotMessage(MessageModel message) {
    return message.senderModel == 'Bot';
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void clearChatbot() {
    messages = [];
    isLoading = false;
    isBotTyping = false;
    errorMessage = null;
    chatId = null;
    _isListeningToMessages = false;

    _socketService.off('chat_response');
    _socketService.off('error_message');

    notifyListeners();
  }

  MessageModel _messageFromHistory(Map<String, dynamic> map) {
    final senderId = _getSenderId(map['sender']);
    final bool isBot = senderId == botId;

    return MessageModel.fromJson({
      ...map,
      'senderModel': isBot ? 'Bot' : 'User',
      'chatId': map['chatId'] ?? chatId ?? '',
    });
  }

  MessageModel? _messageFromSocket(dynamic data) {
    try {
      if (data is! Map) return null;

      final map = Map<String, dynamic>.from(data);

      final senderId = _getSenderId(map['sender']);
      final bool isBot = senderId == botId;

      return MessageModel.fromJson({
        '_id': map['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'chatId': map['chatId'] ?? chatId ?? '',
        'sender': map['sender'],
        'senderModel': isBot ? 'Bot' : 'User',
        'text': map['text'] ?? map['message'] ?? '',
        'isDeleted': map['isDeleted'] ?? false,
        'createdAt': map['createdAt'] ?? DateTime.now().toIso8601String(),
      });
    } catch (_) {
      return null;
    }
  }

  String? _getSenderId(dynamic sender) {
    if (sender == null) return null;

    if (sender is String) return sender;

    if (sender is Map) {
      return sender['_id']?.toString() ?? sender['id']?.toString();
    }

    return sender.toString();
  }

  void _sortMessages() {
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}