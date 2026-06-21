import 'package:flutter/cupertino.dart';

import '../../../../core/services/auth_guard_service.dart';
import '../../../pets/data/models/pet_model.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/doctor_model.dart';
import '../../data/models/previous_appointment_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/scheduled_day_model.dart';
import '../../services/appointment_api.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentApi appointmentApi = AppointmentApi();

  // =========================
  // Appointment Tab
  // =========================

  AppointmentModel activeAppointment = AppointmentModel();
  List<DoctorModel> availableDoctors = [];

  bool isAppointmentTabLoading = true;
  bool isDoctorsLoading = false;
  bool isDoctorsLoadingMore = false;

  String? appointmentTabError;

  int doctorsPage = 1;
  int doctorsTotalPages = 1;

  double? currentLat;
  double? currentLng;

  bool get hasMoreDoctors => doctorsPage < doctorsTotalPages;

  Future<void> fetchAppointmentTabData({
    String search = "",
    double? lat,
    double? lng,
  }) async {
    currentLat = lat;
    currentLng = lng;

    final bool firstLoad =
        activeAppointment.id == null && availableDoctors.isEmpty;

    if (firstLoad) {
      isAppointmentTabLoading = true;
    } else {
      isDoctorsLoading = true;
    }

    appointmentTabError = null;
    doctorsPage = 1;
    doctorsTotalPages = 1;
    isDoctorsLoadingMore = false;
    notifyListeners();

    final Map<String, dynamic>? appointmentResponse =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getActiveAppointment(),
    );

    final Map<String, dynamic>? doctorsResponse =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getAvailableDoctor(
        page: 1,
        limit: 8,
        search: search,
        lat: lat,
        lng: lng,
      ),
    );

    if (appointmentResponse == null || doctorsResponse == null) {
      isAppointmentTabLoading = false;
      isDoctorsLoading = false;
      isDoctorsLoadingMore = false;
      notifyListeners();
      return;
    }

    _handleActiveAppointmentResponse(appointmentResponse);
    _handleAvailableDoctorsResponse(doctorsResponse);

    isAppointmentTabLoading = false;
    isDoctorsLoading = false;
    isDoctorsLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadMoreDoctors({
    String search = "",
    double? lat,
    double? lng,
  }) async {
    if (isDoctorsLoadingMore || !hasMoreDoctors) return;

    final double? requestLat = lat ?? currentLat;
    final double? requestLng = lng ?? currentLng;

    isDoctorsLoadingMore = true;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getAvailableDoctor(
        page: doctorsPage + 1,
        limit: 8,
        search: search,
        lat: requestLat,
        lng: requestLng,
      ),
    );

    if (response == null) {
      isDoctorsLoadingMore = false;
      notifyListeners();
      return;
    }

    if (response["status"] == "success") {
      final List doctorsData = response["data"] ?? [];

      final loadedDoctors = doctorsData
          .whereType<Map<String, dynamic>>()
          .map((e) => DoctorModel.fromJson(e))
          .toList();

      availableDoctors.addAll(loadedDoctors);

      doctorsPage = int.tryParse(response["page"].toString()) ?? doctorsPage;
      doctorsTotalPages =
          int.tryParse(response["totalPages"].toString()) ?? doctorsTotalPages;
    }

    isDoctorsLoadingMore = false;
    notifyListeners();
  }

  void _handleActiveAppointmentResponse(Map<String, dynamic> response) {
    if (response["status"] == "success") {
      final appointmentData = response["data"];

      activeAppointment = appointmentData != null &&
          appointmentData is Map<String, dynamic> &&
          appointmentData.isNotEmpty
          ? AppointmentModel.fromJson(appointmentData)
          : AppointmentModel();

      return;
    }

    activeAppointment = AppointmentModel();
  }

  void _handleAvailableDoctorsResponse(Map<String, dynamic> response) {
    if (response["status"] == "success") {
      final List doctorsData = response["data"] ?? [];

      availableDoctors = doctorsData
          .whereType<Map<String, dynamic>>()
          .map((e) => DoctorModel.fromJson(e))
          .toList();

      doctorsPage = int.tryParse(response["page"].toString()) ?? 1;
      doctorsTotalPages =
          int.tryParse(response["totalPages"].toString()) ?? 1;

      return;
    }

    availableDoctors = [];
    appointmentTabError = response["message"] ?? "Something went wrong";
  }

  void clearAppointmentTabData() {
    activeAppointment = AppointmentModel();
    availableDoctors.clear();

    doctorsPage = 1;
    doctorsTotalPages = 1;

    currentLat = null;
    currentLng = null;

    appointmentTabError = null;
    isAppointmentTabLoading = false;
    isDoctorsLoading = false;
    isDoctorsLoadingMore = false;

    notifyListeners();
  }

  // =========================
  // Appointment Details
  // =========================

  AppointmentModel appointmentDetails = AppointmentModel();

  bool isAppointmentDetailsLoading = false;

  String? appointmentDetailsError;

  Future<void> getAppointmentDetails(String appointmentId) async {
    isAppointmentDetailsLoading = true;
    appointmentDetailsError = null;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getAppointmentDetails(appointmentId),
    );

    if (response == null) {
      isAppointmentDetailsLoading = false;
      notifyListeners();
      return;
    }

    if (response["status"] == "success") {
      appointmentDetails = AppointmentModel.fromJson(response["data"]);
    } else {
      appointmentDetailsError = response["message"] ?? "Something went wrong";
    }

    isAppointmentDetailsLoading = false;
    notifyListeners();
  }

  void clearAppointmentDetails() {
    appointmentDetails = AppointmentModel();
    appointmentDetailsError = null;
    isAppointmentDetailsLoading = false;
    notifyListeners();
  }

  // =========================
  // Doctor Details
  // =========================

  DoctorModel doctorDetails = DoctorModel();
  List<ReviewModel> doctorReviews = [];

  bool isDoctorDetailsLoading = false;

  String? doctorDetailsError;

  Future<void> getDoctorDetails(String doctorId) async {
    isDoctorDetailsLoading = true;
    doctorDetailsError = null;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getDoctorDetails(doctorId),
    );

    if (response == null) {
      isDoctorDetailsLoading = false;
      notifyListeners();
      return;
    }

    if (response["status"] == "success") {
      doctorDetails = DoctorModel.fromJson(response["doctor"]);
      doctorReviews = (response["reviews"] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    } else {
      doctorDetailsError = response["message"] ?? "Something went wrong";
    }

    isDoctorDetailsLoading = false;
    notifyListeners();
  }

  void clearDoctorDetails() {
    doctorDetails = DoctorModel();
    doctorReviews = [];
    doctorDetailsError = null;
    isDoctorDetailsLoading = false;
    notifyListeners();
  }

  // =========================
  // Previous Appointments
  // =========================

  List<PreviousAppointmentModel> previousAppointments = [];

  bool isPreviousAppointmentsLoading = false;
  bool isCancelAppointmentLoading = false;

  String? previousAppointmentsError;
  String? cancelAppointmentError;

  Future<void> getPreviousAppointments() async {
    isPreviousAppointmentsLoading = true;
    previousAppointmentsError = null;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getPreviousAppointments(),
    );

    if (response == null) {
      isPreviousAppointmentsLoading = false;
      notifyListeners();
      return;
    }

    if (response["status"] == "success") {
      previousAppointments = response["data"] ?? [];
    } else {
      previousAppointmentsError =
          response["message"] ?? "Something went wrong";
    }

    isPreviousAppointmentsLoading = false;
    notifyListeners();
  }

  Future<bool> cancelAppointment({
    required String appointmentId,
    required String reason,
  }) async {
    isCancelAppointmentLoading = true;
    cancelAppointmentError = null;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.cancelAppointment(
        appointmentId,
        reason,
      ),
    );

    if (response == null) {
      isCancelAppointmentLoading = false;
      notifyListeners();
      return false;
    }

    if (response["status"] == "success") {
      isCancelAppointmentLoading = false;
      notifyListeners();
      return true;
    }

    cancelAppointmentError = response["message"] ?? "Something went wrong";

    isCancelAppointmentLoading = false;
    notifyListeners();
    return false;
  }

  // =========================
  // Book Appointment
  // =========================

  DoctorModel? bookingDoctor;
  List<PetModel> bookingPets = [];
  List<ScheduledDayModel> bookingAvailableDays = [];
  List<String> bookingAvailableSlots = [];

  bool isBookingDataLoading = false;
  bool isBookAppointmentLoading = false;
  bool isBookingSlotsLoading = false;

  String? bookingDataError;
  String? bookAppointmentError;
  String? bookingSlotsError;

  Future<void> fetchBookAppointmentData(String doctorId) async {
    isBookingDataLoading = true;
    bookingDataError = null;
    bookAppointmentError = null;
    bookingSlotsError = null;
    notifyListeners();

    final Map<String, dynamic>? scheduleResponse =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getDoctorSchedule(doctorId),
    );

    final Map<String, dynamic>? petsResponse =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getPets(),
    );

    if (scheduleResponse == null || petsResponse == null) {
      isBookingDataLoading = false;
      notifyListeners();
      return;
    }

    _handleBookingScheduleResponse(scheduleResponse);
    _handleBookingPetsResponse(petsResponse);

    isBookingDataLoading = false;
    notifyListeners();
  }

  Future<void> fetchBookingSlotsByDate({
    required String doctorId,
    required String date,
  }) async {
    debugPrint("FETCH SLOTS DOCTOR ID => $doctorId");
    debugPrint("FETCH SLOTS DATE => $date");

    isBookingSlotsLoading = true;
    bookingSlotsError = null;
    bookingAvailableSlots = [];
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.getDoctorSlotsByDate(
        doctorId: doctorId,
        date: date,
      ),
    );

    debugPrint("FETCH SLOTS RESPONSE => $response");

    if (response == null) {
      isBookingSlotsLoading = false;
      notifyListeners();
      return;
    }

    if (response["status"] == "success") {
      bookingAvailableSlots = List<String>.from(
        response["slots"] ?? [],
      );
    } else {
      bookingSlotsError = response["message"] ?? "Something went wrong";
      bookingAvailableSlots = [];
    }

    debugPrint("BOOKING AVAILABLE SLOTS AFTER SET => $bookingAvailableSlots");

    isBookingSlotsLoading = false;
    notifyListeners();
  }

  Future<bool> bookAppointment({
    required String petId,
    required String doctorId,
    required String date,
    required String time,
    required String reason,
    required String notes,
  }) async {
    isBookAppointmentLoading = true;
    bookAppointmentError = null;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.bookAppointment(
        petId,
        doctorId,
        date,
        time,
        reason,
        notes,
      ),
    );

    if (response == null) {
      isBookAppointmentLoading = false;
      notifyListeners();
      return false;
    }

    if (response["status"] == "success") {
      isBookAppointmentLoading = false;
      notifyListeners();
      return true;
    }

    bookAppointmentError = response["message"] ?? "Something went wrong";

    isBookAppointmentLoading = false;
    notifyListeners();
    return false;
  }

  void _handleBookingScheduleResponse(Map<String, dynamic> response) {
    if (response["status"] == "success") {
      final data = response["data"];

      bookingDoctor = DoctorModel.fromJson(data["doctor"]);

      bookingAvailableDays = (data["schedual"] as List? ?? [])
          .map((e) => ScheduledDayModel.fromJson(e))
          .toList();

      bookingAvailableSlots = List<String>.from(data["firstDaySlots"] ?? []);

      return;
    }

    bookingDataError = response["message"] ?? "Something went wrong";
  }

  void _handleBookingPetsResponse(Map<String, dynamic> response) {
    if (response["status"] == "success") {
      bookingPets = (response["data"] as List? ?? [])
          .map((e) => PetModel.fromJson(e))
          .toList();

      return;
    }

    bookingDataError = response["message"] ?? "Something went wrong";
  }

  void clearBookingData() {
    bookingDoctor = null;
    bookingPets.clear();
    bookingAvailableDays.clear();
    bookingAvailableSlots.clear();

    bookingDataError = null;
    bookAppointmentError = null;
    bookingSlotsError = null;

    isBookingDataLoading = false;
    isBookAppointmentLoading = false;
    isBookingSlotsLoading = false;

    notifyListeners();
  }

  // =========================
  // Doctor Review
  // =========================

  AppointmentModel? pendingReviewAppointment;

  bool isCheckingPendingReview = false;
  bool isSubmitReviewLoading = false;
  bool isSkipReviewLoading = false;

  String? submitReviewError;
  String? skipReviewError;

  Future<Map<String, dynamic>?> checkPendingDoctorReview() async {
    if (isCheckingPendingReview) return null;

    isCheckingPendingReview = true;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.checkPendingReview(),
    );

    debugPrint("CHECK PENDING RESPONSE => $response");

    isCheckingPendingReview = false;

    if (response == null) {
      notifyListeners();
      return null;
    }

    notifyListeners();

    if (response["status"] == "success") {
      return response["data"];
    }

    return null;
  }

  Future<bool> submitDoctorReview({
    required String appointmentId,
    required int rate,
    required String comment,
  }) async {
    isSubmitReviewLoading = true;
    submitReviewError = null;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.addReview(
        appointmentId: appointmentId,
        rate: rate,
        comment: comment,
      ),
    );

    if (response == null) {
      isSubmitReviewLoading = false;
      notifyListeners();
      return false;
    }

    if (response["status"] == "success") {
      pendingReviewAppointment = null;
      isSubmitReviewLoading = false;
      notifyListeners();
      return true;
    }

    submitReviewError = response["message"] ?? "Something went wrong";

    isSubmitReviewLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> skipDoctorReview({
    required String appointmentId,
  }) async {
    isSkipReviewLoading = true;
    skipReviewError = null;
    notifyListeners();

    final Map<String, dynamic>? response =
    await AuthGuardService.runWithAutoLogout(
          () => appointmentApi.skipReview(
        appointmentId: appointmentId,
      ),
    );

    if (response == null) {
      isSkipReviewLoading = false;
      notifyListeners();
      return false;
    }

    if (response["status"] == "success") {
      pendingReviewAppointment = null;
      isSkipReviewLoading = false;
      notifyListeners();
      return true;
    }

    skipReviewError = response["message"] ?? "Something went wrong";

    isSkipReviewLoading = false;
    notifyListeners();
    return false;
  }
}