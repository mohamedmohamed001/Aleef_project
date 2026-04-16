import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../services/appointment_api.dart';
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
  AppointmentModel appointment = AppointmentModel();

  // void initState() {
  //   super.initState();
  //   fetchCurrentAppointment();
  // }

  Future<void> fetchCurrentAppointment() async {
    final response = await AppointmentApi().getActiveAppointment();
    if (!mounted) return;
    if (response["status"] == "success") {
      setState(() {
        appointment = AppointmentModel.fromJson(response["data"]);
      });
    } else if (response["status"] == "unauthorized") {
      SecureStorageService().deleteToken();
      SecureStorageService().deleteUser();

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

@override
  void didChangeDependencies() {
    fetchCurrentAppointment();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return fetchCurrentAppointment();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const AppointmentsHeader(),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: appointment.doctor?.name != null
                      ? AppointmentCard(
                          doctorName: appointment.doctor?.name ?? "",
                          specialty: appointment.doctor?.specialization ?? "",
                          date: appointment.date != null
                              ? "${appointment.date!.day}/${appointment.date!.month}/${appointment.date!.year}"
                              : "",
                          time: appointment.time ?? "",
                          petName: appointment.pet?.name ?? "",
                          petType: appointment.pet?.type ?? "",
                          status: appointment.status ?? "",
                          imagePath: appointment.doctor?.profilePic ?? "",
                          onViewDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppointmentDetails(
                                  appointmentId: appointment.id!,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ),
                appointment.doctor?.name != null
                    ? SizedBox(height: 24.h)
                    : Container(),
                const AvailableDoctorsSection(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
