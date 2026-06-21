import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/labeled_field.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingVaccinationCard extends StatelessWidget {
  final TextEditingController vaccineNameController;
  final TextEditingController nextDueDateController;

  const UpcomingVaccinationCard({
    super.key,
    required this.vaccineNameController,
    required this.nextDueDateController,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final month = pickedDate.month.toString().padLeft(2, '0');
    final day = pickedDate.day.toString().padLeft(2, '0');

    nextDueDateController.text = '${pickedDate.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFFFDDAA),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFDDAA).withOpacity(0.25),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Upcoming Vaccination',
            icon: Icons.event_available_outlined,
          ),
          SizedBox(height: 18.h),

          LabeledField(
            label: 'Vaccine Name',
            hint: 'e.g., Booster Vaccine',
            controller: vaccineNameController,
          ),

          SizedBox(height: 16.h),

          GestureDetector(
            onTap: () => _pickDate(context),
            child: AbsorbPointer(
              child: LabeledField(
                label: 'Next Due Date',
                hint: 'Select next vaccination date',
                controller: nextDueDateController,
                prefixIcon: Icons.calendar_month_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}