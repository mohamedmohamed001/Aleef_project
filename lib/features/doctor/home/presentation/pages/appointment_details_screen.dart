import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../manager/doctor_appointment_provider.dart';
import '../skeletons/appointment_details_skeleton.dart';
import '../widgets/reject_appointment_reason_dialog.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;
  final bool showActions;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointmentId,
    this.showActions = true,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  late final DoctorAppointmentsProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = context.read<DoctorAppointmentsProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _provider.getAppointmentDetails(widget.appointmentId);
    });
  }

  Future<void> _refreshDetails() async {
    await context
        .read<DoctorAppointmentsProvider>()
        .getAppointmentDetails(widget.appointmentId);
  }

  Future<String?> _showRejectReasonDialog() {
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
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FA),
      body: Consumer<DoctorAppointmentsProvider>(
        builder: (context, provider, child) {
          if (provider.isDetailsLoading && provider.appointmentDetails == null) {
            return Column(
              children: [
                _header(context),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                    child: const AppointmentDetailsSkeleton(),
                  ),
                ),
              ],
            );
          }

          if (provider.detailsErrorMessage != null &&
              provider.appointmentDetails == null) {
            return Column(
              children: [
                _header(context),
                Expanded(
                  child: _errorState(
                    message: provider.detailsErrorMessage!,
                    onRetry: _refreshDetails,
                  ),
                ),
              ],
            );
          }

          final appointment = provider.appointmentDetails;

          if (appointment == null) {
            return Column(
              children: [
                _header(context),
                Expanded(
                  child: _emptyState(),
                ),
              ],
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refreshDetails,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _header(context),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _petCard(
                          image: appointment.pet.profilePic,
                          name: appointment.pet.name,
                          type: appointment.pet.type,
                          gender: appointment.pet.gender,
                          age: appointment.pet.age,
                        ),
                        SizedBox(height: 16.h),
                        _ownerCard(
                          name: appointment.owner.name,
                          phone: appointment.owner.phone,
                          email: appointment.owner.email,
                          image: appointment.owner.profilePic,
                        ),
                        SizedBox(height: 16.h),
                        _appointmentCard(
                          date: appointment.date,
                          time: appointment.time,
                          reason: appointment.reason,
                          notes: appointment.notes,
                          status: appointment.status,
                          fee: appointment.appointmentFee,
                        ),
                        if (widget.showActions) ...[
                          SizedBox(height: 22.h),
                          _actionsRow(provider, appointment.id),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 48.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.24),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white.withOpacity(0.16),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 44.w,
                height: 44.w,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Details',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading24Bold.copyWith(
                    color: Colors.white,
                    fontSize: 22.sp,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Review pet, owner and visit information',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14Medium.copyWith(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 12.5.sp,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _petCard({
    required String image,
    required String name,
    required String type,
    required String gender,
    required int age,
  }) {
    return _card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: image.trim().isNotEmpty
                ? Image.network(
              image,
              width: 82.w,
              height: 82.w,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _imageFallback(Icons.pets),
            )
                : _imageFallback(Icons.pets),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.trim().isEmpty ? 'Pet' : _capitalize(name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading24Bold.copyWith(
                    fontSize: 23.sp,
                    color: const Color(0xff1F2937),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${_capitalize(type)} • ${_capitalize(gender)} • $age Years',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14Medium.copyWith(
                    fontSize: 14.sp,
                    color: const Color(0xff64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ownerCard({
    required String name,
    required String phone,
    required String email,
    required String image,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('OWNER INFORMATION'),
          SizedBox(height: 18.h),
          _ownerRow(
            icon: Icons.person_rounded,
            label: 'Name',
            value: _capitalizeWords(name),
          ),
          SizedBox(height: 16.h),
          _ownerRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: phone,
          ),
          SizedBox(height: 16.h),
          _ownerRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: email,
          ),
        ],
      ),
    );
  }

  Widget _appointmentCard({
    required String date,
    required String time,
    required String reason,
    required String? notes,
    required String status,
    required int fee,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('APPOINTMENT DETAILS'),
          SizedBox(height: 18.h),
          _infoBlock(
            icon: Icons.calendar_month_rounded,
            label: 'Date & Time',
            value:
            '${_formatDate(date)} at ${time.trim().isEmpty ? '--:--' : time}',
          ),
          SizedBox(height: 16.h),
          _infoBlock(
            icon: Icons.medical_services_outlined,
            label: 'Reason for Visit',
            value: reason.trim().isEmpty ? '-' : reason,
          ),
          SizedBox(height: 16.h),
          _infoBlock(
            icon: Icons.notes_rounded,
            label: 'Additional Notes',
            value: notes?.trim().isNotEmpty == true ? notes! : 'No notes',
          ),
          SizedBox(height: 16.h),
          _infoBlock(
            icon: Icons.payments_rounded,
            label: 'Appointment Fee',
            value: '$fee EGP',
          ),
          SizedBox(height: 18.h),
          Text(
            'Status',
            style: AppTextStyles.body14Regular.copyWith(
              color: const Color(0xff64748B),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          _statusBadge(status),
        ],
      ),
    );
  }

  Widget _actionsRow(
      DoctorAppointmentsProvider provider,
      String appointmentId,
      ) {
    final isLoading = provider.isAppointmentLoading(appointmentId);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 58.h,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                final rejectReason = await _showRejectReasonDialog();

                if (rejectReason == null ||
                    rejectReason.trim().isEmpty) {
                  return;
                }

                final message = await provider.rejectAppointment(
                  appointmentId: appointmentId,
                  rejectionReason: rejectReason,
                );

                if (!mounted) return;

                _showSnackBar(
                  message ?? 'Appointment cancelled successfully',
                  isError: message != null,
                );

                if (message == null) {
                  Navigator.pop(context, true);
                }
              },
              icon: isLoading
                  ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4.w,
                  color: Colors.red,
                ),
              )
                  : Icon(
                Icons.close_rounded,
                size: 22.sp,
              ),
              label: Text(
                isLoading ? 'Loading...' : 'Cancel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFF1F1),
                disabledBackgroundColor: const Color(0xFFFFF1F1),
                foregroundColor: Colors.red,
                disabledForegroundColor: Colors.red.withOpacity(0.45),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: SizedBox(
            height: 58.h,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                final message =
                await provider.acceptAppointment(appointmentId);

                if (!mounted) return;

                _showSnackBar(
                  message ?? 'Appointment accepted successfully',
                  isError: message != null,
                );

                if (message == null) {
                  Navigator.pop(context, true);
                }
              },
              icon: isLoading
                  ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4.w,
                  color: Colors.white,
                ),
              )
                  : Icon(
                Icons.check_rounded,
                size: 22.sp,
              ),
              label: Text(
                isLoading ? 'Loading...' : 'Accept',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.55),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.title16Bold.copyWith(
        fontSize: 14.sp,
        color: const Color(0xff64748B),
        letterSpacing: 0.4,
      ),
    );
  }

  Widget _ownerRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.09),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body14Regular.copyWith(
                  color: const Color(0xff64748B),
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value.trim().isEmpty ? '-' : value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title16Bold.copyWith(
                  fontSize: 15.sp,
                  color: const Color(0xff1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoBlock({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFA),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              size: 19.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.body14Regular.copyWith(
                    color: const Color(0xff64748B),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  value,
                  style: AppTextStyles.title16Bold.copyWith(
                    fontSize: 15.sp,
                    height: 1.3,
                    color: const Color(0xff1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        status.trim().isEmpty ? 'Unknown' : _capitalize(status),
        style: AppTextStyles.body14Medium.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  Widget _imageFallback(IconData icon) {
    return Container(
      width: 82.w,
      height: 82.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.09),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 34.sp,
      ),
    );
  }

  Widget _errorState({
    required String message,
    required Future<void> Function() onRetry,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Something went wrong',
              style: AppTextStyles.title16Bold.copyWith(
                fontSize: 18.sp,
                color: const Color(0xff1F2937),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body14Medium.copyWith(
                color: const Color(0xff64748B),
                height: 1.4,
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 22.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                color: AppColors.primary,
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No appointment details found',
              textAlign: TextAlign.center,
              style: AppTextStyles.title16Bold.copyWith(
                fontSize: 17.sp,
                color: const Color(0xff1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: isError ? Colors.red : AppColors.primary,
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
      case 'confirmed':
        return const Color(0xff19D58B);
      case 'pending':
        return const Color(0xffE1A514);
      case 'cancelled':
      case 'canceled':
      case 'rejected':
        return const Color(0xffE5484D);
      case 'completed':
        return const Color(0xff2F80ED);
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(String date) {
    if (date.length < 10) return date;
    return date.substring(0, 10);
  }

  String _capitalize(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) return trimmed;

    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }

  String _capitalizeWords(String value) {
    return value
        .trim()
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => _capitalize(word))
        .join(' ');
  }
}