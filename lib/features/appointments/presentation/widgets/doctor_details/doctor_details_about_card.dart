import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_details/doctor_details_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsAboutCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailsAboutCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final String about = doctor.about ??
        "Experienced veterinarian providing trusted medical care, diagnosis, and treatment for pets.";

    return DoctorDetailsSectionCard(
      icon: Icons.auto_awesome_rounded,
      title: "About Doctor",
      child: Text(
        about,
        style: TextStyle(
          color: const Color(0xFF526260),
          fontSize: 14.sp,
          height: 1.65,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
