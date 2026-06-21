import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const DoctorDetailsBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12.h,
      left: 16.w,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100.r),
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .22),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.white.withValues(alpha: .42)),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
