import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/doctor_model.dart';
import 'doctor_action_buttons.dart';
import 'doctor_arrow_button.dart';
import 'doctor_image_with_rate.dart';
import 'doctor_info_line.dart';
import 'doctor_location_strip.dart';
import 'doctor_specialization_pill.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback? onTap;
  final VoidCallback? onTapDetails;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = doctor.profilePic ?? '';
    final name = doctor.name ?? 'Doctor';
    final specialization = doctor.specialization ?? 'Veterinary';
    final city = doctor.city ?? doctor.address ?? 'Clinic location';
    final rating = _cleanText(doctor.rating, fallback: '0.0');

    final ratingsCount = doctor.ratingsCount?.toStringAsFixed(0) ??
        doctor.reviewsCount?.toString() ??
        '0';

    final distanceKm = _formatDistance(doctor.distanceKm);
    final minutes = doctor.minutes;

    final hasDistance = distanceKm != null;
    final hasMinutes = minutes != null;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: const Color(0xFFEAF0F0),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapDetails,
          borderRadius: BorderRadius.circular(26.r),
          child: Padding(
            padding: EdgeInsets.all(13.r),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorImageWithRate(
                      imageUrl: imageUrl,
                      rating: rating,
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF17212B),
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              DoctorArrowButton(onTap: onTapDetails),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          DoctorSpecializationPill(
                            text: specialization,
                          ),
                          SizedBox(height: 10.h),
                          DoctorInfoLine(
                            icon: Icons.location_on_rounded,
                            value: city,
                          ),
                          SizedBox(height: 7.h),
                          DoctorInfoLine(
                            icon: Icons.chat_bubble_outline_rounded,
                            value: '$ratingsCount reviews',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (hasDistance || hasMinutes) ...[
                  SizedBox(height: 13.h),
                  DoctorLocationStrip(
                    distanceKm: distanceKm,
                    minutes: minutes,
                  ),
                ],

                SizedBox(height: 13.h),

                DoctorActionButtons(
                  onDetailsTap: onTapDetails,
                  onBookTap: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _cleanText(String? value, {required String fallback}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty || text == 'null') return fallback;
    return text;
  }

  static String? _formatDistance(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty || text == 'null') return null;

    final number = double.tryParse(text);

    if (number == null) return text;

    if (number >= 10) {
      return number.toStringAsFixed(0);
    }

    return number.toStringAsFixed(1);
  }
}