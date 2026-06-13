import 'package:aleef/features/doctor/home/data/models/doctor_profile_model.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_schedule_day_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class DoctorEditScheduleScreen extends StatefulWidget {
  const DoctorEditScheduleScreen({super.key});

  @override
  State<DoctorEditScheduleScreen> createState() =>
      _DoctorEditScheduleScreenState();
}

class _DoctorEditScheduleScreenState extends State<DoctorEditScheduleScreen> {
  final List<String> _weekDays = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  Map<String, ScheduleItem> _currentScheduleMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DoctorProfileProvider>(
        context,
        listen: false,
      );
      provider.fetchDoctorSchedule().then((_) {
        _initializeScheduleState(provider.doctorSchedule);
      });
    });
  }

  void _initializeScheduleState(List<ScheduleItem> backendSchedule) {
    final Map<String, ScheduleItem> tempMap = {};
    for (var day in _weekDays) {
      final existingItem = backendSchedule.firstWhere(
        (item) => item.dayOfWeek.toLowerCase() == day,
        orElse: () => ScheduleItem(
          dayOfWeek: day,
          startTime: '09:00:00',
          endTime: '17:00:00',
          isAvailable: false,
        ),
      );
      tempMap[day] = existingItem;
    }
    setState(() {
      _currentScheduleMap = tempMap;
    });
  }

  void _updateDaySchedule(String day, ScheduleItem updatedItem) {
    setState(() {
      _currentScheduleMap[day] = updatedItem;
    });
  }

  void _saveSchedule() async {
    final provider = Provider.of<DoctorProfileProvider>(context, listen: false);
    final listToSend = _currentScheduleMap.values.toList();

    final success = await provider.updateDoctorSchedule(listToSend);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schedule updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to update schedule'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DoctorProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Edit Schedule',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: provider.isLoading && _currentScheduleMap.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.primary,
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                  child: Text(
                    "Set your weekly availability. Toggle each day and specify your working hours.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount: _weekDays.length,
                    itemBuilder: (context, index) {
                      final day = _weekDays[index];
                      final item =
                          _currentScheduleMap[day] ??
                          ScheduleItem(
                            dayOfWeek: day,
                            startTime: '09:00:00',
                            endTime: '17:00:00',
                            isAvailable: false,
                          );

                      return DoctorScheduleDayCard(
                        day: day,
                        item: item,
                        onChanged: (updatedItem) =>
                            _updateDaySchedule(day, updatedItem),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: provider.isUpdating ? null : _saveSchedule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: provider.isUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
