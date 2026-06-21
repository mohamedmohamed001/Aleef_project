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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Ink(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: const Color(0xffE8EEEE),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PetImage(image: petImage),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                petName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xff172121),
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(99.r),
                              ),
                              child: Text(
                                petType,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.h),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 16.sp,
                              color: Colors.black38,
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Text(
                                ownerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            _SmallInfoBox(
                              icon: Icons.calendar_today_rounded,
                              text: date,
                            ),
                            SizedBox(width: 8.w),
                            _SmallInfoBox(
                              icon: Icons.access_time_rounded,
                              text: time,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (reason.trim().isNotEmpty) ...[
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8FAFA),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.sticky_note_2_outlined,
                        size: 17.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          reason,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13.sp,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 14.h),
              if (isLoading)
                SizedBox(
                  height: 44.h,
                  child: Center(
                    child: SizedBox(
                      width: 23.w,
                      height: 23.w,
                      child: const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: OutlinedButton(
                          onPressed: onDecline,
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: const Color(0xffE5484D),
                            backgroundColor: const Color(0xffFFF5F5),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
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
      ),
    );
  }
}

class _PetImage extends StatelessWidget {
  final String image;

  const _PetImage({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.w,
      height: 64.w,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (image.trim().isEmpty) {
      return _fallbackImage();
    }

    return Image.network(
      image,
      width: 64.w,
      height: 64.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _fallbackImage();
      },
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      AppAssets.blankProfilePhoto,
      width: 64.w,
      height: 64.w,
      fit: BoxFit.cover,
    );
  }
}

class _SmallInfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SmallInfoBox({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 9.w,
          vertical: 7.h,
        ),
        decoration: BoxDecoration(
          color: const Color(0xffF3F7F7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xff354545),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}