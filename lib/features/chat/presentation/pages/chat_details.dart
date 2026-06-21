import 'package:aleef/features/chat/presentation/widgets/chat_header.dart';
import 'package:aleef/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:aleef/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:aleef/features/chat/presentation/widgets/messages_empty_view.dart';
import 'package:aleef/features/chat/presentation/widgets/messages_error_view.dart';
import 'package:aleef/features/chat/presentation/widgets/messages_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../providers/user_provider.dart';
import '../provider/chat_provider.dart';

class ChatDetails extends StatefulWidget {
  final String chatId;

  const ChatDetails({super.key, required this.chatId});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  final SessionService session = getIt<SessionService>();

  ChatProvider? _chatProvider;
  String? currentUserId;

  int _lastMessageCount = 0;
  double _lastKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _messageController.addListener(_onMessageChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChatDetails();
    });
  }

  void _onMessageChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      debugPrint('📱 App resumed - restore chat socket');

      final socketService = getIt<SocketService>();

      if (!socketService.isConnected) {
        await socketService.connectCurrentSession();
      }

      if (!mounted) return;

      final provider = _chatProvider ?? context.read<ChatProvider>();
      provider.restoreOpenedChat(widget.chatId);
    }
  }

  Future<void> _loadChatDetails() async {
    _chatProvider = context.read<ChatProvider>();

    await _initSession();

    if (!mounted) return;

    final isAuthorized = await _chatProvider!.getChatMessages(widget.chatId);

    if (!mounted) return;

    if (!isAuthorized) {
      await _logoutAndGoLogin();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
  }

  Future<void> _initSession() async {
    final storage = getIt<SecureStorageService>();

    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);
      currentUserId = user.id;

      if (mounted) {
        context.read<UserProvider>().setUser(user);
        setState(() {});
      }

      return;
    }

    final doctor = await storage.getDoctor();
    final doctorToken = await storage.getDoctorToken();

    if (doctor != null && doctorToken != null && doctorToken.isNotEmpty) {
      session.setDoctorSession(
        doctor: doctor,
        doctorTokenValue: doctorToken,
      );

      currentUserId = doctor.id;

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _logoutAndGoLogin() async {
    final storage = getIt<SecureStorageService>();

    await storage.deleteToken();
    await storage.deleteUser();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  Future<void> _handlePickImage() async {
    final provider = _chatProvider ?? context.read<ChatProvider>();

    if (widget.chatId.trim().isEmpty) return;
    if (currentUserId == null || currentUserId!.isEmpty) return;

    await provider.pickAndUploadImage();

    if (!mounted) return;

    if (provider.imageUploadError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.imageUploadError!),
          behavior: SnackBarBehavior.floating,
        ),
      );

      provider.clearImageUploadError();
    }
  }

  void _handleSend() {
    final provider = _chatProvider ?? context.read<ChatProvider>();
    final content = _messageController.text.trim();

    if (widget.chatId.trim().isEmpty) return;
    if (currentUserId == null || currentUserId!.isEmpty) return;

    final bool hasText = content.isNotEmpty;
    final bool hasImage = provider.uploadedImageUrl != null &&
        provider.uploadedImageUrl!.trim().isNotEmpty;

    if (!hasText && !hasImage) return;

    provider.sendMessage(
      content: content,
      currentUserId: currentUserId!,
      chatId: widget.chatId,
      receiverId: provider.selectedChatUser?.id ?? '',
    );

    if (provider.imageUploadError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.imageUploadError!),
          behavior: SnackBarBehavior.floating,
        ),
      );

      provider.clearImageUploadError();
      return;
    }

    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position.maxScrollExtent;

    if (animated) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(position);
    }
  }

  void _handleAutoScroll(ChatProvider provider) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (keyboardHeight > 0 && _lastKeyboardHeight == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }

    _lastKeyboardHeight = keyboardHeight;

    if (provider.messages.length != _lastMessageCount) {
      _lastMessageCount = provider.messages.length;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _chatProvider?.clearChatDetails(notify: false);
    SocketService().leaveChat(widget.chatId);

    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();

    SocketService().off('receive_message');
    SocketService().off('error_message');

    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    final bool hasText = _messageController.text.trim().isNotEmpty;
    final bool hasImage = provider.uploadedImageUrl != null &&
        provider.uploadedImageUrl!.trim().isNotEmpty;

    final bool canSend = currentUserId != null &&
        currentUserId!.isNotEmpty &&
        widget.chatId.trim().isNotEmpty &&
        !provider.isMessagesLoading &&
        !provider.isUploadingImage &&
        (hasText || hasImage);

    _handleAutoScroll(provider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      bottomNavigationBar: ChatInputBar(
        controller: _messageController,
        canSend: canSend,
        isUploadingImage: provider.isUploadingImage,
        selectedImage: provider.selectedImage,
        uploadedImageUrl: provider.uploadedImageUrl,
        onSend: _handleSend,
        onPickImage: _handlePickImage,
        onRemoveImage: provider.removeSelectedImage,
      ),
      body: Column(
        children: [
          ChatHeader(
            profilePic: provider.selectedChatUser?.profilePic ?? '',
            name: provider.selectedChatUser?.name ?? 'Unknown User',
            status: 'online',
          ),
          Expanded(
            child: _ChatDetailsBody(
              provider: provider,
              currentUserId: currentUserId,
              scrollController: _scrollController,
              formatMessageTime: _formatMessageTime,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _ChatDetailsBody extends StatelessWidget {
  final ChatProvider provider;
  final String? currentUserId;
  final ScrollController scrollController;
  final String Function(DateTime date) formatMessageTime;

  const _ChatDetailsBody({
    required this.provider,
    required this.currentUserId,
    required this.scrollController,
    required this.formatMessageTime,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.isMessagesLoading) {
      return const MessagesLoadingView();
    }

    if (provider.errorMessage != null && provider.messages.isEmpty) {
      return MessagesErrorView(message: provider.errorMessage!);
    }

    if (provider.messages.isEmpty) {
      return const MessagesEmptyView();
    }

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 18.h),
      itemCount: provider.messages.length,
      itemBuilder: (context, index) {
        final message = provider.messages[index];

        final bool isMe =
            currentUserId != null && message.senderId == currentUserId;

        final bool showTopSpace =
            index == 0 ||
                provider.messages[index - 1].senderId != message.senderId;

        return Padding(
          padding: EdgeInsets.only(
            top: showTopSpace ? 6.h : 0,
            bottom: 8.h,
          ),
          child: ChatMessageBubble(
            text: message.text,
            imageUrl: message.image,
            time: formatMessageTime(message.createdAt),
            isMe: isMe,
          ),
        );
      },
    );
  }
}