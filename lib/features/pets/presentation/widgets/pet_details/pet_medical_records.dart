import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../medical_records/presentation/pages/medical_record_details.dart';
import '../../../data/models/pet_model.dart';

class PetMedicalRecords extends StatelessWidget {
  final List<MedicalRecord> records;
  final List<Vaccination> upcomingVaccinations;
  final List<Vaccination> overdueVaccinations;
  final List<Vaccination> completedVaccinations;
  final bool readOnly;

  const PetMedicalRecords({
    super.key,
    required this.records,
    required this.upcomingVaccinations,
    required this.overdueVaccinations,
    required this.completedVaccinations,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalVaccinations = upcomingVaccinations.length +
        overdueVaccinations.length +
        completedVaccinations.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: "Medical Records",
          subtitle: "${records.length} record${records.length == 1 ? '' : 's'}",
          icon: Icons.medical_information_outlined,
        ),

        SizedBox(height: 14.h),

        if (records.isEmpty)
          const _EmptyState(
            icon: Icons.folder_open_rounded,
            title: "No medical records yet",
            subtitle: "Your pet medical history will appear here.",
          )
        else
          ...records.map(
                (record) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MedicalRecordDetailsScreen(
                        recordId: record.id,
                        readOnly: readOnly,
                      ),
                    ),
                  );
                },
                child: _MedicalRecordCard(
                  title: record.title,
                  date: _formatDate(record.date),
                  condition: record.condition,
                  description: record.description,
                ),
              ),
            ),
          ),

        SizedBox(height: 26.h),

        _SectionHeader(
          title: "Vaccinations",
          subtitle:
          "$totalVaccinations vaccine${totalVaccinations == 1 ? '' : 's'}",
          icon: Icons.vaccines_rounded,
        ),

        SizedBox(height: 14.h),

        if (upcomingVaccinations.isEmpty &&
            completedVaccinations.isEmpty &&
            overdueVaccinations.isEmpty)
          const _EmptyState(
            icon: Icons.vaccines_outlined,
            title: "No vaccinations found",
            subtitle: "Vaccination updates and reminders will appear here.",
          )
        else ...[
          if (overdueVaccinations.isNotEmpty) ...[
            _MiniLabel(
              title: "Needs attention",
              color: const Color(0xFFE5484D),
              icon: Icons.warning_amber_rounded,
            ),
            SizedBox(height: 10.h),
            ...overdueVaccinations.map(
                  (vaccine) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _VaccineCard(
                  icon: Icons.warning_amber_rounded,
                  title: vaccine.vaccineName,
                  status: "Overdue",
                  takenDate: "Missed",
                  dueDate: _nullableDate(vaccine.nextDueDate),
                  color: const Color(0xFFE5484D),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],

          if (upcomingVaccinations.isNotEmpty) ...[
            _MiniLabel(
              title: "Upcoming",
              color: AppColors.primary,
              icon: Icons.event_available_rounded,
            ),
            SizedBox(height: 10.h),
            ...upcomingVaccinations.map(
                  (vaccine) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _VaccineCard(
                  icon: Icons.event_available_rounded,
                  title: vaccine.vaccineName,
                  status: "Upcoming",
                  takenDate: _nullableDate(
                    vaccine.vaccinatedAt,
                    fallback: "Pending",
                  ),
                  dueDate: _nullableDate(vaccine.nextDueDate),
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],

          if (completedVaccinations.isNotEmpty) ...[
            _MiniLabel(
              title: "Completed",
              color: const Color(0xFF19A974),
              icon: Icons.check_circle_rounded,
            ),
            SizedBox(height: 10.h),
            ...completedVaccinations.map(
                  (vaccine) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _VaccineCard(
                  icon: Icons.check_circle_rounded,
                  title: vaccine.vaccineName,
                  status: "Completed",
                  takenDate: _nullableDate(vaccine.vaccinatedAt),
                  dueDate: _nullableDate(vaccine.nextDueDate),
                  color: const Color(0xFF19A974),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  static String _formatDate(String date) {
    if (date.trim().isEmpty) return "N/A";
    return date.contains('T') ? date.split('T').first : date;
  }

  static String _nullableDate(String? date, {String fallback = "N/A"}) {
    if (date == null || date.trim().isEmpty) return fallback;
    return date.contains('T') ? date.split('T').first : date;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.title16SemiBold.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: AppTextStyles.body14Regular.copyWith(
                  fontSize: 12.sp,
                  color: const Color(0xFF7A8794),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniLabel extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _MiniLabel({
    required this.title,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15.sp),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalRecordCard extends StatelessWidget {
  final String title;
  final String date;
  final String condition;
  final String description;

  const _MedicalRecordCard({
    required this.title,
    required this.date,
    required this.condition,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final String titleText = title.trim().isEmpty ? 'Medical Record' : title;
    final String descriptionText =
    description.trim().isEmpty ? "No description provided." : description;

    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFE8EEF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.description_rounded,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titleText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label14Medium.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        date,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                if (condition.trim().isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      condition,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                if (condition.trim().isNotEmpty) SizedBox(height: 9.h),

                Text(
                  descriptionText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14Regular.copyWith(
                    fontSize: 12.sp,
                    height: 1.45,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccineCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final String takenDate;
  final String dueDate;
  final Color color;

  const _VaccineCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.takenDate,
    required this.dueDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final String titleText = title.trim().isEmpty ? 'Vaccination' : title;

    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  titleText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label14Medium.copyWith(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 9.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: _DateInfoBox(
                  label: "Date Taken",
                  value: takenDate,
                  icon: Icons.event_note_rounded,
                  color: const Color(0xFF6B7280),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _DateInfoBox(
                  label: "Next Due",
                  value: dueDate,
                  icon: Icons.calendar_month_rounded,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateInfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DateInfoBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: const Color(0xFFE8EEF0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16.sp,
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFE8EEF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 58.r,
            height: 58.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 29.sp,
            ),
          ),
          SizedBox(height: 13.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.title16SemiBold.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.body14Regular.copyWith(
              fontSize: 12.sp,
              height: 1.35,
              color: const Color(0xFF7A8794),
            ),
          ),
        ],
      ),
    );
  }
}