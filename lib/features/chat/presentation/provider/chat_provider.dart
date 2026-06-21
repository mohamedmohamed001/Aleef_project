import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/services/socket_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';
import '../../services/chat_api.dart';

class ChatProvider extends ChangeNotifier {
  final ChatApi _chatApi = ChatApi();
  final SocketService _socketService = getIt<SocketService>();
  final ImagePicker _imagePicker = ImagePicker();

  List<ChatModel> chats = [];
  List<MessageModel> messages = [];

  UserModel? selectedChatUser;

  bool isUploadingImage = false;
  bool isLoading = false;
  bool isChatsLoading = false;
  bool isMessagesLoading = false;

  File? selectedImage;
  String? uploadedImageUrl;
  String? imageUploadError;

  String? errorMessage;
  String? currentChatId;

  bool _isListeningToChatUpdates = false;

  // ================= GET CHATS =================

  Future<bool> getChats() async {
    _setChatsLoading(true);
    errorMessage = null;

    try {
      final response = await _chatApi.getChats();

      if (response['status'] == 'success') {
        final List chatsData = response['data'] ?? [];

        chats = chatsData
            .whereType<Map<String, dynamic>>()
            .map(ChatModel.fromJson)
            .toList();

        _sortChats();
        listenToChatUpdates();
        _setupReconnectHandler();

        return true;
      }

      if (response['status'] == 'unauthorized') {
        return false;
      }

      errorMessage = response['message']?.toString() ?? 'Something went wrong';
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    } finally {
      _setChatsLoading(false);
    }
  }

  // ================= GET CHAT MESSAGES =================

  Future<bool> getChatMessages(String chatId) async {
    _setMessagesLoading(true);

    errorMessage = null;
    currentChatId = chatId;
    markChatAsOpened(chatId, notify: false);

    try {
      final response = await _chatApi.getChatMessages(chatId);

      if (response['status'] == 'success') {
        final List messagesData = response['messages'] ?? [];

        messages = messagesData
            .whereType<Map<String, dynamic>>()
            .map(MessageModel.fromJson)
            .toList();

        _sortMessages();

        if (response['user'] is Map<String, dynamic>) {
          selectedChatUser = UserModel.fromJson(response['user']);
        }

        listenToIncomingMessages(chatId);
        joinChat(chatId);

        return true;
      }

      if (response['status'] == 'unauthorized') {
        return false;
      }

      errorMessage = response['message']?.toString() ?? 'Something went wrong';
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return true;
    } finally {
      _setMessagesLoading(false);
    }
  }

  // ================= JOIN CHAT =================

  void joinChat(String chatId) {
    if (chatId.trim().isEmpty) return;

    debugPrint('🚪 Join chat requested: $chatId');
    debugPrint('🔌 Socket connected: ${_socketService.isConnected}');

    _socketService.joinChat(chatId);
  }

  // ================= RECEIVE MESSAGE =================

