import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHomeOverviewCard extends StatelessWidget {
  final int requestsCount;

  const DoctorHomeOverviewCard({
    super.key,
    required this.requestsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today Overview',
                      style: AppTextStyles.title16SemiBold.copyWith(
                        fontSize: 17.sp,
                        color: const Color(0xff1E2A2A),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      _formatToday(),
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _OnlineBadge(),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _OverviewMiniCard(
                  title: 'Pending',
                  value: requestsCount.toString(),
                  icon: Icons.pending_actions_rounded,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _OverviewMiniCard(
                  title: 'Requests',
                  value: requestsCount == 0 ? 'Clear' : 'Review',
                  icon: Icons.event_note_rounded,
                  isTextValue: requestsCount != 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OnlineBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffEAF7F5),
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: const BoxDecoration(
              color: Color(0xff19D58B),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Online',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isTextValue;

  const _OverviewMiniCard({
    required this.title,
    required this.value,
    required this.icon,
    this.isTextValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xffF7FAFA),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 19.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xff172121),
                    fontSize: isTextValue ? 14.sp : 18.sp,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatToday() {
  final now = DateTime.now();

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${now.day} ${months[now.month - 1]}, ${now.year}';
}