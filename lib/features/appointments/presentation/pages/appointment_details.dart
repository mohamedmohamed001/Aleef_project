import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/appointments/presentation/widgets/%D9%90appointment_details_card.dart';
import 'package:aleef/features/appointments/presentation/widgets/appointment_status_chip.dart';
import 'package:aleef/features/appointments/services/appointment_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../chat/presentation/pages/chat_details.dart';
import '../provider/appointment_provider.dart';
import '../widgets/appointment_time_line.dart';
import '../widgets/cancel_appointment_sheet.dart';

class AppointmentDetails extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetails({super.key, required this.appointmentId});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  AppointmentModel appointment = AppointmentModel();

  Future<void> getAppointmentDetails() async {
    final response = await AppointmentApi().getAppointmentDetails(
      widget.appointmentId,
    );

    if (!mounted) return;

    if (response["status"] == "success") {
      setState(() {
        appointment = AppointmentModel.fromJson(response["data"]);
      });
    } else if (response["status"] == "unauthorized") {
      await SecureStorageService().deleteToken();
      await SecureStorageService().deleteUser();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          elevation: 0,
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          content: Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointmentDetails();
  }

  @override
  Widget build(BuildContext context) {
    final String status = appointment.status?.toLowerCase() ?? "";
    final bool isAccepted = status == "accepted";
    final bool canCancel = status != "cancelled" && status != "completed";

    final String doctorName = appointment.doctor?.name ?? "";
    final String doctorFirstName =
    doctorName.trim().isEmpty ? "Doctor" : doctorName.split(" ").first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Details',
          style: AppTextStyles.black16Bold.copyWith(fontSize: 20.sp),
        ),
      ),
      body: appointment.id == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: getAppointmentDetails,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.88),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.45),
                          width: 1.5.w,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          appointment.doctor?.profilePic ?? "",
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 70.w,
                              height: 70.w,
                              color: Colors.white.withOpacity(0.18),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 34.sp,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(width: 14.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctor?.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 5.h),

                          Text(
                            appointment.doctor?.specialization ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),

                          SizedBox(height: 10.h),

                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _DoctorInfoChip(
                                icon: Icons.star_rounded,
                                text: "4.5",
                                iconColor: Colors.amber,
                              ),
                              _DoctorInfoChip(
                                icon: Icons.location_on_rounded,
                                text: appointment.doctor?.city ?? "-",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              AppointmentDetailsCard(appointment: appointment),

              SizedBox(height: 16.h),

              AppointmentTimeLine(appointment: appointment),

              SizedBox(height: 16.h),

              ElevatedButton(
                onPressed: isAccepted
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDetails(
                        chatId: appointment.chatId ?? '',
                      ),
                    ),
                  );
                }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: isAccepted ? Colors.white : Colors.grey,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Chat with $doctorFirstName",
                      style: TextStyle(
                        color: isAccepted ? Colors.white : Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              OutlinedButton(
                onPressed: canCancel
                    ? () {
                  showCancelAppointmentSheet(
                    context: context,
                    onConfirm: (reason) async {
                      final success = await context.read<AppointmentProvider>().cancelAppointment(
                        appointmentId: appointment.id!,
                        reason: reason,
                      );

                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Appointment cancelled successfully"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        );

                        await Future.delayed(const Duration(milliseconds: 500));

                        if (!context.mounted) return;
                        Navigator.pop(context, true);
                      } else {
                        final error = context.read<AppointmentProvider>().cancelAppointmentError;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error ?? "Something went wrong"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  );
                }
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  disabledForegroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  side: BorderSide(
                    color: canCancel ? Colors.red : Colors.grey.shade300,
                    width: 1.3.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      color: canCancel ? Colors.red : Colors.grey,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Cancel Appointment",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: canCancel ? Colors.red : Colors.grey,
                      ),
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
}

class _DoctorInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const _DoctorInfoChip({
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp, color: iconColor ?? Colors.white),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}