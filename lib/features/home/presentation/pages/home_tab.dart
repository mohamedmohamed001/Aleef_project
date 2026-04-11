import 'package:aleef/features/home/presentation/widgets/discount_card.dart';
import 'package:aleef/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/theme/app_text_styles.dart';
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
  late final TextEditingController searchController;
  late final SessionService session;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    session = getIt<SessionService>();
    _init();
  }

  Future<void> _init() async {
    final storage = getIt<SecureStorageService>();

    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);
      debugPrint("User موجود ✅");
    } else {
      debugPrint("User مش موجود ❌");
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
    final user = session.currentUser;

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
                      child: const QuickActionsSection(),
                    ),
                    SizedBox(height: 24.h),
                    const UpcomingAppointmentCard(
                      doctorName: "Ahmed",
                      specialty: "Cat Specialist",
                      date: "12/1",
                      time: "10:00 AM",
                      petName: "Milo",
                      onViewDetails: _emptyCallback,
                    ),
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