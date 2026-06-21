import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';

class DoctorProfileSectionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final bool isLogout;

  const DoctorProfileSectionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.isLogout = false,
  });

  void _showLogoutDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onTap();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = textColor ?? Colors.black87;
    final Color buttonIconColor = iconColor ?? AppColors.primary;

    return Container(
      width: double.infinity,
      height: 50.h,
      margin: EdgeInsets.only(bottom: 12.h),
      child: OutlinedButton(
        onPressed: isLogout ? () => _showLogoutDialog(context) : onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isLogout
                ? Colors.red.withOpacity(0.35)
                : AppColors.primary.withOpacity(0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: buttonIconColor,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: buttonColor,
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