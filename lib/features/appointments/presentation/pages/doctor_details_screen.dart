import 'package:aleef/features/appointments/presentation/pages/book_appointment_screen.dart';
import 'package:aleef/features/appointments/presentation/provider/appointment_provider.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_about_card.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_back_button.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_blur_header.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_book_bar.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_clinic_card.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_loading_view.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_profile_card.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_quick_info_row.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_reviews_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late AppointmentProvider _appointmentProvider;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AppointmentProvider>().getDoctorDetails(widget.doctorId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appointmentProvider = context.read<AppointmentProvider>();
  }

  @override
  void dispose() {
    _appointmentProvider.clearDoctorDetails();
    super.dispose();
  }

  void _openBookAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookAppointmentScreen(
          doctorId: widget.doctorId,
        ),
      ),
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, _) {
        final doctor = provider.doctorDetails;
        final reviews = provider.doctorReviews;
        final isLoading = provider.isDoctorDetailsLoading;

        if (isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF4F7F8),
            body: DoctorDetailsLoadingView(),
          );
        }

        if (doctor.id == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F7F8),
            body: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 72.r,
                          height: 72.r,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF0F0),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Icon(
                            Icons.medical_services_outlined,
                            size: 34.r,
                            color: const Color(0xFF667085),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Doctor details not available',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1F2933),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Please try again later or choose another doctor.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF667085),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DoctorDetailsBackButton(
                  onTap: _goBack,
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF4F7F8),
          extendBody: true,
          bottomNavigationBar: DoctorDetailsBookBar(
            doctor: doctor,
            onBookTap: _openBookAppointment,
          ),
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 605.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          DoctorDetailsBlurHeader(doctor: doctor),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 205.h,
                            child: DoctorDetailsProfileCard(
                              doctor: doctor,
                              reviewsCount: reviews.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        DoctorDetailsQuickInfoRow(doctor: doctor),
                        SizedBox(height: 16.h),
                        DoctorDetailsAboutCard(doctor: doctor),
                        SizedBox(height: 16.h),
                        DoctorDetailsClinicCard(doctor: doctor),
                        SizedBox(height: 16.h),
                        DoctorDetailsReviewsCard(reviews: reviews),
                        SizedBox(height: 165.h),
                      ],
                    ),
                  ),
                ],
              ),
              DoctorDetailsBackButton(
                onTap: _goBack,
              ),
            ],
          ),
        );
      },
    );
  }
}