  void listenToIncomingMessages(String chatId) {
    _socketService.off('receive_message');
    _socketService.off('error_message');

    _socketService.listen('receive_message', (data) {
      debugPrint('📥 receive_message: $data');

      final newMessage = _messageFromSocket(data);
      if (newMessage == null) return;

      final bool isCurrentOpenedChat = newMessage.chatId == chatId;
      final bool alreadyExists = messages.any((m) => m.id == newMessage.id);
      final bool looksDuplicate = _looksLikeDuplicateMessage(newMessage);

      if (isCurrentOpenedChat && !alreadyExists && !looksDuplicate) {
        messages.add(newMessage);
        _sortMessages();
      }

      _upsertChatLastMessage(newMessage);

      notifyListeners();
    });

    _socketService.listen('error_message', (data) {
      debugPrint('❌ error_message: $data');

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

  // ================= CHAT LIST UPDATES =================

  void listenToChatUpdates() {
    _socketService.off('chat_updated');

    _socketService.listen('chat_updated', (data) {
      debugPrint('🔄 chat_updated: $data');

      final updatedChat = _chatFromSocketUpdate(data);
      if (updatedChat == null) return;

      final index = chats.indexWhere((chat) => chat.id == updatedChat.id);

      if (index != -1) {
        chats[index] = updatedChat;
      } else {
        chats.insert(0, updatedChat);
      }

      _sortChats();

      notifyListeners();
    });
  }

  // ================= IMAGE PICK + UPLOAD =================

  Future<void> pickAndUploadImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) return;

      selectedImage = File(pickedImage.path);
      uploadedImageUrl = null;
      imageUploadError = null;
      isUploadingImage = true;
      notifyListeners();

      final response = await _chatApi.uploadChatbotImage(selectedImage!);

      if (response['status'] == 'success') {
        final imageUrl = response['image']?.toString() ?? '';

        if (imageUrl.trim().isEmpty) {
          imageUploadError = 'Image uploaded but URL not found';
          selectedImage = null;
          uploadedImageUrl = null;
        } else {
          uploadedImageUrl = imageUrl;
        }

        return;
      }

      if (response['status'] == 'unauthorized') {
        imageUploadError = 'Unauthorized';
        selectedImage = null;
        uploadedImageUrl = null;
        return;
      }

      imageUploadError =
          response['message']?.toString() ?? 'Failed to upload image';
      selectedImage = null;
      uploadedImageUrl = null;
    } catch (e) {
      imageUploadError = e.toString();
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
    imageUploadError = null;
    isUploadingImage = false;
    notifyListeners();
  }

  void clearImageUploadError() {
    imageUploadError = null;
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
    final image = uploadedImageUrl?.trim() ?? '';

    if (text.isEmpty && image.isEmpty) return;
    if (chatId.trim().isEmpty) return;

    if (selectedImage != null && image.isEmpty) {
      imageUploadError = 'Please wait until image upload finishes';
      notifyListeners();
      return;
    }

    debugPrint('💬 Send message requested');
    debugPrint('chatId: $chatId');
    debugPrint('currentUserId: $currentUserId');
    debugPrint('receiverId: $receiverId');
    debugPrint('has image: ${image.isNotEmpty}');
    debugPrint('socket connected: ${_socketService.isConnected}');

    final optimisticMessage = MessageModel(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      sender: currentUserId,
      senderModel: null,
      isDeleted: false,
      text: text,
      image: image.isEmpty ? null : image,
      createdAt: DateTime.now(),
    );

    if (currentChatId == chatId && optimisticMessage.hasContent) {
      messages.add(optimisticMessage);
      _sortMessages();
      _upsertChatLastMessage(optimisticMessage);
    }

    _socketService.emitWhenConnected('send_message', {
      'chatId': chatId,
      'message': text,
      if (image.isNotEmpty) 'image': image,
    });

    selectedImage = null;
    uploadedImageUrl = null;
    imageUploadError = null;

    notifyListeners();
  }

  // ================= OPEN CHAT =================

  void markChatAsOpened(String chatId, {bool notify = true}) {
    final index = chats.indexWhere((chat) => chat.id == chatId);
    if (index == -1) return;

    final oldChat = chats[index];

    chats[index] = oldChat.copyWith(unreadCount: 0);

    if (notify) notifyListeners();
  }

  // ================= CLEAR DETAILS =================

  void clearChatDetails({bool notify = true}) {
    messages = [];
    selectedChatUser = null;
    currentChatId = null;
    errorMessage = null;

    isUploadingImage = false;
    selectedImage = null;
    uploadedImageUrl = null;
    imageUploadError = null;

    _socketService.off('receive_message');
    _socketService.off('error_message');

    if (notify) {
      notifyListeners();
    }
  }

  // ================= CLEAR ALL =================

  void clearAll() {
    chats = [];
    messages = [];
    selectedChatUser = null;
    currentChatId = null;
    errorMessage = null;

    isUploadingImage = false;
    selectedImage = null;
    uploadedImageUrl = null;
    imageUploadError = null;

    isLoading = false;
    isChatsLoading = false;
    isMessagesLoading = false;

    _isListeningToChatUpdates = false;

    _socketService.off('receive_message');
    _socketService.off('error_message');
    _socketService.off('chat_updated');

    notifyListeners();
  }

  // ================= SOCKET PARSING =================

  MessageModel? _messageFromSocket(dynamic data) {
    try {
      if (data is! Map) return null;

      final map = Map<String, dynamic>.from(data);

      return MessageModel.fromJson({
        ...map,
        'text': map['text'] ?? map['message'] ?? '',
        'image': map['image'] ?? map['imageUrl'] ?? map['media'] ?? map['file'],
        'createdAt': map['createdAt'] ?? DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('❌ Message socket parse error: $e');
      return null;
    }
  }
  bool _looksLikeDuplicateMessage(MessageModel newMessage) {
    return messages.any((oldMessage) {
      final bool sameText = oldMessage.text.trim() == newMessage.text.trim();

      final bool sameImage =
          (oldMessage.image ?? '').trim().isNotEmpty &&
              (oldMessage.image ?? '').trim() == (newMessage.image ?? '').trim();

      final bool closeTime =
          newMessage.createdAt.difference(oldMessage.createdAt).inSeconds.abs() <
              8;

      return closeTime && (sameImage || sameText);
    });
  }

  ChatModel? _chatFromSocketUpdate(dynamic data) {
    try {
      if (data is! Map) return null;

      final map = Map<String, dynamic>.from(data);

      final chatId = _readString(map, ['id', '_id', 'chatId']);
      if (chatId.isEmpty) return null;

      final existingIndex = chats.indexWhere((chat) => chat.id == chatId);
      final ChatModel? oldChat =
      existingIndex == -1 ? null : chats[existingIndex];

      final lastMessageMap = map['lastMessage'] is Map
          ? Map<String, dynamic>.from(map['lastMessage'])
          : <String, dynamic>{};

      final lastMessage = MessageModel.fromJson({
        ...lastMessageMap,
        'chatId': chatId,
        'text': lastMessageMap['text'] ?? lastMessageMap['message'] ?? '',
        'image': lastMessageMap['image'] ??
            lastMessageMap['imageUrl'] ??
            lastMessageMap['media'] ??
            lastMessageMap['file'],
      });

      final UserModel person = map['person'] is Map
          ? UserModel.fromJson(Map<String, dynamic>.from(map['person']))
          : oldChat?.person ?? UserModel.fromJson({});

      final unreadCount = currentChatId == chatId
          ? 0
          : _parseInt(map['unreadCount']) ?? oldChat?.unreadCount ?? 1;

      return ChatModel(
        id: chatId,
        person: person,
        lastMessage: lastMessage,
        unreadCount: unreadCount,
        updatedAt: _readDate(map['updatedAt']) ?? lastMessage.createdAt,
      );
    } catch (e) {
      debugPrint('❌ Chat update socket parse error: $e');
      return null;
    }
  }

  // ================= UPDATE CHAT LAST MESSAGE =================

  void _upsertChatLastMessage(MessageModel message) {
    if (message.chatId.isEmpty) return;

    final index = chats.indexWhere((chat) => chat.id == message.chatId);
    if (index == -1) {
      getChats();
      return;
    }

    final oldChat = chats[index];
    final bool isOpenedChat = currentChatId == oldChat.id;

    final updatedChat = oldChat.copyWith(
      lastMessage: message,
      unreadCount: isOpenedChat ? 0 : oldChat.unreadCount + 1,
      updatedAt: message.createdAt,
    );

    chats[index] = updatedChat;
    _sortChats();
  }

  // ================= SORTING =================

  void _sortMessages() {
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void _sortChats() {
    chats.sort((a, b) {
      final aDate = a.updatedAt ?? a.lastMessage?.createdAt ?? DateTime(1970);
      final bDate = b.updatedAt ?? b.lastMessage?.createdAt ?? DateTime(1970);

      return bDate.compareTo(aDate);
    });
  }

  // ================= LOADING HELPERS =================

  void _setChatsLoading(bool value) {
    isChatsLoading = value;
    isLoading = value || isMessagesLoading;
    notifyListeners();
  }

  void _setMessagesLoading(bool value) {
    isMessagesLoading = value;
    isLoading = value || isChatsLoading;
    notifyListeners();
  }

  // ================= GENERAL HELPERS =================

  String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return '';
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString());
  }

  DateTime? _readDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }

  void restoreOpenedChat(String chatId) {
    if (chatId.trim().isEmpty) return;

    debugPrint('♻️ Restore opened chat after resume/reconnect: $chatId');

    currentChatId = chatId;

    listenToIncomingMessages(chatId);
    joinChat(chatId);
  }

  void _setupReconnectHandler() {
    _socketService.onSocketReconnected = () async {
      debugPrint('🔁 ChatProvider handling socket reconnect');

      listenToChatUpdates();

      if (currentChatId != null && currentChatId!.isNotEmpty) {
        listenToIncomingMessages(currentChatId!);
        joinChat(currentChatId!);
      }

      await getChats();
    };

    _socketService.onSocketConnected = () {
      debugPrint('✅ ChatProvider handling socket connected');

      listenToChatUpdates();

      if (currentChatId != null && currentChatId!.isNotEmpty) {
        listenToIncomingMessages(currentChatId!);
        joinChat(currentChatId!);
      }
    };
  }
}