import 'dart:async';

import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/doctor_model.dart';
import '../../data/models/review_model.dart';
import '../../services/appointment_api.dart';
import '../widgets/available_doctors/doctor_details_body.dart';
import '../widgets/available_doctors/doctor_details_header.dart';
import '../widgets/available_doctors/doctor_info_card.dart';
import 'book_appointment_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  DoctorModel doctor = DoctorModel();
  bool isLoading = true;
  List<ReviewModel> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    final response = await AppointmentApi().getDoctorDetails(widget.doctorId);
    if (!mounted) return;
    if (response["status"] == "success") {
      setState(() {
        doctor = DoctorModel.fromJson(response["doctor"]);
        reviews = (response["reviews"] as List)
            .map((e) => ReviewModel.fromJson(e))
            .toList();
        isLoading = false;
      });
    } else if (response["status"] == "unauthorized") {
      setState(() {
        isLoading = false;
      });
      SecureStorageService().deleteToken();
      SecureStorageService().deleteUser();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookAppointmentScreen(doctorId: widget.doctorId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              "Book Appointment",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          DoctorDetailsHeader(doctor: doctor),
                          DoctorInfoCard(doctor: doctor),
                        ],
                      ),
                      SizedBox(height: 95.h),
                      DoctorDetailsBody(doctor: doctor, reviews: reviews),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),

                /// back button ثابت فوق الشمال حتى لو الأب عربي RTL
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12.h,
                  left: 16.w,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100.r),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.22),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                              width: 1.w,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
