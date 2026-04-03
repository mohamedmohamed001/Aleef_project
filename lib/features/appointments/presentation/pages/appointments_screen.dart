import 'package:flutter/material.dart';
import '../widgets/appointments_header.dart';
import '../widgets/appointment_card.dart';

class AppointmentTab extends StatelessWidget {
  const AppointmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppointmentsHeader(),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}