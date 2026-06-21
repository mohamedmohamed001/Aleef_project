import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DoctorImageWithRate extends StatelessWidget {
  final String imageUrl;
  final String rating;

  const DoctorImageWithRate({
    super.key,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty && imageUrl != 'null';

    return SizedBox(
      width: 84.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 82.w,
            height: 96.h,
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.20),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.12),
                width: 1.w,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21.r),
              child: hasImage
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackImage(),
              )
                  : _fallbackImage(),
            ),
          ),
          Positioned(
            bottom: -11.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 9.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: const Color(0xFFFFDFA3),
                  width: 1.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 14.r,
                    color: const Color(0xFFFFB020),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    rating,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF7A5200),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: AppColors.primary.withOpacity(0.08),
      child: Icon(
        Icons.person_rounded,
        size: 40.r,
        color: AppColors.primary,
      ),
    );
  }
}