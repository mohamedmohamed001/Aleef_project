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

class _ChatbotScreenState extends State<ChatbotScreen>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _lastMessageCount = 0;
  double _lastKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ChatbotProvider>();

      await provider.initChatbot();

      if (!mounted) return;
      _scrollToBottom(animated: false);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final provider = context.read<ChatbotProvider>();

      await provider.restoreSocketListenersAfterReconnect();

      if (!mounted) return;
      _scrollToBottom(animated: false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _sendMessage() async {
    final provider = context.read<ChatbotProvider>();
    final text = _messageController.text.trim();

    if (text.isEmpty && provider.uploadedImageUrl == null) return;
    if (provider.isUploadingImage) return;

    _messageController.clear();

     provider.sendMessage(text);

    if (!mounted) return;
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

  void _handleAutoScroll(ChatbotProvider provider) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (keyboardHeight > 0 && _lastKeyboardHeight == 0) {
      _scrollToBottom();
    }

    _lastKeyboardHeight = keyboardHeight;

    final currentCount = provider.messages.length + (provider.isBotTyping ? 1 : 0);

    if (currentCount != _lastMessageCount) {
      _lastMessageCount = currentCount;
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatbotProvider>(
      builder: (context, provider, _) {
        _handleAutoScroll(provider);

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFA),
          resizeToAvoidBottomInset: true,
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
                provider: provider,
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
          image: message.image,
          isMe: provider.isMyMessage(message),
        );
      },
    );
  }
}

class _ChatbotInputBar extends StatefulWidget {
  final TextEditingController controller;
  final ChatbotProvider provider;
  final Future<void> Function() onSend;

  const _ChatbotInputBar({
    required this.controller,
    required this.provider,
    required this.onSend,
  });

  @override
  State<_ChatbotInputBar> createState() => _ChatbotInputBarState();
}

class _ChatbotInputBarState extends State<_ChatbotInputBar> {
  bool _isSending = false;

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

  Future<void> _handleSendTap() async {
    if (_isSending) return;

    setState(() => _isSending = true);

    await widget.onSend();

    if (!mounted) return;
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.trim().isNotEmpty;
    final bool hasImage = widget.provider.uploadedImageUrl != null;

    final bool canSend = !_isSending &&
        !widget.provider.isUploadingImage &&
        (hasText || hasImage);

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.provider.selectedImage != null)
                _SelectedImagePreview(provider: widget.provider),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: widget.provider.isUploadingImage
                        ? null
                        : widget.provider.pickAndUploadImage,
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.09),
                        shape: BoxShape.circle,
                      ),
                      child: widget.provider.isUploadingImage
                          ? Padding(
                        padding: EdgeInsets.all(10.r),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: AppColors.primary,
                        ),
                      )
                          : Icon(
                        Icons.image_outlined,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
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
                          if (canSend) _handleSendTap();
                        },
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1F2937),
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: hasImage
                              ? 'Add a message about this image...'
                              : 'Ask ALEEF anything...',
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
                    onTap: canSend ? _handleSendTap : null,
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
                      child: _isSending
                          ? Padding(
                        padding: EdgeInsets.all(11.r),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                          : Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 19.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedImagePreview extends StatelessWidget {
  final ChatbotProvider provider;

  const _SelectedImagePreview({
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.selectedImage == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(
                provider.selectedImage!,
                width: 92.r,
                height: 92.r,
                fit: BoxFit.cover,
              ),
            ),

            if (provider.isUploadingImage)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.36),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            Positioned(
              top: 5.r,
              right: 5.r,
              child: GestureDetector(
                onTap: provider.removeSelectedImage,
                child: Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.58),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ),

            if (!provider.isUploadingImage && provider.uploadedImageUrl != null)
              Positioned(
                left: 5.r,
                bottom: 5.r,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Ready',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final String? image;
  final bool isMe;

  const _ChatBubble({
    required this.text,
    required this.image,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasText = text.trim().isNotEmpty;
    final bool hasImage = image != null && image!.trim().isNotEmpty;

    if (!hasText && !hasImage) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(hasImage ? 6.r : 0),
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
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.network(
                  image!,
                  width: 255.w,
                  height: 190.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return Container(
                      width: 255.w,
                      height: 190.h,
                      alignment: Alignment.center,
                      color: isMe
                          ? Colors.white.withOpacity(0.12)
                          : const Color(0xFFF3F6F6),
                      child: SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: isMe ? Colors.white : AppColors.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 255.w,
                      height: 150.h,
                      alignment: Alignment.center,
                      color: isMe
                          ? Colors.white.withOpacity(0.12)
                          : const Color(0xFFF3F6F6),
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: isMe ? Colors.white : AppColors.primary,
                        size: 28.sp,
                      ),
                    );
                  },
                ),
              ),

            if (hasText)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  hasImage ? 8.w : 14.w,
                  hasImage ? 8.h : 10.h,
                  hasImage ? 8.w : 14.w,
                  hasImage ? 6.h : 10.h,
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
          ],
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