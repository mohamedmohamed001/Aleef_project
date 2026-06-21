import 'package:aleef/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final String? imageUrl;
  final String time;
  final bool isMe;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasText = text.trim().isNotEmpty;
    final bool hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (!hasText && !hasImage) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 275.w,
        ),
        padding: EdgeInsets.all(hasImage ? 6.r : 0),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatImageViewer(
                        imageUrl: imageUrl!.trim(),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!.trim(),
                    width: 255.w,
                    height: 190.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
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
                    errorWidget: (context, url, error) {
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
              ),
            if (hasText)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  hasImage ? 8.w : 14.w,
                  hasImage ? 8.h : 10.h,
                  hasImage ? 8.w : 14.w,
                  hasImage ? 6.h : 7.h,
                ),
                child: Text(
                  text,
                  textDirection: _getTextDirection(text),
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: isMe ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                hasImage ? 8.w : 14.w,
                hasText ? 0 : 6.h,
                hasImage ? 8.w : 12.w,
                hasImage ? 5.h : 7.h,
              ),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w600,
                  color: isMe
                      ? Colors.white.withOpacity(0.72)
                      : const Color(0xFF9CA3AF),
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

class ChatImageViewer extends StatelessWidget {
  final String imageUrl;

  const ChatImageViewer({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                        size: 42.sp,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 12.h,
              left: 12.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}