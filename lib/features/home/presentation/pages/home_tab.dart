import 'package:aleef/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:aleef/features/home/presentation/widgets/discount_card.dart';
import 'package:aleef/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:aleef/features/pets/services/pets_service.dart';
import 'package:aleef/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../appointments/data/models/appointment_model.dart';
import '../../../appointments/presentation/pages/appointment_details.dart';
import '../../../appointments/services/appointment_api.dart';
import '../widgets/home_header.dart';
import '../widgets/quick)action_section.dart';
import '../widgets/recommended_doctors.dart';
import '../widgets/section_header.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  AppointmentModel? appointment;
  late final TextEditingController searchController;
  final SessionService session = getIt<SessionService>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    fetchCurrentAppointment();
    _init();
  }

  Future<void> fetchCurrentAppointment() async {
    final response = await AppointmentApi().getActiveAppointment();

    if (!mounted) return;

    if (response["status"] == "success" && response["data"] != null) {
      setState(() {
        appointment = AppointmentModel.fromJson(response["data"]);
      });
    } else if (response["status"] == "unauthorized") {
      final storage = getIt<SecureStorageService>();
      await storage.deleteToken();
      await storage.deleteUser();

      if (!mounted) return;

      context.read<UserProvider>().clearUser();

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } else {
      setState(() {
        appointment = null;
      });
    }
  }

  Future<void> _init() async {
    final storage = getIt<SecureStorageService>();
    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);

      if (mounted) {
        context.read<UserProvider>().setUser(user);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user ?? session.currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                userName: user?.name ?? "Guest",
                profilePic: user?.profilePic,
                searchController: searchController,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const DiscountCard(),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Text(
                        "Quick Actions",
                        style: AppTextStyles.black16Bold.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: QuickActionsSection(service: PetsService()),
                    ),
                    SizedBox(height: 24.h),
                    appointment?.doctor?.id != null
                        ? Text(
                            "Upcoming Appointment",
                            style: AppTextStyles.black16Bold.copyWith(
                              fontSize: 18.sp,
                            ),
                          )
                        : Container(),
                    appointment?.doctor?.id != null
                        ? SizedBox(height: 24.h)
                        : Container(),
                    appointment?.doctor?.id != null
                        ? AppointmentCard(
                            doctorName: appointment?.doctor?.name ?? "",
                            specialty:
                                appointment?.doctor?.specialization ?? "",
                            date: appointment?.date != null
                                ? "${appointment?.date!.day}/${appointment?.date!.month}/${appointment?.date!.year}"
                                : "",
                            time: appointment?.time ?? "",
                            petName: appointment?.pet?.name ?? "",
                            petType: appointment?.pet?.type ?? "",
                            status: appointment?.status ?? "",
                            imagePath: appointment?.doctor?.profilePic ?? "",
                            onViewDetails: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AppointmentDetails(
                                    appointmentId: appointment?.id ?? "",
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(),
                    SizedBox(height: 24.h),
                    const SectionHeader(title: "Recommended Vets"),
                    SizedBox(height: 12.h),
                    const RecommendedDoctors(),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _emptyCallback() {}
}
