import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/appointments/presentation/widgets/%D9%90appointment_details_card.dart';
import 'package:aleef/features/appointments/presentation/widgets/appointment_status_chip.dart';
import 'package:aleef/features/appointments/services/appointment_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../chat/presentation/pages/chat_details.dart';
import '../widgets/appointment_time_line.dart';

class AppointmentDetails extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetails({super.key, required this.appointmentId});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  late AppointmentModel appointment = AppointmentModel();

  Future<void> getAppointmentDetails() async {
    final response = await AppointmentApi().getAppointmentDetails(
      widget.appointmentId,
    );

    if (response["status"] == "success") {
      if (!mounted) return;
      setState(() {
        appointment = AppointmentModel.fromJson(response["data"]);
      });
    } else if (response["status"] == "unauthorized") {
      SecureStorageService().deleteToken();
      SecureStorageService().deleteUser();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    } else {
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
        content: Text("Something went wrong"),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAppointmentDetails();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Details',
          style: AppTextStyles.black16Bold.copyWith(fontSize: 20.sp),
        ),
      ),
      body: appointment.id == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: RefreshIndicator(
          onRefresh: () {
            return getAppointmentDetails();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: AppColors.primary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.r),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.network(
                              appointment.doctor!.profilePic.toString(),
                              width: 60.w,
                              height: 60.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.doctor?.name.toString() ?? "",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      appointment.doctor?.specialization
                                          .toString() ??
                                          "",
                                      style: AppTextStyles.hint14Regular
                                          .copyWith(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  AppointmentStatusChip(
                                    status: appointment.status.toString(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "4.5",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    appointment.doctor!.city.toString(),
                                    style: const TextStyle(color: Colors.white),
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
                SizedBox(height: 16.h),
                AppointmentDetailsCard(appointment: appointment),
                SizedBox(height: 16.h),
                AppointmentTimeLine(appointment: appointment),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: appointment.status !="accepted"
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetails(
                          chatId: appointment.chatId ?? '',
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: appointment.status == "cancelled"
                            ? Colors.grey
                            : Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Chat with Doctor ${appointment.doctor?.name?.split(
                            " ")[0]}",
                        style: TextStyle(
                          color: appointment.status == "cancelled"
                              ? Colors.grey
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
