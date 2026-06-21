import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appointment_status_chip.dart';

class AppointmentHeaderSection extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String status;
  final String imagePath;

  const AppointmentHeaderSection({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imagePath.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -22.w,
            top: -30.h,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 62.r,
                height: 62.r,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.65),
                    width: 1.4.w,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: hasImage
                      ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _avatarFallback(),
                  )
                      : _avatarFallback(),
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title16SemiBold.copyWith(
                        color: Colors.white,
                        fontSize: 18.sp,
                        height: 1.1,
                      ),
                    ),

                    SizedBox(height: 7.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            color: Colors.white.withOpacity(0.9),
                            size: 13.sp,
                          ),
                          SizedBox(width: 5.w),
                          Flexible(
                            child: Text(
                              specialty,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body14Regular.copyWith(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              Align(
                alignment: Alignment.topRight,
                child: AppointmentStatusChip(status: status),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: Colors.white.withOpacity(0.18),
      child: Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 30.sp,
      ),
    );
  }
}