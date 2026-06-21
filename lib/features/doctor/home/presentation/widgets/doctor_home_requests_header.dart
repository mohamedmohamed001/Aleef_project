import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHomeRequestsHeader extends StatelessWidget {
  final int requestsCount;

  const DoctorHomeRequestsHeader({
    super.key,
    required this.requestsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointment Requests',
                style: AppTextStyles.title16SemiBold.copyWith(
                  fontSize: 20.sp,
                  color: const Color(0xff172121),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                requestsCount == 0
                    ? 'No requests waiting right now'
                    : 'Review and respond to new bookings',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 36.h,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(99.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.22),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Text(
            requestsCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}