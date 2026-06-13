import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aleef/features/doctor/home/data/models/End_Appointment_Request_Model.dart';
import 'package:aleef/features/doctor/home/presentation/manager/appointment_management_provider.dart';
import 'package:aleef/features/doctor/home/data/models/confirmed_appointment_model.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/medical_record_form_widget.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/pet_info_box.dart';

class AppointmentManagementScreen extends StatefulWidget {
  final ConfirmedAppointmentModel appointment;

  const AppointmentManagementScreen({super.key, required this.appointment});

  @override
  State<AppointmentManagementScreen> createState() =>
      _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState
    extends State<AppointmentManagementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _conditionController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointment Management")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // التعديل هنا: تمرير widget.appointment.pet بدلاً من الـ appointment بالكامل
            PetInfoBox(pet: widget.appointment.pet),

            SizedBox(height: 16.h),
            MedicalRecordFormWidget(
              titleController: _titleController,
              conditionController: _conditionController,
              descController: _descController,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<AppointmentManagementProvider>().endAppointment(
                  appointmentId: widget.appointment.id,
                  requestModel: EndAppointmentRequestModel(
                    medicalRecord: MedicalRecordModel(
                      title: _titleController.text,
                      condition: _conditionController.text,
                      description: _descController.text,
                    ),
                  ),
                );
              },
              child: const Text('Complete Appointment'),
            ),
            SizedBox(height: 12.h),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              child: Text(
                'Cancel Appointment',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
