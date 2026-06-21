import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/data/models/doctor_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorProfileHeaderCard extends StatelessWidget {
  final DoctorProfileModel doctor;
  final VoidCallback onScheduleTap;
  final VoidCallback onEditTap;

  const DoctorProfileHeaderCard({
    super.key,
    required this.doctor,
    required this.onScheduleTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = doctor.profilePic.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -42.w,
            top: -42.h,
            child: _HeaderCircle(
              size: 138.r,
              opacity: 0.10,
            ),
          ),
          Positioned(
            left: -50.w,
            bottom: -62.h,
            child: _HeaderCircle(
              size: 135.r,
              opacity: 0.07,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _DoctorImage(imageUrl: imageUrl),

                  SizedBox(width: 14.w),

                  Expanded(
                    child: _DoctorBasicInfo(doctor: doctor),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              _LocationCard(city: doctor.city),

              SizedBox(height: 14.h),

              Row(
                children: [
                  Expanded(
                    child: _HeaderButton(
                      icon: Icons.calendar_month_outlined,
                      text: 'Schedule',
                      onTap: onScheduleTap,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _HeaderButton(
                      icon: Icons.edit_outlined,
                      text: 'Edit Profile',
                      onTap: onEditTap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DoctorImage extends StatelessWidget {
  final String imageUrl;

  const _DoctorImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78.r,
      height: 78.r,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21.r),
        child: Image(
          image: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/images/default_doctor.png')
          as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _DoctorBasicInfo extends StatelessWidget {
  final DoctorProfileModel doctor;

  const _DoctorBasicInfo({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.name.trim().isEmpty ? 'Doctor Name' : doctor.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),

        SizedBox(height: 7.h),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 5.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Text(
            doctor.specialization.trim().isEmpty
                ? 'Veterinarian'
                : doctor.specialization,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String city;

  const _LocationCard({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 17.sp,
            ),
          ),

          SizedBox(width: 9.w),

          Expanded(
            child: Text(
              city.trim().isEmpty ? 'City not provided' : city,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _HeaderButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17.r),
        child: Container(
          height: 46.h,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 18.sp,
              ),
              SizedBox(width: 7.w),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
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
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}