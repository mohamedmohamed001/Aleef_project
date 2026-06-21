import 'package:aleef/core/services/socket_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/chat/presentation/pages/chat_tab.dart';
import 'package:aleef/features/doctor/home/presentation/pages/confirmed_appointments_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Performance/presentation/pages/doctor_performance_tab.dart';
import '../home/presentation/manager/doctor_appointment_provider.dart';
import '../home/presentation/manager/doctor_confirmed_appointments_provider.dart';
import '../home/presentation/pages/doctor_home_tab.dart';
import '../profile/presentation/pages/doctor_profile_tab.dart';

class DoctorMainLayout extends StatefulWidget {
  const DoctorMainLayout({super.key});

  @override
  State<DoctorMainLayout> createState() => _DoctorMainLayoutState();
}

class _DoctorMainLayoutState extends State<DoctorMainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    DoctorHomeTab(),
    DoctorPerformanceTab(),
    ChatTab(mode: ChatTabMode.doctor),
    ConfirmedAppointmentsScreen(),
    DoctorProfileTab(),
  ];

  final List<_DoctorNavItem> navItems = const [
    _DoctorNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _DoctorNavItem(
      label: 'Stats',
      icon: Icons.show_chart_rounded,
      activeIcon: Icons.query_stats_rounded,
    ),
    _DoctorNavItem(
      label: 'Chats',
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
    ),
    _DoctorNavItem(
      label: 'Bookings',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_month_rounded,
    ),
    _DoctorNavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SocketService().connectCurrentSession();
    });
  }

  Future<void> _refreshHomeRequests() async {
    if (!mounted) return;

    await context.read<DoctorAppointmentsProvider>().getAppointmentRequests();
  }

  Future<void> _refreshConfirmedAppointments() async {
    if (!mounted) return;

    await context
        .read<DoctorConfirmedAppointmentsProvider>()
        .refreshCurrentAppointments();
  }

  void onTabTapped(int index) {
    if (index == 0) {
      _refreshHomeRequests();
    }

    if (index == 3) {
      _refreshConfirmedAppointments();
    }

    if (currentIndex == index) return;

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAFA),
      extendBody: false,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
          child: Container(
            height: 76.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: List.generate(
                navItems.length,
                    (index) {
                  final item = navItems[index];
                  final isSelected = currentIndex == index;

                  return Expanded(
                    child: _DoctorNavBarItem(
                      item: item,
                      isSelected: isSelected,
                      onTap: () => onTabTapped(index),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorNavBarItem extends StatelessWidget {
  final _DoctorNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _DoctorNavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: isSelected ? 34.w : 30.w,
                height: isSelected ? 34.w : 30.w,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: isSelected ? 19.sp : 21.sp,
                  color: isSelected ? Colors.white : const Color(0xff8A9696),
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  fontSize: isSelected ? 10.5.sp : 9.5.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xff8A9696),
                  height: 1,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _DoctorNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}