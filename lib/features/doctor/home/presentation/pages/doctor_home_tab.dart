import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_request_card.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/doctor_provider.dart';
import '../manager/doctor_appointment_provider.dart';
class DoctorHomeTab extends StatefulWidget {
  const DoctorHomeTab({super.key});

  @override
  State<DoctorHomeTab> createState() => _DoctorHomeTabState();
}

class _DoctorHomeTabState extends State<DoctorHomeTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<DoctorProvider>().loadDoctor();

      if (!mounted) return;

      await context
          .read<DoctorAppointmentsProvider>()
          .getAppointmentRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProvider = context.watch<DoctorProvider>();
    final doctor = doctorProvider.doctor;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DoctorHomeHeader(
            doctorName: doctor?.name?.split(" ")[0] ?? '',
            profileImage: doctor?.profilePic,
            onNotificationTap: () {
              // TODO: Open notifications screen
            },
          ),

          Expanded(
            child: Consumer<DoctorAppointmentsProvider>(
              builder: (context, provider, child) {
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: provider.getAppointmentRequests,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RequestsHeader(
                          requestsCount: provider.requestsCount,
                        ),

                        // SizedBox(height: 10.h),

                        if (provider.isLoading)
                          const _LoadingState()
                        else if (provider.errorMessage != null)
                          _ErrorState(
                            message: provider.errorMessage!,
                            onRetry: provider.getAppointmentRequests,
                          )
                        else if (provider.appointmentRequests.isEmpty)
                            const _EmptyState()
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount:
                              provider.appointmentRequests.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 12.h);
                              },
                              itemBuilder: (context, index) {
                                final appointment =
                                provider.appointmentRequests[index];

                                return AppointmentRequestCard(
                                  petName: _capitalize(appointment.pet.name),
                                  petImage: appointment.pet.profilePic ?? '',
                                  petType: _capitalize(appointment.pet.type),
                                  ownerName: _capitalizeWords(
                                    appointment.owner.name,
                                  ),
                                  date: _formatDate(appointment.date),
                                  time: appointment.time,
                                  reason: appointment.reason,
                                  isLoading: provider.isAppointmentLoading(
                                    appointment.id,
                                  ),
                                  onAccept: () async {
                                    final message = await provider.acceptAppointment(
                                      appointment.id,
                                    );

                                    if (!context.mounted) return;

                                    _showResultSnackBar(
                                      context,
                                      message: message ?? 'Appointment accepted successfully',
                                      isError: message != null,
                                    );
                                  },
                                  onDecline: () async {
                                    final message = await provider.declineAppointment(
                                      appointment.id,
                                    );

                                    if (!context.mounted) return;

                                    _showResultSnackBar(
                                      context,
                                      message: message ?? 'Appointment declined successfully',
                                      isError: message != null,
                                    );
                                  },
                                );
                              },
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsHeader extends StatelessWidget {
  final int requestsCount;

  const _RequestsHeader({required this.requestsCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Appointment Requests',
          style: AppTextStyles.title16SemiBold.copyWith(fontSize: 20.sp),
        ),

        const Spacer(),

        Container(
          constraints: BoxConstraints(minWidth: 34.w, minHeight: 32.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(99.r),
          ),
          child: Text(
            requestsCount.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 48.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 12.h),
            Text(
              'No pending appointment requests',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline_rounded, size: 48.sp, color: Colors.red),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => onRetry(),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime? date) {
  if (date == null) return '';

  return '${date.day}/${date.month}/${date.year}';
}

String _capitalize(String value) {
  final trimmedValue = value.trim();

  if (trimmedValue.isEmpty) return '';

  return '${trimmedValue[0].toUpperCase()}${trimmedValue.substring(1)}';
}

String _capitalizeWords(String value) {
  return value
      .trim()
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map(_capitalize)
      .join(' ');
}

void _showResultSnackBar(
    BuildContext context, {
      required String message,
      required bool isError,
    }) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : AppColors.primary,
    ),
  );
}
