import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_confirmed_appointments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/confirmed_appointment_card.dart';

class ConfirmedAppointmentsScreen extends StatefulWidget {
  const ConfirmedAppointmentsScreen({super.key});

  @override
  State<ConfirmedAppointmentsScreen> createState() =>
      _ConfirmedAppointmentsScreenState();
}

class _ConfirmedAppointmentsScreenState
    extends State<ConfirmedAppointmentsScreen> {
  final List<_DateFilterItem> _filters = [];
  String _selectedValue = 'All Appointments';

  @override
  void initState() {
    super.initState();

    _buildDateFilters();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<DoctorConfirmedAppointmentsProvider>()
          .getAppointmentsByDate(_selectedValue);
    });
  }

  void _buildDateFilters() {
    _filters.add(
      const _DateFilterItem(
        value: 'All Appointments',
        title: 'All',
        subtitle: 'Appointments',
      ),
    );

    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().add(Duration(days: i));

      _filters.add(
        _DateFilterItem(
          value: DateFormat('dd-MM-yyyy').format(date),
          title: _getDayTitle(date, i),
          subtitle: DateFormat('dd MMM').format(date),
        ),
      );
    }
  }

  String _getDayTitle(DateTime date, int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';
    return DateFormat('EEE').format(date);
  }

  void _onFilterSelected(String value) {
    if (_selectedValue == value) return;

    setState(() {
      _selectedValue = value;
    });

    context
        .read<DoctorConfirmedAppointmentsProvider>()
        .getAppointmentsByDate(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      body: Column(
        children: [
          _Header(
            selectedValue: _selectedValue,
            filters: _filters,
            onFilterSelected: _onFilterSelected,
          ),
          Expanded(
            child: Consumer<DoctorConfirmedAppointmentsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.appointments.isEmpty) {
                  return const _EmptyAppointmentsView();
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                  itemCount: provider.appointments.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return ConfirmedAppointmentCard(
                      appointment: provider.appointments[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String selectedValue;
  final List<_DateFilterItem> filters;
  final ValueChanged<String> onFilterSelected;

  const _Header({
    required this.selectedValue,
    required this.filters,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 18.h,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Consumer<DoctorConfirmedAppointmentsProvider>(
              builder: (context, provider, _) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirmed Appointments',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            'Manage your upcoming confirmed visits',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.72),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_available_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '${provider.appointments.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 18.h),

          /// Date filters
          SizedBox(
            height: 72.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: filters.length,
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final item = filters[index];
                final isSelected = selectedValue == item.value;

                return _DateFilterChip(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onFilterSelected(item.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DateFilterChip extends StatelessWidget {
  final _DateFilterItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateFilterChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAll = item.value == 'All Appointments';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: isAll ? 112.w : 92.w,
      height: 62.h,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.22),
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 7.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.72)
                            : Colors.white.withOpacity(0.76),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyAppointmentsView extends StatelessWidget {
  const _EmptyAppointmentsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86.w,
              height: 86.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'No appointments yet',
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Confirmed appointments will appear here once available.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF7B8794),
                fontSize: 13.sp,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateFilterItem {
  final String value;
  final String title;
  final String subtitle;

  const _DateFilterItem({
    required this.value,
    required this.title,
    required this.subtitle,
  });
}