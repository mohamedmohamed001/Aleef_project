import 'package:aleef/features/doctor/home/data/models/doctor_profile_model.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_schedule_day_card.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/edit_schedule/doctor_edit_schedule_header.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/edit_schedule/doctor_edit_schedule_save_bar.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/edit_schedule/doctor_edit_schedule_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/widgets/app_snack_bar.dart';

class DoctorEditScheduleScreen extends StatefulWidget {
  const DoctorEditScheduleScreen({super.key});

  @override
  State<DoctorEditScheduleScreen> createState() =>
      _DoctorEditScheduleScreenState();
}

class _DoctorEditScheduleScreenState extends State<DoctorEditScheduleScreen> {
  final List<String> _weekDays = const [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  Map<String, ScheduleItem> _currentScheduleMap = {};

  int get _availableDaysCount {
    return _currentScheduleMap.values
        .where((item) => item.isAvailable)
        .length;
  }

  bool get _hasScheduleData => _currentScheduleMap.isNotEmpty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final provider = context.read<DoctorProfileProvider>();

      await provider.fetchDoctorSchedule();

      if (!mounted) return;

      _initializeScheduleState(provider.doctorSchedule);
    });
  }

  void _initializeScheduleState(List<ScheduleItem> backendSchedule) {
    final Map<String, ScheduleItem> tempMap = {};

    for (final day in _weekDays) {
      final existingItem = backendSchedule.firstWhere(
            (item) => item.dayOfWeek.toLowerCase() == day,
        orElse: () => _defaultScheduleItem(day),
      );

      tempMap[day] = existingItem;
    }

    setState(() {
      _currentScheduleMap = tempMap;
    });
  }

  ScheduleItem _defaultScheduleItem(String day) {
    return ScheduleItem(
      dayOfWeek: day,
      startTime: '09:00:00',
      endTime: '17:00:00',
      isAvailable: false,
    );
  }

  void _updateDaySchedule(String day, ScheduleItem updatedItem) {
    setState(() {
      _currentScheduleMap[day] = updatedItem;
    });
  }

  Future<void> _saveSchedule() async {
    if (!_hasScheduleData) return;

    final provider = context.read<DoctorProfileProvider>();
    final listToSend = _currentScheduleMap.values.toList();

    final success = await provider.updateDoctorSchedule(listToSend);

    if (!mounted) return;

    if (success) {
      AppSnackBar.show(
        context,
        message: 'Schedule updated successfully',
        type: AppSnackBarType.success,
      );

      Navigator.pop(context, true);
      return;
    }

    AppSnackBar.show(
      context,
      message: provider.errorMessage ?? 'Failed to update schedule',
      type: AppSnackBarType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoctorProfileProvider>();

    final isInitialLoading = provider.isLoading && !_hasScheduleData;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: Column(
        children: [
          DoctorEditScheduleHeader(
            availableDaysCount: isInitialLoading ? 0 : _availableDaysCount,
            totalDaysCount: _weekDays.length,
            onBackTap: () => Navigator.pop(context, false),
          ),

          Expanded(
            child: isInitialLoading
                ? const _DoctorEditScheduleSkeleton()
                : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
              children: [
                DoctorEditScheduleSummaryCard(
                  availableDaysCount: _availableDaysCount,
                  totalDaysCount: _weekDays.length,
                ),

                SizedBox(height: 14.h),

                ..._weekDays.map((day) {
                  final item =
                      _currentScheduleMap[day] ?? _defaultScheduleItem(day);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: DoctorScheduleDayCard(
                      day: day,
                      item: item,
                      onChanged: (updatedItem) {
                        _updateDaySchedule(day, updatedItem);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          if (!isInitialLoading)
            DoctorEditScheduleSaveBar(
              isLoading: provider.isUpdating,
              onTap: _saveSchedule,
            ),
        ],
      ),
    );
  }
}

class _DoctorEditScheduleSkeleton extends StatelessWidget {
  const _DoctorEditScheduleSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      children: [
        _shimmer(
          child: _summarySkeleton(),
        ),

        SizedBox(height: 14.h),

        ...List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _shimmer(
              child: _dayCardSkeleton(),
            ),
          );
        }),
      ],
    );
  }

  Widget _summarySkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          _box(
            width: 48.w,
            height: 48.w,
            radius: 16.r,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(
                  height: 16.h,
                  width: 160.w,
                  radius: 8.r,
                ),
                SizedBox(height: 9.h),
                _box(
                  height: 12.h,
                  width: 220.w,
                  radius: 8.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayCardSkeleton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _box(
                width: 42.w,
                height: 42.w,
                radius: 14.r,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(
                      height: 15.h,
                      width: 110.w,
                      radius: 8.r,
                    ),
                    SizedBox(height: 8.h),
                    _box(
                      height: 11.h,
                      width: 170.w,
                      radius: 8.r,
                    ),
                  ],
                ),
              ),
              _box(
                width: 44.w,
                height: 26.h,
                radius: 20.r,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: _box(
                  height: 46.h,
                  radius: 16.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _box(
                  height: 46.h,
                  radius: 16.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }

  Widget _box({
    required double height,
    double? width,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}