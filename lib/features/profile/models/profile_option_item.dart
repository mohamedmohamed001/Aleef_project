import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileOptionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;
  final Widget? trailing; // 🔥 إضافة مهمة

  const ProfileOptionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              /// 🔹 Icon Container
              Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),

              SizedBox(width: 14.w),

              /// 🔹 Title
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.black16Bold.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),

              /// 🔹 Trailing أو Arrow
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}