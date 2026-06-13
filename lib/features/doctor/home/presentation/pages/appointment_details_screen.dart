import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../manager/doctor_appointment_provider.dart';
import '../skeletons/appointment_details_skeleton.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;
  final bool showActions;


  const AppointmentDetailsScreen({
    super.key,
    required this.appointmentId, this.showActions = true,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  late DoctorAppointmentsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<DoctorAppointmentsProvider>();

    Future.microtask(() {
      _provider.getAppointmentDetails(widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FA),
      body: Consumer<DoctorAppointmentsProvider>(
        builder: (context, provider, child) {
          if (provider.isDetailsLoading) {
            return const AppointmentDetailsSkeleton();
          }

          if (provider.detailsErrorMessage != null) {
            return Center(
              child: Text(
                provider.detailsErrorMessage!,
                style: AppTextStyles.body14Medium.copyWith(color: Colors.red),
              ),
            );
          }

          final appointment = provider.appointmentDetails;

          if (appointment == null) {
            return Center(
              child: Text(
                'No appointment details found',
                style: AppTextStyles.body14Medium,
              ),
            );
          }

          return Column(
            children: [
              _header(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
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
                        fee: appointment.appoinmentFee,
                      ),
                      SizedBox(height: 22.h),
                      if (widget.showActions) ...[
                        SizedBox(height: 22.h),
                        _actionsRow(provider, appointment.id),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 34.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(50.r),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 18.w),
          Text(
            'Appointment Details',
            style: AppTextStyles.heading24Bold.copyWith(
              color: Colors.white,
              fontSize: 22.sp,
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
              errorBuilder: (_, __, ___) => _imageFallback(Icons.pets),
            )
                : _imageFallback(Icons.pets),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _capitalize(name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.heading24Bold.copyWith(
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${_capitalize(type)} • ${_capitalize(gender)} • $age Years',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14Medium.copyWith(
                    fontSize: 15.sp,
                    color: const Color(0xff526276),
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
            label: 'Date & Time',
            value: '${_formatDate(date)} at $time',
          ),
          SizedBox(height: 18.h),
          _infoBlock(
            label: 'Reason for Visit',
            value: reason.trim().isEmpty ? '-' : reason,
          ),
          SizedBox(height: 18.h),
          _infoBlock(
            label: 'Additional Notes',
            value: notes?.trim().isNotEmpty == true ? notes! : 'No notes',
          ),
          SizedBox(height: 18.h),
          _infoBlock(
            label: 'Appointment Fee',
            value: '$fee EGP',
          ),
          SizedBox(height: 18.h),
          Text(
            'Status',
            style: AppTextStyles.body14Regular.copyWith(
              color: const Color(0xff64748B),
              fontSize: 15.sp,
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

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 58.h,
            child: ElevatedButton.icon(
              onPressed: () async {
                final message = await provider.acceptAppointment(appointmentId);
                if (!mounted) return;

                _showSnackBar(
                  message ?? 'Appointment accepted successfully',
                  isError: message != null,
                );
              },
              icon: Icon(Icons.check_rounded, size: 22.sp),
              label: Text(
                'Accept\nAppointment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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
            child: OutlinedButton.icon(
              onPressed: () async {
                final message = await provider.declineAppointment(appointmentId);
                if (!mounted) return;

                _showSnackBar(
                  message ?? 'Appointment declined successfully',
                  isError: message != null,
                );
              },
              icon: Icon(Icons.close_rounded, size: 22.sp),
              label: Text(
                'Decline',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red, width: 1.4.w),
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
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
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
        fontSize: 15.sp,
        color: const Color(0xff64748B),
        letterSpacing: 0.2,
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
          decoration: const BoxDecoration(
            color: Color(0xffF1F5F9),
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
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                value.trim().isEmpty ? '-' : value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title16Bold.copyWith(
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoBlock({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body14Regular.copyWith(
            color: const Color(0xff64748B),
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.title16Bold.copyWith(
            fontSize: 16.sp,
            height: 1.3,
          ),
        ),
      ],
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
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _imageFallback(IconData icon) {
    return Container(
      width: 82.w,
      height: 82.w,
      color: const Color(0xffF1F5F9),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 34.sp,
      ),
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
    if (value.trim().isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String _capitalizeWords(String value) {
    return value
        .split(' ')
        .map((word) => word.isEmpty ? word : _capitalize(word))
        .join(' ');
  }
}