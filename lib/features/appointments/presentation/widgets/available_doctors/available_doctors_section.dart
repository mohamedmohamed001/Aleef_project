import 'package:aleef/features/appointments/services/appointment_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/routing/app_routes.dart';
import '../../../data/models/doctor_model.dart';
import '../../pages/doctor_details_screen.dart';
import 'doctor_card.dart';
import 'doctor_search_field.dart';

class AvailableDoctorsSection extends StatefulWidget {
  const AvailableDoctorsSection({super.key});

  @override
  State<AvailableDoctorsSection> createState() =>
      _AvailableDoctorsSectionState();
}

class _AvailableDoctorsSectionState extends State<AvailableDoctorsSection> {
  List<DoctorModel> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await AppointmentApi().getAvailableDoctor();

      if (!mounted) return;

      final status = response["status"].toString().trim();

      if (status == "success") {
        final List doctorsData = response["data"] ?? [];

        final loadedDoctors = doctorsData
            .whereType<Map<String, dynamic>>()
            .map((e) => DoctorModel.fromJson(e))
            .toList();

        setState(() {
          doctors = loadedDoctors;
          isLoading = false;
        });
      } else if (status == "unauthorized") {
        setState(() {
          isLoading = false;
        });

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
              (route) => false,
        );
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, s) {
      print("fetchDoctors error: $e");
      print("stack: $s");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }
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

          if (isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (doctors.isEmpty)
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
                      // TODO: navigate to schedule
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