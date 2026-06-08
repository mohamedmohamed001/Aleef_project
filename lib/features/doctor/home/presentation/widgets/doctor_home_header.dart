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
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 28.h),
          child: Row(
            children: [
              Container(
                width: 62.w,
                height: 62.w,
                padding: EdgeInsets.all(2.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: _buildProfileImage(),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getGreeting()},',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.90),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      _formatDoctorName(doctorName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              DoctorHeaderIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: onNotificationTap,
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
      fit: BoxFit.cover,
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
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 26.sp,
        ),
      ),
    );
  }
}