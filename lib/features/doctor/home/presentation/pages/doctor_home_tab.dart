import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_request_card.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_home_empty_state.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_home_error_state.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_home_header.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_home_overview_card.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_home_requests_header.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/doctor_home_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/doctor_provider.dart';
import '../manager/doctor_appointment_provider.dart';
import '../skeletons/appointment_request_card_skeleton.dart';
import '../widgets/reject_appointment_reason_dialog.dart';
import 'appointment_details_screen.dart';

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

      final profileProvider = context.read<DoctorProfileProvider>();

      if (profileProvider.doctorProfile == null) {
        await profileProvider.fetchDoctorProfile();
      }

      if (!mounted) return;

      await context.read<DoctorAppointmentsProvider>().getAppointmentRequests();
    });
  }

  Future<String?> _showRejectReasonDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const RejectAppointmentReasonDialog();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final doctorProvider = context.watch<DoctorProvider>();
    final profileProvider = context.watch<DoctorProfileProvider>();

    final doctor = doctorProvider.doctor;
    final doctorProfile = profileProvider.doctorProfile;

    final doctorName = doctorProfile?.name ?? doctor?.name ?? '';
    final profileImage = doctorProfile?.profilePic ?? doctor?.profilePic;

    return Scaffold(
      backgroundColor: const Color(0xffF7FAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DoctorHomeHeader(
            doctorName: doctorName.split(" ")[0],
            profileImage: profileImage,
            onNotificationTap: () {
              // TODO: Open notifications screen
            },
          ),
          Expanded(
            child: Consumer<DoctorAppointmentsProvider>(
              builder: (context, provider, child) {
                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: Colors.white,
                  onRefresh: () async {
                    await context.read<DoctorProvider>().loadDoctor();
                    await context
                        .read<DoctorProfileProvider>()
                        .fetchDoctorProfile();
                    await provider.getAppointmentRequests();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 18.h),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DoctorHomeOverviewCard(
                                requestsCount: provider.requestsCount,
                              ),
                              SizedBox(height: 20.h),
                              DoctorHomeRequestsHeader(
                                requestsCount: provider.requestsCount,
                              ),
                              SizedBox(height: 14.h),
                            ],
                          ),
                        ),
                      ),

                      if (provider.isLoading)
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          sliver: const SliverToBoxAdapter(
                            child: _DoctorHomeSkeleton(),
                          ),
                        )
                      else if (provider.errorMessage != null)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: DoctorHomeErrorState(
                            message: provider.errorMessage!,
                            onRetry: provider.getAppointmentRequests,
                          ),
                        )
                      else if (provider.appointmentRequests.isEmpty)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: DoctorHomeEmptyState(),
                          )
                        else
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                            sliver: SliverList.separated(
                              itemCount: provider.appointmentRequests.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 12.h);
                              },
                              itemBuilder: (context, index) {
                                final appointment =
                                provider.appointmentRequests[index];

                                return AppointmentRequestCard(
                                  appointmentId: appointment.id,
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
                                    final message = await provider
                                        .acceptAppointment(appointment.id);

                                    if (!context.mounted) return;

                                    showDoctorHomeSnackBar(
                                      context,
                                      message: message ??
                                          'Appointment accepted successfully',
                                      isError: message != null,
                                    );
                                  },
                                  onDecline: () async {
                                    final rejectReason =
                                    await _showRejectReasonDialog(context);

                                    if (rejectReason == null ||
                                        rejectReason.trim().isEmpty) {
                                      return;
                                    }

                                    final message = await provider.rejectAppointment(
                                      appointmentId: appointment.id,
                                      rejectionReason: rejectReason,
                                    );

                                    if (!context.mounted) return;

                                    showDoctorHomeSnackBar(
                                      context,
                                      message: message ??
                                          'Appointment cancelled successfully',
                                      isError: message != null,
                                    );
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ChangeNotifierProvider.value(
                                              value: context.read<
                                                  DoctorAppointmentsProvider>(),
                                              child: AppointmentDetailsScreen(
                                                appointmentId: appointment.id,
                                                showActions: true,
                                              ),
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
          ),
        ],
      ),
    );
  }
}

class _DoctorHomeSkeleton extends StatelessWidget {
  const _DoctorHomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
            (index) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: const AppointmentRequestCardSkeleton(),
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