import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/pet_model.dart';

class PetMedicalRecords extends StatelessWidget {
  final List<MedicalRecord> records;
  final List<Vaccination> upcomingVaccinations;
  final List<Vaccination> overdueVaccinations;
  final List<Vaccination> completedVaccinations;

  const PetMedicalRecords({
    super.key,
    required this.records,
    required this.upcomingVaccinations,
    required this.overdueVaccinations,
    required this.completedVaccinations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Medical Records", style: AppTextStyles.title16SemiBold),
        SizedBox(height: 15.h),
        if (records.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              "No medical records found.",
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          ...records.map(
            (record) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildDetailedMedicalCard(
                icon: Icons.calendar_today_outlined,
                title: record.title,
                date: record.date.contains('T')
                    ? record.date.split('T').first
                    : record.date,
                doctor: record.condition,
                description: record.description,
              ),
            ),
          ),
        SizedBox(height: 25.h),
        Text("Vaccinations", style: AppTextStyles.title16SemiBold),
        SizedBox(height: 15.h),
        if (upcomingVaccinations.isEmpty &&
            completedVaccinations.isEmpty &&
            overdueVaccinations.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              "No vaccinations found.",
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else ...[
          ...completedVaccinations.map(
            (vaccine) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildVaccineCard(
                Icons.check_circle_outline,
                vaccine.vaccineName,
                vaccine.vaccinatedAt != null && vaccine.vaccinatedAt!.isNotEmpty
                    ? (vaccine.vaccinatedAt!.contains('T')
                        ? vaccine.vaccinatedAt!.split('T').first
                        : vaccine.vaccinatedAt!)
                    : "N/A",
                vaccine.nextDueDate != null && vaccine.nextDueDate!.isNotEmpty
                    ? (vaccine.nextDueDate!.contains('T')
                        ? vaccine.nextDueDate!.split('T').first
                        : vaccine.nextDueDate!)
                    : "N/A",
                Colors.green,
              ),
            ),
          ),
          ...upcomingVaccinations.map(
            (vaccine) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildVaccineCard(
                Icons.calendar_today_outlined,
                "${vaccine.vaccineName} (Upcoming)",
                vaccine.vaccinatedAt != null && vaccine.vaccinatedAt!.isNotEmpty
                    ? (vaccine.vaccinatedAt!.contains('T')
                        ? vaccine.vaccinatedAt!.split('T').first
                        : vaccine.vaccinatedAt!)
                    : "Pending",
                vaccine.nextDueDate != null && vaccine.nextDueDate!.isNotEmpty
                    ? (vaccine.nextDueDate!.contains('T')
                        ? vaccine.nextDueDate!.split('T').first
                        : vaccine.nextDueDate!)
                    : "N/A",
                AppColors.primary,
              ),
            ),
          ),
          ...overdueVaccinations.map(
            (vaccine) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildVaccineCard(
                Icons.warning_amber_outlined,
                "${vaccine.vaccineName} (Overdue)",
                "Missed",
                vaccine.nextDueDate != null && vaccine.nextDueDate!.isNotEmpty
                    ? (vaccine.nextDueDate!.contains('T')
                        ? vaccine.nextDueDate!.split('T').first
                        : vaccine.nextDueDate!)
                    : "N/A",
                Colors.redAccent,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailedMedicalCard({
    required IconData icon,
    required String title,
    required String date,
    required String doctor,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(title, style: AppTextStyles.label14Medium),
                ],
              ),
              Text(
                date,
                style: AppTextStyles.body14Regular.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            doctor,
            style: AppTextStyles.body14Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: AppTextStyles.body14Regular.copyWith(
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineCard(
    IconData icon,
    String title,
    String takenDate,
    String dueDate,
    Color iconColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.label14Medium),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date Taken",
                            style: AppTextStyles.body14Regular.copyWith(
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            takenDate,
                            style: AppTextStyles.body14Regular.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Next Due",
                            style: AppTextStyles.body14Regular.copyWith(
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            dueDate,
                            style: AppTextStyles.body14Regular.copyWith(
                              fontSize: 12.sp,
                              color: iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}