import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../chat/data/models/message_model.dart';
import '../../../chat/presentation/widgets/chat_header.dart';
import '../../provider/chatbot_provider.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ChatbotProvider>();
      await provider.initChatbot();

      if (!mounted) return;
      _scrollToBottom(animated: false);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatbotProvider>().sendMessage(text);
    _messageController.clear();

    _scrollToBottom();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final maxScrollExtent = _scrollController.position.maxScrollExtent;

      if (animated) {
        _scrollController.animateTo(
          maxScrollExtent,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatbotProvider>(
      builder: (context, provider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.messages.isNotEmpty || provider.isBotTyping) {
            _scrollToBottom();
          }
        });

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFA),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              const ChatHeader(
                profilePic:
                'https://cdn-icons-png.flaticon.com/512/6134/6134346.png',
                name: 'ALEEF Assistant',
                status: 'Online',
              ),

              Expanded(
                child: _ChatbotBody(
                  provider: provider,
                  scrollController: _scrollController,
                ),
              ),

              _ChatbotInputBar(
                controller: _messageController,
                onSend: _sendMessage,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatbotBody extends StatelessWidget {
  final ChatbotProvider provider;
  final ScrollController scrollController;

  const _ChatbotBody({
    required this.provider,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const _ChatbotLoadingView();
    }

    if (provider.errorMessage != null && provider.messages.isEmpty) {
      return _ChatbotErrorView(
        message: provider.errorMessage!,
      );
    }

    if (provider.messages.isEmpty) {
      return const _EmptyChatbotView();
    }

    return ListView.builder(
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        16.w,
        14.h,
        16.w,
        16.h,
      ),
      itemCount: provider.messages.length + (provider.isBotTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.messages.length && provider.isBotTyping) {
          return const _TypingBubble();
        }

        final MessageModel message = provider.messages[index];

        return _ChatBubble(
          text: message.text,
          isMe: provider.isMyMessage(message),
        );
      },
    );
  }
}

class _ChatbotInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatbotInputBar({
    required this.controller,
    required this.onSend,
  });

  @override
  State<_ChatbotInputBar> createState() => _ChatbotInputBarState();
}

class _ChatbotInputBarState extends State<_ChatbotInputBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool canSend = widget.controller.text.trim().isNotEmpty;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 18.r,
              offset: Offset(0, -6.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.09),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 42.h,
                    maxHeight: 108.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F6),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.035),
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      if (canSend) widget.onSend();
                    },
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF1F2937),
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask ALEEF anything...',
                      hintStyle: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 11.h,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              GestureDetector(
                onTap: canSend ? widget.onSend : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: canSend
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.35),
                    shape: BoxShape.circle,
                    boxShadow: canSend
                        ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.24),
                        blurRadius: 12.r,
                        offset: Offset(0, 5.h),
                      ),
                    ]
                        : [],
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 19.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const _ChatBubble({
    required this.text,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
        constraints: BoxConstraints(
          maxWidth: 275.w,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isMe ? 18.r : 5.r),
            bottomRight: Radius.circular(isMe ? 5.r : 18.r),
          ),
          border: isMe
              ? null
              : Border.all(
            color: Colors.black.withOpacity(0.035),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isMe ? 0.035 : 0.045),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Text(
          text,
          textDirection: _getTextDirection(text),
          style: TextStyle(
            color: isMe ? Colors.white : const Color(0xFF1F2937),
            fontSize: 14.sp,
            height: 1.38,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  TextDirection _getTextDirection(String value) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(value) ? TextDirection.rtl : TextDirection.ltr;
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _dotOpacity(int index) {
    final value = (_controller.value * 3) - index;

    if (value < 0) return 0.3;
    if (value > 1) return 1;

    return 0.3 + (value * 0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 13.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(5.r),
            bottomRight: Radius.circular(18.r),
          ),
          border: Border.all(
            color: Colors.black.withOpacity(0.035),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Opacity(
                  opacity: _dotOpacity(index),
                  child: Container(
                    width: 7.r,
                    height: 7.r,
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _ChatbotLoadingView extends StatelessWidget {
  const _ChatbotLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 16.h),
      children: const [
        _LoadingBubble(isMe: false, widthFactor: 0.68),
        _LoadingBubble(isMe: true, widthFactor: 0.55),
        _LoadingBubble(isMe: false, widthFactor: 0.82),
        _LoadingBubble(isMe: true, widthFactor: 0.62),
      ],
    );
  }
}

class _LoadingBubble extends StatelessWidget {
  final bool isMe;
  final double widthFactor;

  const _LoadingBubble({
    required this.isMe,
    required this.widthFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 270.w * widthFactor,
        height: 48.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary.withOpacity(0.14) : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.black.withOpacity(0.025),
          ),
        ),
      ),
    );
  }
}

class _EmptyChatbotView extends StatelessWidget {
  const _EmptyChatbotView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82.r,
              height: 82.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.09),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                color: AppColors.primary,
                size: 38.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Ask ALEEF Assistant',
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start a chat and ask anything about your pet’s health, food, vaccines, or care.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF7C8588),
                fontSize: 13.sp,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatbotErrorView extends StatelessWidget {
  final String message;

  const _ChatbotErrorView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 42.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF7C8588),
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}