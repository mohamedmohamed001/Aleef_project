import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/service_locator.dart';
import '../../../core/services/socket_service.dart';
import '../../chat/data/models/message_model.dart';
import '../../chat/services/chat_api.dart';

class ChatbotProvider extends ChangeNotifier {
  final ChatApi _chatApi = ChatApi();
  final SocketService _socketService = getIt<SocketService>();
  final ImagePicker _imagePicker = ImagePicker();

  List<MessageModel> messages = [];

  bool isLoading = false;
  bool isBotTyping = false;
  bool isUploadingImage = false;

  String? errorMessage;
  String? chatId;

  File? selectedImage;
  String? uploadedImageUrl;

  bool _isListeningToMessages = false;

  static const String botId = '00000000-0000-0000-0000-000000000000';

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
            .where((message) => message.hasContent)
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

  // ================= IMAGE =================

  Future<void> pickAndUploadImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) return;

      selectedImage = File(pickedImage.path);
      uploadedImageUrl = null;
      isUploadingImage = true;
      errorMessage = null;
      notifyListeners();

      final response = await _chatApi.uploadChatbotImage(selectedImage!);

      if (response['status'] == 'success') {
        uploadedImageUrl = response['image']?.toString();
      } else if (response['status'] == 'unauthorized') {
        errorMessage = 'Unauthorized';
        selectedImage = null;
        uploadedImageUrl = null;
      } else {
        errorMessage =
            response['message']?.toString() ?? 'Failed to upload image';
        selectedImage = null;
        uploadedImageUrl = null;
      }
    } catch (e) {
      errorMessage = e.toString();
      selectedImage = null;
      uploadedImageUrl = null;
    } finally {
      isUploadingImage = false;
      notifyListeners();
    }
  }

  void removeSelectedImage() {
    selectedImage = null;
    uploadedImageUrl = null;
    isUploadingImage = false;
    notifyListeners();
  }

  // ================= SEND MESSAGE =================

  void sendMessage(String message) {
    final text = message.trim();

    if (text.isEmpty && uploadedImageUrl == null) return;

    if (selectedImage != null && uploadedImageUrl == null) {
      errorMessage = 'Please wait until image upload finishes';
      notifyListeners();
      return;
    }

    isBotTyping = true;
    errorMessage = null;
    notifyListeners();

    _socketService.emit('chat_send', {
      'message': text,
      if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty)
        'image': uploadedImageUrl,
    });

    selectedImage = null;
    uploadedImageUrl = null;
    notifyListeners();
  }

  // ================= LISTEN =================

  void _listenToMessages({bool force = false}) {
    if (_isListeningToMessages && !force) return;

    _isListeningToMessages = true;

    _socketService.off('chat_response');
    _socketService.off('error_message');

    _socketService.listen('chat_response', (data) {
      debugPrint('✅ PROVIDER GOT chat_response: $data');

      final newMessage = _messageFromSocket(data);

      if (newMessage == null) {
        isBotTyping = false;
        notifyListeners();
        return;
      }

      final exists = messages.any((message) => message.id == newMessage.id);

      if (!exists && newMessage.hasContent) {
        messages.add(newMessage);
        _sortMessages();
      }

      if (isBotMessage(newMessage)) {
        isBotTyping = false;
      }

      notifyListeners();
    });

    _socketService.listen('error_message', (data) {
      debugPrint('✅ PROVIDER GOT error_message: $data');

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
    isUploadingImage = false;
    errorMessage = null;
    chatId = null;
    selectedImage = null;
    uploadedImageUrl = null;
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
      'id': map['id'] ?? map['_id'] ?? '',
      'senderModel': isBot ? 'Bot' : 'User',
      'chatId': map['chatId'] ?? chatId ?? '',
      'text': map['text'] ?? map['message'] ?? '',
      'image': map['image'],
      'isDeleted': map['isDeleted'] == true,
    });
  }

  MessageModel? _messageFromSocket(dynamic data) {
    try {
      if (data is! Map) return null;

      final map = Map<String, dynamic>.from(data);

      final senderId = _getSenderId(map['sender']);
      final bool isBot = senderId == botId;

      return MessageModel.fromJson({
        'id': map['id'] ??
            map['_id'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        'chatId': map['chatId'] ?? chatId ?? '',
        'sender': map['sender'],
        'senderModel': isBot ? 'Bot' : 'User',
        'text': map['text'] ?? map['message'] ?? '',
        'image': map['image'],
        'isDeleted': map['isDeleted'] == true,
        'createdAt': map['createdAt'] ?? DateTime.now().toIso8601String(),
      });
    } catch (_) {
      return null;
    }
  }

  Future<void> restoreSocketListenersAfterReconnect() async {
    try {
      await _socketService.connectCurrentSession();

      _isListeningToMessages = false;

      _socketService.off('chat_response');
      _socketService.off('error_message');

      _listenToMessages(force: true);

      debugPrint('✅ Chatbot listeners restored after reconnect');
    } catch (e) {
      debugPrint('❌ Restore chatbot socket error: $e');
    }
  }

  String? _getSenderId(dynamic sender) {
    if (sender == null) return null;

    if (sender is String) return sender;

    if (sender is Map) {
      return sender['id']?.toString() ??
          sender['_id']?.toString() ??
          sender['userId']?.toString();
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