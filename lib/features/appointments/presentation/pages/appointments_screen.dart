import 'dart:async';

import 'package:aleef/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../providers/bottom_nav_provider.dart';
import '../provider/appointment_provider.dart';
import '../widgets/appointments/appointment_card.dart';
import '../widgets/appointments/appointment_screen_skeleton.dart';
import '../widgets/appointments/appointments_header.dart';
import '../widgets/available_doctors/available_doctors_section.dart';
import '../widgets/location/location_permission_dialog.dart';
import '../widgets/location/location_service_dialog.dart';
import 'appointment_details.dart';

class AppointmentTab extends StatefulWidget {
  const AppointmentTab({super.key});

  @override
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  String doctorsSearch = "";
  bool _didInitialLoad = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _initialLoad();
    });

    _scrollController.addListener(_onScroll);
  }

  Future<void> _initialLoad() async {
    if (_didInitialLoad) return;
    _didInitialLoad = true;

    final appointmentProvider = context.read<AppointmentProvider>();

    if (appointmentProvider.availableDoctors.isNotEmpty ||
        appointmentProvider.activeAppointment.id != null) {
      return;
    }

    await fetchAppointmentPageData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      final locationProvider = context.read<LocationProvider>();

      context.read<AppointmentProvider>().loadMoreDoctors(
        search: doctorsSearch,
        lat: locationProvider.lat,
        lng: locationProvider.lng,
      );
    }
  }

  Future<void> fetchAppointmentPageData() async {
    final locationProvider = context.read<LocationProvider>();

    await context.read<AppointmentProvider>().fetchAppointmentTabData(
      search: doctorsSearch,
      lat: locationProvider.lat,
      lng: locationProvider.lng,
    );
  }

  Future<void> _enableLocationAndRefresh() async {
    final locationProvider = context.read<LocationProvider>();
    final appointmentProvider = context.read<AppointmentProvider>();

    await locationProvider.refreshLocation(
      requestPermission: true,
    );

    if (!mounted) return;

    if (locationProvider.hasLocation) {
      await appointmentProvider.fetchAppointmentTabData(
        search: doctorsSearch,
        lat: locationProvider.lat,
        lng: locationProvider.lng,
      );
      return;
    }

    final error = locationProvider.locationError;

    if (error == null) return;

    if (error.toLowerCase().contains('device location') ||
        error.toLowerCase().contains('turn on')) {
      showLocationServiceDialog(context);
      return;
    }

    showLocationPermissionDialog(
      context: context,
      message: error,
    );
  }

  void onDoctorSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      doctorsSearch = value.trim();

      final locationProvider = context.read<LocationProvider>();

      context.read<AppointmentProvider>().fetchAppointmentTabData(
        search: doctorsSearch,
        lat: locationProvider.lat,
        lng: locationProvider.lng,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bottomNavProvider = context.watch<BottomNavProvider>();

    if (bottomNavProvider.shouldRefreshAppointments) {
      Future.microtask(() async {
        await fetchAppointmentPageData();

        if (!mounted) return;

        context.read<BottomNavProvider>().doneRefresh();
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppointmentProvider, LocationProvider>(
      builder: (context, appointmentProvider, locationProvider, _) {
        final appointment = appointmentProvider.activeAppointment;
        final doctors = appointmentProvider.availableDoctors;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: SafeArea(
            child: appointmentProvider.isAppointmentTabLoading
                ? const AppointmentTabSkeleton()
                : RefreshIndicator(
              onRefresh: fetchAppointmentPageData,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
                  children: [
                    AppointmentsHeader(
                      onPreviousTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.previousAppointmentScreen,
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    if (appointment.doctor?.name != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: AppointmentCard(
                          doctorName: appointment.doctor?.name ?? "",
                          specialty:
                          appointment.doctor?.specialization ?? "",
                          date: _formatDate(appointment.date),
                          time: appointment.time ?? "",
                          petName: appointment.pet?.name ?? "",
                          petType: appointment.pet?.type ?? "",
                          status: appointment.status ?? "",
                          imagePath:
                          appointment.doctor?.profilePic ?? "",
                          onViewDetails: () async {
                            if (appointment.id == null) return;

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AppointmentDetails(
                                  appointmentId: appointment.id!,
                                ),
                              ),
                            );

                            if (result == true) {
                              await fetchAppointmentPageData();
                            }
                          },
                        ),
                      ),

                    if (appointment.doctor?.name != null)
                      SizedBox(height: 24.h),

                    AvailableDoctorsSection(
                      doctors: doctors,
                      isLoading: appointmentProvider.isDoctorsLoading,
                      isLoadingMore:
                      appointmentProvider.isDoctorsLoadingMore,
                      onSearchChanged: onDoctorSearchChanged,
                      hasLocation: locationProvider.hasLocation,
                      isLocationLoading:
                      locationProvider.isLoadingLocation,
                      onEnableLocationTap: _enableLocationAndRefresh,
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}