import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/labeled_field.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VaccinationCard extends StatelessWidget {
  final TextEditingController vaccineNameController;
  final TextEditingController doseController;
  final TextEditingController notesController;

  const VaccinationCard({
    super.key,
    required this.vaccineNameController,
    required this.doseController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFC8F5DB),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC8F5DB).withOpacity(0.25),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Vaccination',
            icon: Icons.vaccines_outlined,
          ),
          SizedBox(height: 18.h),

          LabeledField(
            label: 'Vaccine Name',
            hint: 'e.g., Rabies Vaccine',
            controller: vaccineNameController,
          ),

          SizedBox(height: 16.h),

          LabeledField(
            label: 'Dose',
            hint: 'e.g., 1st dose',
            controller: doseController,
          ),

          SizedBox(height: 16.h),

          LabeledField(
            label: 'Notes',
            hint: 'Any notes about this vaccination...',
            controller: notesController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}