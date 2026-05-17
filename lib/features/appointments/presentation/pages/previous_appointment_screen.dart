import 'package:aleef/features/appointments/presentation/widgets/Previous_appointment_card.dart';
import 'package:aleef/features/appointments/presentation/widgets/previous_appointment_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/appointment_provider.dart';

class PreviousAppointmentScreen extends StatefulWidget {
  const PreviousAppointmentScreen({super.key});

  @override
  State<PreviousAppointmentScreen> createState() =>
      _PreviousAppointmentScreenState();
}

class _PreviousAppointmentScreenState extends State<PreviousAppointmentScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AppointmentProvider>().getPreviousAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Previous Appointments")),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          if (provider.isPreviousAppointmentsLoading) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              itemCount: 6,
              itemBuilder: (context, index) {
                return const PreviousAppointmentSkeleton();
              },
            );
          }

          if (provider.previousAppointments.isEmpty) {
            return const Center(child: Text("No previous appointments"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            itemCount: provider.previousAppointments.length,
            itemBuilder: (context, index) {
              final appointment = provider.previousAppointments[index];

              return PreviousAppointmentCard(appointment: appointment);
            },
          );
        },
      ),
    );
  }
}
