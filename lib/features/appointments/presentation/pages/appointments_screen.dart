import 'dart:async';

import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../providers/bottom_nav_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../services/appointment_api.dart';
import '../widgets/appointment_card.dart';
import '../widgets/appointment_screen_skeleton.dart';
import '../widgets/appointments_header.dart';
import '../widgets/available_doctors/available_doctors_section.dart';
import 'appointment_details.dart';

class AppointmentTab extends StatefulWidget {
  const AppointmentTab({super.key});

  @override
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;
  bool isDoctorsLoading = false;
  bool isPageLoading = true;
  bool isDoctorsLoadingMore = false;

  int doctorsPage = 1;
  int doctorsTotalPages = 1;
  String doctorsSearch = "";

  AppointmentModel appointment = AppointmentModel();
  List<DoctorModel> doctors = [];

  bool get hasMoreDoctors => doctorsPage < doctorsTotalPages;

  @override
  void initState() {
    super.initState();
    fetchAppointmentPageData();
    _scrollController.addListener(_onScroll);
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
      loadMoreDoctors();
    }
  }

  Future<void> fetchAppointmentPageData() async {
    if (!mounted) return;

    final bool firstLoad = appointment.id == null && doctors.isEmpty;

    setState(() {
      if (firstLoad) {
        isPageLoading = true;
      } else {
        isDoctorsLoading = true;
      }

      doctorsPage = 1;
      doctorsTotalPages = 1;
      isDoctorsLoadingMore = false;
    });

    try {
      final results = await Future.wait([
        AppointmentApi().getActiveAppointment(),
        AppointmentApi().getAvailableDoctor(
          page: 1,
          limit: 8,
          search: doctorsSearch,
        ),
      ]);

      if (!mounted) return;

      final appointmentResponse = results[0];
      final doctorsResponse = results[1];

      if (appointmentResponse["status"] == "unauthorized" ||
          doctorsResponse["status"] == "unauthorized") {
        await _logoutAndGoLogin();
        return;
      }

      final appointmentData = appointmentResponse["data"];

      final loadedAppointment =
      appointmentResponse["status"] == "success" &&
          appointmentData != null &&
          appointmentData is Map<String, dynamic> &&
          appointmentData.isNotEmpty
          ? AppointmentModel.fromJson(appointmentData)
          : AppointmentModel();

      final List doctorsData = doctorsResponse["data"] ?? [];

      final loadedDoctors = doctorsData
          .whereType<Map<String, dynamic>>()
          .map((e) => DoctorModel.fromJson(e))
          .toList();

      setState(() {
        appointment = loadedAppointment;
        doctors = loadedDoctors;
        doctorsPage = int.tryParse(doctorsResponse["page"].toString()) ?? 1;
        doctorsTotalPages =
            int.tryParse(doctorsResponse["totalPages"].toString()) ?? 1;

        isPageLoading = false;
        isDoctorsLoading = false;
        isDoctorsLoadingMore = false;
      });
    } catch (e, s) {
      debugPrint("fetchAppointmentPageData error: $e");
      debugPrint("stack: $s");

      if (!mounted) return;

      setState(() {
        if (firstLoad) {
          appointment = AppointmentModel();
          doctors = [];
        }

        isPageLoading = false;
        isDoctorsLoading = false;
        isDoctorsLoadingMore = false;
      });
    }
  }

  Future<void> loadMoreDoctors() async {
    if (isDoctorsLoadingMore || !hasMoreDoctors) return;

    setState(() {
      isDoctorsLoadingMore = true;
    });

    try {
      final response = await AppointmentApi().getAvailableDoctor(
        page: doctorsPage + 1,
        limit: 8,
        search: doctorsSearch,
      );

      if (!mounted) return;

      if (response["status"] == "unauthorized") {
        await _logoutAndGoLogin();
        return;
      }

      if (response["status"] == "success") {
        final List doctorsData = response["data"] ?? [];

        final loadedDoctors = doctorsData
            .whereType<Map<String, dynamic>>()
            .map((e) => DoctorModel.fromJson(e))
            .toList();

        setState(() {
          doctors.addAll(loadedDoctors);
          doctorsPage = int.tryParse(response["page"].toString()) ?? doctorsPage;
          doctorsTotalPages =
              int.tryParse(response["totalPages"].toString()) ??
                  doctorsTotalPages;
          isDoctorsLoadingMore = false;
        });
      } else {
        setState(() {
          isDoctorsLoadingMore = false;
        });
      }
    } catch (e) {
      debugPrint("loadMoreDoctors error: $e");

      if (!mounted) return;

      setState(() {
        isDoctorsLoadingMore = false;
      });
    }
  }

  void onDoctorSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      doctorsSearch = value.trim();
      fetchAppointmentPageData();
    });
  }

  Future<void> _logoutAndGoLogin() async {
    final storage = SecureStorageService();

    await storage.deleteToken();
    await storage.deleteUser();

    if (!mounted) return;

    context.read<UserProvider>().clearUser();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (route) => false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = context.watch<BottomNavProvider>();

    if (provider.shouldRefreshAppointments) {
      fetchAppointmentPageData();
      provider.doneRefresh();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: isPageLoading
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
                      specialty: appointment.doctor?.specialization ?? "",
                      date: _formatDate(appointment.date),
                      time: appointment.time ?? "",
                      petName: appointment.pet?.name ?? "",
                      petType: appointment.pet?.type ?? "",
                      status: appointment.status ?? "",
                      imagePath: appointment.doctor?.profilePic ?? "",
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
                  isLoading: isDoctorsLoading,
                  isLoadingMore: isDoctorsLoadingMore,
                  onSearchChanged: onDoctorSearchChanged,
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}