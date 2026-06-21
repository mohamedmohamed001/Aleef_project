import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/appointment_provider.dart';
import '../widgets/previous_appointments/previous_appointment_card.dart';import '../widgets/previous_appointments/previous_appointment_skeleton.dart';

class PreviousAppointmentScreen extends StatefulWidget {
  const PreviousAppointmentScreen({super.key});

  @override
  State<PreviousAppointmentScreen> createState() =>
      _PreviousAppointmentScreenState();
}

class _PreviousAppointmentScreenState extends State<PreviousAppointmentScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getPreviousAppointments();
    });
  }

  Future<void> _getPreviousAppointments() async {
    if (!mounted) return;
    await context.read<AppointmentProvider>().getPreviousAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: const Color(0xFF111827),
          ),
        ),
        title: Text(
          "Previous Appointments",
          style: AppTextStyles.black16Bold.copyWith(
            fontSize: 17.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<AppointmentProvider>(
          builder: (context, provider, child) {
            if (provider.isPreviousAppointmentsLoading) {
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const PreviousAppointmentSkeleton();
                },
              );
            }

            if (provider.previousAppointmentsError != null) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _getPreviousAppointments,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  children: [
                    SizedBox(height: 130.h),
                    _ErrorState(
                      message: provider.previousAppointmentsError!,
                      onRetry: _getPreviousAppointments,
                    ),
                  ],
                ),
              );
            }

            if (provider.previousAppointments.isEmpty) {
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _getPreviousAppointments,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  children: [
                    SizedBox(height: 150.h),
                    const _EmptyState(),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _getPreviousAppointments,
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: provider.previousAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = provider.previousAppointments[index];

                  return PreviousAppointmentCard(
                    appointment: appointment,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 86.w,
          height: 86.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.event_available_rounded,
            size: 42.sp,
            color: AppColors.primary,
          ),
        ),

        SizedBox(height: 18.h),

        Text(
          "No previous appointments",
          textAlign: TextAlign.center,
          style: AppTextStyles.black16Bold.copyWith(
            fontSize: 17.sp,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          "Your completed or cancelled appointments will appear here.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.4,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 86.w,
          height: 86.w,
          decoration: BoxDecoration(
            color: const Color(0xFFE5484D).withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.error_outline_rounded,
            size: 42.sp,
            color: const Color(0xFFE5484D),
          ),
        ),

        SizedBox(height: 18.h),

        Text(
          "Something went wrong",
          textAlign: TextAlign.center,
          style: AppTextStyles.black16Bold.copyWith(
            fontSize: 17.sp,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.4,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 18.h),

        SizedBox(
          height: 44.h,
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(
              Icons.refresh_rounded,
              size: 18.sp,
            ),
            label: Text(
              "Try Again",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}