import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/auth/presentation/widgets/custom_text_form.dart';
import 'package:aleef/features/chat/widgets/chat_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../providers/user_provider.dart';
import '../provider/chat_provider.dart';

class ChatDetails extends StatefulWidget {
  final String chatId;

  const ChatDetails({super.key, required this.chatId});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final ScrollController _scrollController = ScrollController();
  final SessionService session = getIt<SessionService>();
  final TextEditingController _messageController = TextEditingController();

  ChatProvider? _chatProvider;
  String? currentUserId;
  int _lastMessageCount = 0;
  double _lastKeyboardHeight = 0;

  Future<void> _init() async {
    final storage = getIt<SecureStorageService>();
    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);
      currentUserId = user.id;
      print("USER FROM STORAGE: $user");
      print("USER ID: ${user.id}");

      if (mounted) {
        context.read<UserProvider>().setUser(user);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position.maxScrollExtent;

    if (animated) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(position);
    }
  }

  void _handleSend() {
    final provider = _chatProvider;
    final content = _messageController.text.trim();
    final receiverId = provider?.selectedChatUser?.id ?? '';

    if (provider == null) return;
    if (content.isEmpty) return;
    if (currentUserId == null || currentUserId!.isEmpty) return;
    if (receiverId.isEmpty) return;

    provider.sendMessage(
      content: content,
      currentUserId: currentUserId!,
      chatId: widget.chatId,
      receiverId: receiverId,
    );

    _messageController.clear();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _messageController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    Future.microtask(() async {
      _chatProvider = context.read<ChatProvider>();

      await _init();

      final isAuthorized = await _chatProvider!.getChatMessages(widget.chatId);

      if (!isAuthorized) {
        await SecureStorageService().deleteToken();
        await SecureStorageService().deleteUser();

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
              (route) => false,
        );
        return;
      }

      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(animated: false);
      });
    });
  }

  @override
  void dispose() {
    _chatProvider?.clearChatDetails();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final bool canSend = _messageController.text.trim().isNotEmpty;

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

    return Scaffold(
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 50),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.attach_file_sharp, color: AppColors.primary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextFormField(
                  controller: _messageController,
                  hintText: "Type a message",
                  borderRadius: BorderRadius.circular(30.r),
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: canSend ? _handleSend : null,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: canSend
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          ChatHeader(
            profilePic: provider.selectedChatUser?.profilePic ?? "",
            name: provider.selectedChatUser?.name ?? "Unknown User",
            status: "online",
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xffF8F9FB),
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.errorMessage != null
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
                  : provider.messages.isEmpty
                  ? Center(
                child: Text(
                  "No messages yet",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final message = provider.messages[index];
                  final bool isMe =
                      currentUserId != null &&
                          message.senderId == currentUserId;

                  print("currentUserId: $currentUserId");
                  print("message.senderId: ${message.senderId}");

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints:
                        BoxConstraints(maxWidth: 260.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                            bottomLeft: Radius.circular(
                              isMe ? 16.r : 4.r,
                            ),
                            bottomRight: Radius.circular(
                              isMe ? 4.r : 16.r,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.04,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [
                            Text(
                              message.text,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isMe
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: isMe
                                    ? Colors.white.withValues(
                                  alpha: 0.8,
                                )
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}