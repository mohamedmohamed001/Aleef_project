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
    final bool showBadge = count.isNotEmpty && count != '0';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: SizedBox(
          width: 32.r,
          height: 32.r,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(
                  icon,
                  color: const Color(0xFF2D3E4E),
                  size: 24.sp,
                ),
              ),

              if (showBadge)
                Positioned(
                  right: -3.w,
                  top: -4.h,
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 16.r,
                      minHeight: 16.r,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5.w,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w900,
                        height: 1,
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