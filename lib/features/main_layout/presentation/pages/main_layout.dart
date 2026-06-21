import 'package:aleef/core/services/socket_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/pending_review_model.dart';
import 'package:aleef/features/appointments/presentation/pages/appointments_screen.dart';
import 'package:aleef/features/appointments/presentation/provider/appointment_provider.dart';
import 'package:aleef/features/appointments/presentation/widgets/doctor_review_bottom_sheet.dart';
import 'package:aleef/features/chat/presentation/pages/chat_tab.dart';
import 'package:aleef/features/home/presentation/pages/home_tab.dart';
import 'package:aleef/features/main_layout/presentation/widgets/bottom_nav_bar.dart';
import 'package:aleef/features/notifications/presentation/provider/notification_provider.dart';
import 'package:aleef/features/profile/presentation/pages/profile_screen.dart';
import 'package:aleef/features/store/presentation/pages/store_tab.dart';
import 'package:aleef/providers/bottom_nav_provider.dart';
import 'package:aleef/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';

final GlobalKey<ProfileTabState> profileTabKey = GlobalKey<ProfileTabState>();

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  bool _reviewSheetShown = false;
  bool _didRequestLocation = false;
  bool _didInitSocketAndNotifications = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initMainLayoutData();
    });
  }

  Future<void> _initMainLayoutData() async {
    if (!_didInitSocketAndNotifications) {
      _didInitSocketAndNotifications = true;

      SocketService().connectCurrentSession();

      if (!mounted) return;

      final notificationProvider = context.read<NotificationProvider>();

      notificationProvider.initSocketNotifications(context);

      notificationProvider.getUnreadNotificationsCount().catchError((error) {
        debugPrint('Unread notifications count error: $error');
      });
    }

    await _getUserLocationOnce();

    await _checkPendingDoctorReview();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      Future.microtask(() async {
        if (!mounted) return;

        final locationProvider = context.read<LocationProvider>();
        final appointmentProvider = context.read<AppointmentProvider>();

        final serviceEnabled =
        await locationProvider.checkLocationServiceAndClearIfOff();

        if (!mounted) return;

        if (!serviceEnabled) {
          _didRequestLocation = false;

          await appointmentProvider.fetchAppointmentTabData();

          return;
        }

        if (locationProvider.lat == null || locationProvider.lng == null) {
          _didRequestLocation = false;
          await _getUserLocationOnce();
          return;
        }

        await appointmentProvider.fetchAppointmentTabData(
          lat: locationProvider.lat,
          lng: locationProvider.lng,
        );
      });
    }
  }

  Future<void> _getUserLocationOnce() async {
    if (_didRequestLocation) return;

    _didRequestLocation = true;

    final locationProvider = context.read<LocationProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();

    await locationProvider.getUserLocation(
      requestPermission: false,
    );

    debugPrint('MAIN LAYOUT USER LAT => ${locationProvider.lat}');
    debugPrint('MAIN LAYOUT USER LNG => ${locationProvider.lng}');

    final bool hasNoLocation =
        locationProvider.lat == null || locationProvider.lng == null;

    if (hasNoLocation) {
      _didRequestLocation = false;

      if (!mounted) return;

      await appointmentProvider.fetchAppointmentTabData();
      return;
    }

    if (!mounted) return;

    await appointmentProvider.fetchAppointmentTabData(
      lat: locationProvider.lat,
      lng: locationProvider.lng,
    );
  }

  Future<void> _checkPendingDoctorReview() async {
    if (_reviewSheetShown) return;

    final provider = context.read<AppointmentProvider>();
    final pendingReviewJson = await provider.checkPendingDoctorReview();

    debugPrint("PENDING REVIEW JSON => $pendingReviewJson");

    if (!mounted || pendingReviewJson == null) return;

    final pendingReview = PendingReviewModel.fromJson(pendingReviewJson);

    if (pendingReview.appointmentId.isEmpty) return;

    _reviewSheetShown = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) {
        return DoctorReviewBottomSheet(
          pendingReview: pendingReview,
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = context.watch<BottomNavProvider>();
    final selectedIndex = bottomNavProvider.selectedIndex;

    final List<Widget> tabs = [
      const HomeTab(),
      const AppointmentTab(),
      const ChatTab(),
      const StoreTab(),
      ProfileTab(key: profileTabKey),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8FAFA),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedIndex == 0
          ? null
          : Padding(
        padding: const EdgeInsets.only(bottom: 82),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: AppColors.primary,
          elevation: 6,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.chatBotScreen);
          },
          child: const Icon(
            Icons.smart_toy_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          context.read<BottomNavProvider>().changeTab(index);
        },
      ),
    );
  }
}