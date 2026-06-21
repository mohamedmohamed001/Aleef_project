import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/info_line.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/pet_small_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetAppointmentCard extends StatelessWidget {
  final String petName;
  final String petType;
  final String? petBreed;
  final String? petImage;
  final dynamic age;
  final dynamic weight;
  final String? gender;
  final String ownerName;
  final String? ownerPhone;
  final String appointmentDate;
  final String? reason;
  final VoidCallback? onPetProfileTap;

  const PetAppointmentCard({
    super.key,
    required this.petName,
    required this.petType,
    required this.petBreed,
    required this.petImage,
    required this.age,
    required this.weight,
    required this.gender,
    required this.ownerName,
    required this.ownerPhone,
    required this.appointmentDate,
    required this.reason,
    this.onPetProfileTap,
  });

  String _safeText(
      dynamic value, {
        String defaultValue = 'N/A',
      }) {
    if (value == null) return defaultValue;

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return defaultValue;
    }

    return text;
  }

  String _formatAge(dynamic value) {
    final text = _safeText(value);

    if (text == 'N/A' || text == '0') return 'N/A';

    if (text.toLowerCase().contains('year')) {
      return text;
    }

    return '$text years';
  }

  String _formatWeight(dynamic value) {
    final text = _safeText(value);

    if (text == 'N/A' || text == '0') return 'N/A';

    if (text.toLowerCase().contains('kg')) {
      return text;
    }

    return '$text kg';
  }

  String _formatGender(String? value) {
    final text = _safeText(value);

    if (text == 'N/A') return text;

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final String petNameText = _safeText(
      petName,
      defaultValue: 'Pet Name',
    );

    final String petTypeText = _safeText(
      petType,
      defaultValue: 'Pet',
    );

    final String breedText = _safeText(
      petBreed,
      defaultValue: 'Unknown breed',
    );

    final String reasonText = _safeText(
      reason,
      defaultValue: 'No reason provided',
    );

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE8EAEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: petImage != null && petImage!.trim().isNotEmpty
                    ? Image.network(
                  petImage!,
                  width: 86.r,
                  height: 86.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const PetImageFallback(),
                )
                    : const PetImageFallback(),
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      petNameText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF001533),
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Text(
                      '$petTypeText • $breedText',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF526174),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    _ViewPetProfileButton(
                      onTap: onPetProfileTap,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 22.h),
          InfoLine(
            icon: Icons.person_outline_rounded,
            title: 'Owner',
            value: ownerName.trim().isEmpty ? 'Owner' : ownerName,
          ),

          SizedBox(height: 16.h),

          InfoLine(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: ownerPhone == null || ownerPhone!.trim().isEmpty
                ? 'Not available'
                : ownerPhone!,
          ),

          SizedBox(height: 16.h),

          InfoLine(
            icon: Icons.calendar_month_outlined,
            title: 'Appointment',
            value: appointmentDate,
          ),

          SizedBox(height: 16.h),

          InfoLine(
            icon: Icons.description_outlined,
            title: 'Reason',
            value: reasonText,
          ),
        ],
      ),
    );
  }
}

class _ViewPetProfileButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ViewPetProfileButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return Material(
      color: isDisabled
          ? Colors.grey.withOpacity(0.10)
          : AppColors.primary.withOpacity(0.09),
      borderRadius: BorderRadius.circular(30.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 7.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: isDisabled
                  ? Colors.grey.withOpacity(0.16)
                  : AppColors.primary.withOpacity(0.14),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pets_rounded,
                color: isDisabled ? Colors.grey : AppColors.primary,
                size: 15.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'View Pet Profile',
                style: TextStyle(
                  color: isDisabled ? Colors.grey : AppColors.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward_rounded,
                color: isDisabled ? Colors.grey : AppColors.primary,
                size: 15.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PetImageFallback extends StatelessWidget {
  const PetImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86.r,
      height: 86.r,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        Icons.pets_rounded,
        color: AppColors.primary,
        size: 34.sp,
      ),
    );
  }
}