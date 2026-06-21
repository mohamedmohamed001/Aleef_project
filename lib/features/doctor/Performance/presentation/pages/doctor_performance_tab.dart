import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../home/presentation/pages/appointment_details_screen.dart';
import '../manager/doctor_performance_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/empty_appointments.dart';
import '../widgets/performance_appointment_card.dart';
import '../widgets/performance_header.dart';
import '../widgets/performance_stat_card.dart';
import 'doctor_transactions_screen.dart';

class DoctorPerformanceTab extends StatefulWidget {
  const DoctorPerformanceTab({super.key});

  @override
  State<DoctorPerformanceTab> createState() => _DoctorPerformanceTabState();
}

class _DoctorPerformanceTabState extends State<DoctorPerformanceTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DoctorPerformanceProvider>().getDoctorPerformance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFA),
      body: Consumer<DoctorPerformanceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.performance == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (provider.errorMessage != null && provider.performance == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff6B7280),
                  ),
                ),
              ),
            );
          }

          final performance = provider.performance;

          if (performance == null) {
            return const Center(
              child: Text('No performance data found'),
            );
          }

          final total = performance.appointmentsCounts.totalAppointments;
          final completed = performance.appointmentsCounts.completedAppointments;
          final cancelled = performance.appointmentsCounts.cancelledAppointments;

          final rating = performance.doctorRating.rating;
          final ratingCount = performance.doctorRating.ratingCount;

          final appointments = performance.appointments;

          final balance = performance.wallet.balance;
          final transactionsCount = performance.wallet.transactionsCount;
          final totalEarnings = performance.totalEarnings;
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: provider.getDoctorPerformance,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: PerformanceHeader(
                    rating: rating,
                    ratingCount: ratingCount,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                    child: BalanceCard(
                      balance: balance,
                      transactionsCount: transactionsCount,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DoctorTransactionsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
                    child: Column(
                      children: [
                        PerformanceStatCard(
                          title: 'Total Earnings',
                          value: '${totalEarnings.toStringAsFixed(0)} EGP',
                          icon: Icons.payments_rounded,
                          iconColor: const Color(0xff19D58B),
                        ),

                        SizedBox(height: 12.h),

                        Row(
                          children: [
                            Expanded(
                              child: PerformanceStatCard(
                                title: 'Total',
                                value: total.toString(),
                                icon: Icons.calendar_month_rounded,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: PerformanceStatCard(
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
                              child: PerformanceStatCard(
                                title: 'Cancelled',
                                value: cancelled.toString(),
                                icon: Icons.cancel_rounded,
                                iconColor: const Color(0xffE5484D),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: PerformanceStatCard(
                                title: 'Reviews',
                                value: ratingCount.toString(),
                                icon: Icons.reviews_rounded,
                                iconColor: const Color(0xffF2A900),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 26.h, 16.w, 14.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Appointments',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xff1F2937),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.grey.shade100,
                            ),
                          ),
                          child: Text(
                            '${appointments.length} items',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (appointments.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const EmptyAppointments(),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 120.h),
                    sliver: SliverList.separated(
                      itemCount: appointments.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];

                        return PerformanceAppointmentCard(
                          appointment: appointment,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppointmentDetailsScreen(
                                  appointmentId: appointment.id,
                                  showActions: false,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}