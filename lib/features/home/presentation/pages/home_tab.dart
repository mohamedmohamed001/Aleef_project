import 'package:aleef/features/home/presentation/widgets/discount_card.dart';
import 'package:aleef/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
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

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _init();
  }

  Future<void> _init() async {
    final storage = getIt<SecureStorageService>();
    final session = getIt<SessionService>();

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
    final session = getIt<SessionService>();
    final user = session.currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                userName: user?.name,
                profilePic: user?.profilePic,
                searchController: searchController,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    DiscountCard(),
                    SizedBox(height: 24),
                    QuickActionsSection(),
                    SizedBox(height: 24),
                    UpcomingAppointmentCard(
                      doctorName: "Ahmed",
                      specialty: "Cat Specialist",
                      date: "12/1",
                      time: "10:00 AM",
                      petName: "Milo",
                      onViewDetails: _emptyCallback,
                    ),
                    SizedBox(height: 24),
                    SectionHeader(title: "Recommended Vets"),
                    SizedBox(height: 12),
                    RecommendedDoctors(),
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
