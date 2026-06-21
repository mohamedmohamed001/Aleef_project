import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookBigCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final Widget child;

  const BookBigCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6F5),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 24.sp),
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
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}
