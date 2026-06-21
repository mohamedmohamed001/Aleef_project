import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/profile/presentation/pages/settings/about_aleef_screen.dart';
import 'package:aleef/features/profile/presentation/pages/settings/help_support_screen.dart';
import 'package:aleef/features/profile/presentation/pages/settings/notification_settings_screen.dart';
import 'package:aleef/features/profile/presentation/pages/settings/privacy_security_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (bottomSheetContext) {
      return Container(
        margin: EdgeInsets.all(14.r),
        padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Settings",
                          style: AppTextStyles.black16Bold.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Manage your ALEEF preferences",
                          style: AppTextStyles.hint14Regular.copyWith(
                            fontSize: 12.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _SettingsSheetItem(
                icon: Icons.notifications_none_rounded,
                title: "Notification Settings",
                subtitle: "Manage app alerts and reminders",
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationSettingsScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              _SettingsSheetItem(
                icon: Icons.lock_outline_rounded,
                title: "Privacy & Security",
                subtitle: "Password, account and privacy options",
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrivacySecurityScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              _SettingsSheetItem(
                icon: Icons.help_outline_rounded,
                title: "Help & Support",
                subtitle: "Get help or contact support",
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpSupportScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              _SettingsSheetItem(
                icon: Icons.info_outline_rounded,
                title: "About ALEEF",
                subtitle: "Version, terms and app information",
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AboutAleefScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SettingsSheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsSheetItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7FAFA),
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 13.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 21.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: const Color(0xFF111827),
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade400,
                size: 15.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
