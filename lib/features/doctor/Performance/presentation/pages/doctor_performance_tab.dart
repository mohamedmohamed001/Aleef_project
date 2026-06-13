import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/routing/app_routes.dart';
import '../data/models/doctor_performance_model.dart';
import '../manager/doctor_performance_provider.dart';

class DoctorPerformanceTab extends StatefulWidget {
  const DoctorPerformanceTab({super.key});

  @override
  State<DoctorPerformanceTab> createState() => _DoctorPerformanceTabState();
}

class _DoctorPerformanceTabState extends State<DoctorPerformanceTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DoctorPerformanceProvider>().getDoctorPerformance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFA),
      body: Consumer<DoctorPerformanceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final performance = provider.performance;

          if (performance == null) {
            return const Center(child: Text('No performance data found'));
          }

          final total = performance.appointmentsCounts.totalAppointments;
          final completed =
              performance.appointmentsCounts.completedAppointments;
          final cancelled = performance.appointments
              .where((e) => e.status == 'cancelled')
              .length;
          final rating = performance.doctorRating.rating;
          final ratingCount = performance.doctorRating.ratingCount;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: provider.getDoctorPerformance,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    rating: rating,
                    ratingCount: ratingCount,
                  ),

                  Transform.translate(
                    offset: Offset(0, -34.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Total',
                                  value: total.toString(),
                                  icon: Icons.calendar_month_rounded,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _StatCard(
                                  title: 'Completed',
                                  value: completed.toString(),
                                  icon: Icons.verified_rounded,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: 'Cancelled',
                                  value: cancelled.toString(),
                                  icon: Icons.cancel_rounded,
                                  iconColor: const Color(0xffE5484D),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _StatCard(
                                  title: 'Reviews',
                                  value: ratingCount.toString(),
                                  icon: Icons.reviews_rounded,
                                  iconColor: const Color(0xffF2A900),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 28.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Appointments',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xff1F2937),
                                ),
                              ),
                              Text(
                                'Last ${performance.appointments.length} Items  ',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),

                          if (performance.appointments.isEmpty)
                            const _EmptyAppointments()
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: performance.appointments.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 12.h),
                              itemBuilder: (context, index) {
                                final appointment =
                                performance.appointments[index];

                                return _AppointmentCard(
                                  appointment: appointment,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.appointmentUserDetails,
                                      arguments: {
                                        'appointmentId': appointment.id,
                                        'showActions': false,
                                      },
                                    );
                                  },
                                );
                              },
                            ),

                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double rating;
  final int ratingCount;

  const _Header({
    required this.rating,
    required this.ratingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 62.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Track your activity, appointments and reviews',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.22),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 54.w,
                  width: 54.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: const Color(0xffF2A900),
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$ratingCount patient reviews',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.85),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 23.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
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

class _AppointmentCard extends StatelessWidget {
  final DoctorPerformanceAppointment appointment;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.appointment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(appointment.status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.grey.shade100,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 54.w,
                    width: 54.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.11),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: appointment.pet.profilePic.isNotEmpty
                        ? Image.network(
                      appointment.pet.profilePic,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Icon(
                          Icons.pets_rounded,
                          color: AppColors.primary,
                          size: 26.sp,
                        );
                      },
                    )
                        : Icon(
                      Icons.pets_rounded,
                      color: AppColors.primary,
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_capitalize(appointment.pet.type)} • ${_capitalize(appointment.pet.gender)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _capitalize(appointment.owner.name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      appointment.status,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xffF8FAFA),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 17.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 7.w),
                        Expanded(
                          child: Text(
                            appointment.reason,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 17.sp,
                          color: Colors.grey.shade500,
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          appointment.time,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.sp,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xff2F80ED);
      case 'cancelled':
        return const Color(0xffE5484D);
      case 'pending':
        return const Color(0xffE1A514);
      default:
        return const Color(0xff19D58B);
    }
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 42.sp,
            color: AppColors.primary,
          ),
          SizedBox(height: 10.h),
          Text(
            'No appointments yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Your appointments will appear here.',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}