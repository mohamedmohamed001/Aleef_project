import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      height: 52.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey.shade100 : Colors.white,
          side: BorderSide(
            color: isDisabled ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: isDisabled ? 0.45 : 1,
              child: Image.asset(
                "assets/images/google2.png",
                height: 22.h,
                width: 22.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              isDisabled ? "Please wait..." : "Sign in with Google",
              style: TextStyle(
                color: isDisabled ? Colors.black38 : Colors.black87,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}