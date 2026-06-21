import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHomeHeader extends StatelessWidget {
  final String doctorName;
  final String? profileImage;
  final VoidCallback onNotificationTap;

  const DoctorHomeHeader({
    super.key,
    required this.doctorName,
    required this.profileImage,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.88),
                const Color(0xff185D59),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -45.h,
                right: -35.w,
                child: _HeaderCircle(size: 135.w, opacity: 0.12),
              ),
              Positioned(
                bottom: -55.h,
                left: -35.w,
                child: _HeaderCircle(size: 125.w, opacity: 0.10),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 30.h),
                  child: Row(
                    children: [
                      Container(
                        width: 66.w,
                        height: 66.w,
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.14),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: _buildProfileImage(),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(99.r),
                              ),
                              child: Text(
                                _getGreeting(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.92),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _formatDoctorName(doctorName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23.sp,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              'Manage today’s appointments',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.72),
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      DoctorHeaderIconButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: onNotificationTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (profileImage == null || profileImage!.trim().isEmpty) {
      return Image.asset(
        AppAssets.blankProfilePhoto,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      profileImage!,
      key: ValueKey(profileImage),
      fit: BoxFit.cover,
      gaplessPlayback: false,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          AppAssets.blankProfilePhoto,
          fit: BoxFit.cover,
        );
      },
    );
  }

  String _formatDoctorName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return 'Doctor';
    }

    if (trimmedName.toLowerCase().startsWith('dr.')) {
      return trimmedName;
    }

    return 'Dr. $trimmedName';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';

    return 'Good evening';
  }
}

class DoctorHeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const DoctorHeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.16),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 52.w,
          height: 52.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.16),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 26.sp,
          ),
        ),
      ),
    );
  }
}

class _HeaderCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _HeaderCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(opacity),
          width: 18.w,
        ),
      ),
    );
  }
}