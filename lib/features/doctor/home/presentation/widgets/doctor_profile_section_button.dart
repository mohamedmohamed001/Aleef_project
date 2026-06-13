import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';

class DoctorProfileSectionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const DoctorProfileSectionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  // دالة عرض رسالة تأكيد الخروج
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Logout',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // تنفيذ عملية الخروج والانتقال لصفحة الـ Login
                onTap();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // تحديد ما إذا كان الزرار هو Logout لفتح الـ Dialog
    final bool isLogout = text.toLowerCase() == 'logout';

    return Container(
      width: double.infinity,
      height: 50.h,
      margin: EdgeInsets.only(bottom: 12.h),
      child: OutlinedButton(
        onPressed: isLogout ? () => _showLogoutDialog(context) : onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: (textColor == Colors.red
                ? Colors.red[200]!
                : AppColors.primary.withOpacity(0.5)),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
