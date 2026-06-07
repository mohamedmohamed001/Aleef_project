import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.time,
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
        constraints: BoxConstraints(
          maxWidth: 272.w,
        ),
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 12.w, 7.h),
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
            Text(
              text,
              textDirection: _getTextDirection(text),
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.35,
                fontWeight: FontWeight.w500,
                color: isMe ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              time,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: isMe
                    ? Colors.white.withOpacity(0.72)
                    : const Color(0xFF9CA3AF),
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