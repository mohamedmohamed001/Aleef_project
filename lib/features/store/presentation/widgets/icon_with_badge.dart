import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconWithBadge extends StatelessWidget {
  final IconData icon;
  final String count;
  final Color badgeColor;
  final VoidCallback? onTap;

  const IconWithBadge({
    super.key,
    required this.icon,
    required this.count,
    required this.badgeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: SizedBox(
          width: 32.w,
          height: 32.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(
                  icon,
                  color: const Color(0xFF2D3E4E),
                  size: 24, // ثابت عشان ميصغرش زيادة
                ),
              ),

              /// 🔴 Badge
              if (count.isNotEmpty)
                Positioned(
                  right: -2.w,
                  top: -2.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14.w,
                      minHeight: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
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