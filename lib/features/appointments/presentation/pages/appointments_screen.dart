import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../providers/bottom_nav_provider.dart';
import '../../services/appointment_api.dart';
import '../widgets/appointment_screen_skeleton.dart';
import '../widgets/appointments_header.dart';
import '../widgets/appointment_card.dart';
import '../widgets/available_doctors/available_doctors_section.dart';
import 'appointment_details.dart';

class AppointmentTab extends StatefulWidget {
  const AppointmentTab({super.key});

  @override
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  bool isPageLoading = true;

  AppointmentModel appointment = AppointmentModel();
  List<DoctorModel> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchAppointmentPageData();
  }

  Future<void> fetchAppointmentPageData() async {
    setState(() {
      isPageLoading = true;
    });

    try {
      final results = await Future.wait([
        AppointmentApi().getActiveAppointment(),
        AppointmentApi().getAvailableDoctor(),
      ]);

      if (!mounted) return;

      final appointmentResponse = results[0];
      final doctorsResponse = results[1];

      if (appointmentResponse["status"] == "unauthorized" ||
          doctorsResponse["status"] == "unauthorized") {
        await SecureStorageService().deleteToken();
        await SecureStorageService().deleteUser();

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
              (route) => false,
        );
        return;
      }

      final appointmentData = appointmentResponse["data"];

      final loadedAppointment =
      appointmentResponse["status"] == "success" &&
          appointmentData != null &&
          appointmentData is Map<String, dynamic> &&
          appointmentData.isNotEmpty
          ? AppointmentModel.fromJson(appointmentData)
          : AppointmentModel();

      final List doctorsData = doctorsResponse["data"] ?? [];

      final loadedDoctors = doctorsData
          .whereType<Map<String, dynamic>>()
          .map((e) => DoctorModel.fromJson(e))
          .toList();

      setState(() {
        appointment = loadedAppointment;
        doctors = loadedDoctors;
        isPageLoading = false;
      });
    } catch (e, s) {
      print("fetchAppointmentPageData error: $e");
      print("stack: $s");

      if (!mounted) return;

      setState(() {
        appointment = AppointmentModel();
        doctors = [];
        isPageLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = context.watch<BottomNavProvider>();

    if (provider.shouldRefreshAppointments) {
      fetchAppointmentPageData();
      provider.doneRefresh();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";

    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: isPageLoading
            ? const AppointmentTabSkeleton()
            : RefreshIndicator(
          onRefresh: fetchAppointmentPageData,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              children: [
                AppointmentsHeader(
                  onPreviousTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.previousAppointmentScreen,
                    );
                  },
                ),
                SizedBox(height: 16.h),

                if (appointment.doctor?.name != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AppointmentCard(
                      doctorName: appointment.doctor?.name ?? "",
                      specialty:
                      appointment.doctor?.specialization ?? "",
                      date: _formatDate(appointment.date),
                      time: appointment.time ?? "",
                      petName: appointment.pet?.name ?? "",
                      petType: appointment.pet?.type ?? "",
                      status: appointment.status ?? "",
                      imagePath:
                      appointment.doctor?.profilePic ?? "",
                      onViewDetails: () {
                        if (appointment.id == null) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentDetails(
                              appointmentId: appointment.id!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                if (appointment.doctor?.name != null)
                  SizedBox(height: 24.h),

                AvailableDoctorsSection(
                  doctors: doctors,
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}