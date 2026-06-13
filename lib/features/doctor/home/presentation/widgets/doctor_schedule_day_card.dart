import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/data/models/doctor_profile_model.dart';

class DoctorScheduleDayCard extends StatelessWidget {
  final String day;
  final ScheduleItem item;
  final Function(ScheduleItem) onChanged;

  const DoctorScheduleDayCard({
    super.key,
    required this.day,
    required this.item,
    required this.onChanged,
  });

  String _formatTimeToDisplay(String timeStr) {
    try {
      if (timeStr.isEmpty) return '09:00 AM';
      final parts = timeStr.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return '09:00 AM';
    }
  }

  String _formatTimeToBackend(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final currentTimeStr = isStartTime ? item.startTime : item.endTime;
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);

    try {
      final parts = currentTimeStr.split(':');
      initialTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (_) {}

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final backendTimeStr = _formatTimeToBackend(picked);
      onChanged(
        ScheduleItem(
          id: item.id,
          dayOfWeek: item.dayOfWeek,
          startTime: isStartTime ? backendTimeStr : item.startTime,
          endTime: isStartTime ? item.endTime : backendTimeStr,
          isAvailable: item.isAvailable,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final capitalizeDay = day[0].toUpperCase() + day.substring(1);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: item.isAvailable
                            ? AppColors.primary
                            : Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      capitalizeDay,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: item.isAvailable
                            ? Colors.black87
                            : Colors.grey[500],
                      ),
                    ),
                    if (item.isAvailable) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F4F1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "Available",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Switch(
                  value: item.isAvailable,
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                  onChanged: (val) {
                    onChanged(
                      ScheduleItem(
                        id: item.id,
                        dayOfWeek: item.dayOfWeek,
                        startTime: item.startTime,
                        endTime: item.endTime,
                        isAvailable: val,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (item.isAvailable) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimeInputField(
                      context: context,
                      label: "Start Time",
                      timeValue: _formatTimeToDisplay(item.startTime),
                      onTap: () => _selectTime(context, true),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildTimeInputField(
                      context: context,
                      label: "End Time",
                      timeValue: _formatTimeToDisplay(item.endTime),
                      onTap: () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeInputField({
    required BuildContext context,
    required String label,
    required String timeValue,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 14.sp, color: Colors.grey[500]),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeValue,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16.sp,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
