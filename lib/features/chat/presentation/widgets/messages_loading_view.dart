import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagesLoadingView extends StatelessWidget {
  const MessagesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 18.h),
      children: const [
        _LoadingBubble(isMe: false, widthFactor: 0.70),
        _LoadingBubble(isMe: true, widthFactor: 0.58),
        _LoadingBubble(isMe: false, widthFactor: 0.82),
        _LoadingBubble(isMe: true, widthFactor: 0.64),
        _LoadingBubble(isMe: false, widthFactor: 0.52),
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
    final double width = 260.w * widthFactor;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: width,
        height: 48.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary.withOpacity(0.14) : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
    );
  }
}