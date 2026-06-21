import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

class InAppNotificationBanner extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const InAppNotificationBanner({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      color: AppColors.primary,
                      size: 23.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.25,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: onClose,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}