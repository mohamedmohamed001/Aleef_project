import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../services/appointment_api.dart';
import '../widgets/appointments_header.dart';
import '../widgets/appointment_card.dart';
import '../widgets/available_doctors/available_doctors_section.dart';

class AppointmentTab extends StatefulWidget {
  const AppointmentTab({super.key});

  @override
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final response = await AppointmentApi().getAvailableDoctor();

    if (response == 200) {
      debugPrint("Success");
    } else if (response == 401) {
      SecureStorageService().deleteUser();
      SecureStorageService().deleteToken();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } else {
      debugPrint("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const AppointmentsHeader(),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AppointmentCard(
                  doctorName: "Dr. Amira Hassan",
                  specialty: "General Veterinarian",
                  date: "March 10, 2026",
                  time: "10:00 AM",
                  petName: "Max",
                  petType: "Dog",
                  status: "Confirmed",
                  onViewDetails: () {},
                ),
              ),
              SizedBox(height: 24.h),
              const AvailableDoctorsSection(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
