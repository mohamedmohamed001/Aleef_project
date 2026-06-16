import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/review_model.dart';
import 'clinic_location_card.dart';
import 'doctor_info_container.dart';
import 'doctor_section_title.dart';
import 'review_card.dart';

class DoctorDetailsBody extends StatefulWidget {
  final DoctorModel doctor;
  final List<ReviewModel> reviews;

  const DoctorDetailsBody({
    super.key,
    required this.doctor,
    required this.reviews,
  });

  @override
  State<DoctorDetailsBody> createState() => _DoctorDetailsBodyState();
}

class _DoctorDetailsBodyState extends State<DoctorDetailsBody> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String about = widget.doctor.about?.trim() ?? "";
    final bool hasAbout = about.isNotEmpty;
    final bool hasReviews = widget.reviews.isNotEmpty;
    final bool isLongText = about.length > 120;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

          const DoctorSectionTitle(title: "About"),
          SizedBox(height: 12.h),

          DoctorInfoContainer(
            child: hasAbout
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  about,
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                if (isLongText) ...[
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        isExpanded ? "See less" : "See more",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.teal,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            )
                : Text(
              "No information provided yet.",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 24.h),

          const DoctorSectionTitle(title: "Clinic Location"),
          SizedBox(height: 12.h),

          ClinicLocationCard(doctor: widget.doctor),

          SizedBox(height: 24.h),

          const DoctorSectionTitle(title: "Reviews"),
          SizedBox(height: 12.h),

          if (hasReviews)
            ListView.separated(
              itemCount: widget.reviews.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final review = widget.reviews[index];
                return ReviewCard(review: review);
              },
            )
          else
            DoctorInfoContainer(
              child: Text(
                "No reviews yet.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}