import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatLoadingList extends StatelessWidget {
  const ChatLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Container(
          height: 82.h,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: Colors.black.withOpacity(0.04),
            ),
          ),
          child: Row(
            children: [
              _SkeletonBox(
                width: 52.r,
                height: 52.r,
                radius: 26.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SkeletonBox(
                      width: 145.w,
                      height: 12.h,
                      radius: 8.r,
                    ),
                    SizedBox(height: 10.h),
                    _SkeletonBox(
                      width: double.infinity,
                      height: 10.h,
                      radius: 8.r,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              _SkeletonBox(
                width: 38.w,
                height: 10.h,
                radius: 8.r,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.35, end: 1),
      duration: const Duration(milliseconds: 750),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      onEnd: () {},
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}