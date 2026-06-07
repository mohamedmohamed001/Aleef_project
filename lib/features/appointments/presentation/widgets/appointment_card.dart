import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String petName;
  final String petType;
  final String status;
  final String imagePath;
  final VoidCallback? onViewDetails;

  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.petName,
    required this.petType,
    this.status = "Confirmed",
    this.imagePath = AppAssets.profilePhoto,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase().trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.10),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _PrimaryHeader(
            doctorName: doctorName,
            specialty: specialty,
            status: normalizedStatus,
            imagePath: imagePath,
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: _InfoChip(
                  icon: Icons.calendar_month_rounded,
                  label: "Date",
                  value: date,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _InfoChip(
                  icon: Icons.access_time_rounded,
                  label: "Time",
                  value: time,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _InfoChip(
                  icon: Icons.pets_rounded,
                  label: "Pet",
                  value: petName.isEmpty ? "Pet" : petName,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onViewDetails,
              borderRadius: BorderRadius.circular(18.r),
              child: Ink(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.18),
                      blurRadius: 14.r,
                      offset: Offset(0, 7.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryHeader extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String status;
  final String imagePath;

  const _PrimaryHeader({
    required this.doctorName,
    required this.specialty,
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -42.h,
            right: -34.w,
            child: _SoftCircle(size: 100.r),
          ),
          Positioned(
            bottom: -54.h,
            left: -44.w,
            child: _SoftCircle(size: 105.r, opacity: 0.06),
          ),

          /// padding للمحتوى فقط
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                _DoctorImage(imagePath: imagePath),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                _StatusChip(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorImage extends StatelessWidget {
  final String imagePath;

  const _DoctorImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final hasNetworkImage = imagePath.trim().isNotEmpty;

    return Container(
      width: 56.r,
      height: 56.r,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.32), width: 1.2.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.r),
        child: hasNetworkImage
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackIcon(),
              )
            : _fallbackIcon(),
      ),
    );
  }

  Widget _fallbackIcon() {
    return Icon(
      Icons.medical_services_rounded,
      color: Colors.white,
      size: 27.sp,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(status);
    final text = status.isEmpty ? "confirmed" : status.toLowerCase().trim();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: colors.border, width: 1.w),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: colors.text,
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }

  _StatusChipColors _statusColors(String status) {
    switch (status.toLowerCase().trim()) {
      case "confirmed":
        return _StatusChipColors(
          background: const Color(0xFF19D58B).withOpacity(0.22),
          border: const Color(0xFF19D58B).withOpacity(0.10),
          text: const Color(0xFFBFFFE2),
        );

      case "pending":
        return _StatusChipColors(
          background: const Color(0xFFFFB020).withOpacity(0.22),
          border: const Color(0xFFFFB020).withOpacity(0.12),
          text: const Color(0xFFFFE3A3),
        );

      case "cancelled":
      case "canceled":
        return _StatusChipColors(
          background: const Color(0xFFE5484D).withOpacity(0.22),
          border: const Color(0xFFE5484D).withOpacity(0.12),
          text: const Color(0xFFFFC7C9),
        );

      case "completed":
        return _StatusChipColors(
          background: const Color(0xFF2F80ED).withOpacity(0.22),
          border: const Color(0xFF2F80ED).withOpacity(0.12),
          text: const Color(0xFFCFE3FF),
        );

      default:
        return _StatusChipColors(
          background: const Color(0xFF19D58B).withOpacity(0.22),
          border: const Color(0xFF19D58B).withOpacity(0.10),
          text: const Color(0xFFBFFFE2),
        );
    }
  }
}

class _StatusChipColors {
  final Color background;
  final Color border;
  final Color text;

  const _StatusChipColors({
    required this.background,
    required this.border,
    required this.text,
  });
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.075),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18.sp),
          SizedBox(height: 7.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF667085),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF101828),
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _SoftCircle({required this.size, this.opacity = 0.10});

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
