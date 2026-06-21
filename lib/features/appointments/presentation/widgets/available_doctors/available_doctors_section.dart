import 'package:aleef/features/appointments/presentation/pages/book_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/doctor_model.dart';
import '../../pages/doctor_details_screen.dart';
import '../location/enable_location_card.dart';
import 'doctor_card.dart';
import 'doctor_search_field.dart';

class AvailableDoctorsSection extends StatelessWidget {
  final List<DoctorModel> doctors;
  final bool isLoadingMore;
  final void Function(String search) onSearchChanged;
  final bool isLoading;

  final bool hasLocation;
  final bool isLocationLoading;
  final VoidCallback onEnableLocationTap;

  const AvailableDoctorsSection({
    super.key,
    required this.doctors,
    required this.onSearchChanged,
    required this.isLoading,
    required this.hasLocation,
    required this.isLocationLoading,
    required this.onEnableLocationTap,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Available Doctors",
                    style: TextStyle(
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF101828),
                    ),
                  ),
                ),
                if (!isLoading)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF7F6),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "${doctors.length} found",
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF267D77),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: DoctorSearchField(
              onChanged: onSearchChanged,
            ),
          ),

          if (!hasLocation) SizedBox(height: 12.h),

          if (!hasLocation)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: EnableLocationCard(
                isLoading: isLocationLoading,
                onTap: onEnableLocationTap,
              ),
            ),

          SizedBox(height: 16.h),

          if (isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (doctors.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 28.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFA),
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: const Color(0xFFE6EEEE),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 54.r,
                      height: 54.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF7F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: const Color(0xFF267D77),
                        size: 27.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "No doctors available",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101828),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Try changing your search keyword",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView.separated(
                itemCount: doctors.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, _) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final doctor = doctors[index];

                  return DoctorCard(
                    doctor: doctor,
                    onTapDetails: () {
                      if (doctor.id == null) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorDetailsScreen(
                            doctorId: doctor.id!,
                          ),
                        ),
                      );
                    },
                    onTap: () {
                      if (doctor.id == null) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookAppointmentScreen(
                            doctorId: doctor.id!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          if (isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}