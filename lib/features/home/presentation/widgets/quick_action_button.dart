import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final double borderRadius;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
    this.onPressed,
    this.borderRadius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius.r);

    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 18.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            splashColor: Colors.white.withOpacity(0.10),
            highlightColor: Colors.transparent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned(
                      top: -constraints.maxHeight * 0.12,
                      right: -constraints.maxWidth * 0.10,
                      child: Container(
                        width: constraints.maxWidth * 0.38,
                        height: constraints.maxWidth * 0.38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48.r,
                            height: 48.r,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}