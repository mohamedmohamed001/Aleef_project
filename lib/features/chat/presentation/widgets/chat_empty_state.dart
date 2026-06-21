import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ChatEmptyState({
    super.key,
    this.title = 'No chats yet',
    this.subtitle =
    'When you book an appointment or start a conversation, your chats will appear here.',
    this.icon = Icons.forum_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 86.r,
            height: 86.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 38.sp,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF1F2A2E),
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF8A8F93),
              fontSize: 13.sp,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}