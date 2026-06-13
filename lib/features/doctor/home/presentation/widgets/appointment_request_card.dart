import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentRequestCard extends StatelessWidget {
  final String appointmentId;
  final String petName;
  final String petImage;
  final String petType;
  final String ownerName;
  final String date;
  final String time;
  final String reason;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const AppointmentRequestCard({
    super.key,
    required this.appointmentId,
    required this.petName,
    required this.petImage,
    required this.petType,
    required this.ownerName,
    required this.date,
    required this.time,
    required this.reason,
    required this.isLoading,
    required this.onTap,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.black.withOpacity(0.07),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: _buildPetImage(),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        petName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Text(
                        '$petType • Owner: $ownerName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black54,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Text(
                        '$date  •  $time',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (reason.trim().isNotEmpty) ...[
              SizedBox(height: 14.h),

              Text(
                'Reason for visit',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                reason,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
            ],

            SizedBox(height: 18.h),

            if (isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton.icon(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        icon: Icon(
                          Icons.check_rounded,
                          size: 19.sp,
                        ),
                        label: Text(
                          'Accept',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: OutlinedButton.icon(
                        onPressed: onDecline,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          side: BorderSide(
                            color: Colors.red,
                            width: 1.3.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 19.sp,
                        ),
                        label: Text(
                          'Decline',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetImage() {
    if (petImage.trim().isEmpty) {
      return _fallbackImage();
    }

    return Image.network(
      petImage,
      width: 62.w,
      height: 62.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _fallbackImage();
      },
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      AppAssets.blankProfilePhoto,
      width: 62.w,
      height: 62.w,
      fit: BoxFit.cover,
    );
  }
}