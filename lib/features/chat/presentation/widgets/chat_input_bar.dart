import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/auth/presentation/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.canSend,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 11.h, 16.w, 16.h),
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
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.09),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextFormField(
                  controller: controller,
                  hintText: 'Type a message...',
                  borderRadius: BorderRadius.circular(24.r),
                  minLines: 1,
                  maxLines: 4,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: canSend ? onSend : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
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