import 'package:aleef/features/appointments/presentation/pages/book_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/doctor_model.dart';
import '../../pages/doctor_details_screen.dart';
import 'doctor_card.dart';
import 'doctor_search_field.dart';

class AvailableDoctorsSection extends StatelessWidget {
  final List<DoctorModel> doctors;

  const AvailableDoctorsSection({
    super.key,
    required this.doctors,
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
            child: const Text(
              "Available Doctors",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: DoctorSearchField(
              onChanged: (search) {},
            ),
          ),
          SizedBox(height: 16.h),

          if (doctors.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  "No doctors available",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
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
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
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
        ],
      ),
    );
  }
}