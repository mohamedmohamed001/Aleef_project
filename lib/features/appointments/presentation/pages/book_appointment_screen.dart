import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/appointment_provider.dart';
import '../widgets/book_appointment/book_big_card.dart';
import '../widgets/book_appointment/book_bottom_summary_bar.dart';
import '../widgets/book_appointment/book_date_selector.dart';
import '../widgets/book_appointment/book_doctor_hero_card.dart';
import '../widgets/book_appointment/book_pet_selector.dart';
import '../widgets/book_appointment/book_reason_fields.dart';
import '../widgets/book_appointment/book_review_card.dart';
import '../widgets/book_appointment/book_time_selector.dart';
import '../widgets/booking_success_view.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;

  const BookAppointmentScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? selectedPetId;

  bool isSubmitted = false;

  int selectedDateIndex = 0;
  int selectedSlotIndex = 0;

  late AppointmentProvider _appointmentProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().fetchBookAppointmentData(
        widget.doctorId,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appointmentProvider = context.read<AppointmentProvider>();
  }

  @override
  void dispose() {
    reasonController.dispose();
    notesController.dispose();
    _appointmentProvider.clearBookingData();
    super.dispose();
  }

  String? _getSelectedPetName(List<dynamic> pets) {
    for (final pet in pets) {
      if (pet.id.toString() == selectedPetId) {
        return pet.name ?? "Your pet";
      }
    }

    return null;
  }

  Future<void> _bookAppointment() async {
    final provider = context.read<AppointmentProvider>();

    final validationMessage = _validateBooking(provider);

    if (validationMessage != null) {
      _showError(validationMessage);
      return;
    }

    final reason = reasonController.text.trim();
    final notes = notesController.text.trim();

    final selectedDay = provider.bookingAvailableDays[selectedDateIndex];
    final selectedSlot = provider.bookingAvailableSlots[selectedSlotIndex];

    final success = await provider.bookAppointment(
      petId: selectedPetId!,
      doctorId: widget.doctorId,
      date: selectedDay.date,
      time: selectedSlot,
      reason: reason,
      notes: notes,
    );

    if (!mounted) return;

    if (success) {
      setState(() => isSubmitted = true);
      return;
    }

    _showError(provider.bookAppointmentError ?? "Something went wrong");
  }

  String? _validateBooking(AppointmentProvider provider) {
    if (selectedPetId == null || selectedPetId!.isEmpty) {
      return "Please select your pet";
    }

    if (provider.bookingAvailableDays.isEmpty) {
      return "No available days";
    }

    if (selectedDateIndex < 0 ||
        selectedDateIndex >= provider.bookingAvailableDays.length) {
      return "Please select a valid day";
    }

    if (provider.bookingAvailableSlots.isEmpty) {
      return "No available slots for this day";
    }

    if (selectedSlotIndex < 0 ||
        selectedSlotIndex >= provider.bookingAvailableSlots.length) {
      return "Please select a valid time";
    }

    final reason = reasonController.text.trim();

    if (reason.isEmpty) {
      return "Please enter the appointment reason";
    }

    if (reason.length < 5) {
      return "Reason must be at least 5 characters";
    }

    if (reason.length > 100) {
      return "Reason must be less than 100 characters";
    }

    return null;
  }

  Future<void> _onDateSelected({
    required int index,
    required AppointmentProvider provider,
  }) async {
    if (index < 0 || index >= provider.bookingAvailableDays.length) return;

    final selectedDate = provider.bookingAvailableDays[index].date;

    setState(() {
      selectedDateIndex = index;
      selectedSlotIndex = -1;
    });

    await context.read<AppointmentProvider>().fetchBookingSlotsByDate(
      doctorId: widget.doctorId,
      date: selectedDate,
    );

    if (!mounted) return;

    final updatedSlots =
        context.read<AppointmentProvider>().bookingAvailableSlots;

    setState(() {
      selectedSlotIndex = updatedSlots.isNotEmpty ? 0 : -1;
    });
  }

  void _onTimeSelected(int index) {
    setState(() {
      selectedSlotIndex = index;
    });
  }

  void _onPetSelected(String value) {
    setState(() {
      selectedPetId = value;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  String _getSelectedDayText(AppointmentProvider provider) {
    final availableDays = provider.bookingAvailableDays;

    if (availableDays.isNotEmpty &&
        selectedDateIndex >= 0 &&
        selectedDateIndex < availableDays.length) {
      return availableDays[selectedDateIndex].display;
    }

    return "Not selected";
  }

  String _getSelectedTimeText(AppointmentProvider provider) {
    final availableSlots = provider.bookingAvailableSlots;

    if (availableSlots.isNotEmpty &&
        selectedSlotIndex >= 0 &&
        selectedSlotIndex < availableSlots.length) {
      return availableSlots[selectedSlotIndex];
    }

    return "Not selected";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, provider, child) {
        final doctor = provider.bookingDoctor;
        final pets = provider.bookingPets;
        final availableDays = provider.bookingAvailableDays;
        final availableSlots = provider.bookingAvailableSlots;

        if (provider.isBookingDataLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9F9),
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (isSubmitted) {
          return const BookingSuccessView();
        }

        if (provider.bookingDataError != null) {
          return _BookingErrorView(
            message: provider.bookingDataError!,
          );
        }

        final selectedDayText = _getSelectedDayText(provider);
        final selectedTimeText = _getSelectedTimeText(provider);
        final selectedPetName = _getSelectedPetName(pets);

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F9),
          appBar: AppBar(
            title: const Text("Book Appointment"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF7F9F9),
            foregroundColor: Colors.black,
          ),
          bottomNavigationBar: BookBottomSummaryBar(
            fee: "${doctor?.appointmentFee ?? 0} EGP",
            isLoading: provider.isBookAppointmentLoading,
            onPressed: _bookAppointment,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 120.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookDoctorHeroCard(
                  image: doctor?.profilePic ?? "",
                  name: doctor?.name ?? "",
                  specialization: doctor?.specialization ?? "",
                  city: doctor?.city ?? "",
                  rating: "${doctor?.rating ?? 0}",
                ),
                SizedBox(height: 18.h),
                BookBigCard(
                  emoji: "🐾",
                  title: "Pet",
                  value: selectedPetName ?? "Choose your pet",
                  child: BookPetSelector(
                    pets: pets,
                    selectedPetId: selectedPetId,
                    onPetSelected: _onPetSelected,
                  ),
                ),
                SizedBox(height: 14.h),
                BookBigCard(
                  emoji: "📅",
                  title: "Date",
                  value: selectedDayText,
                  child: BookDateSelector(
                    availableDays: availableDays,
                    selectedIndex: selectedDateIndex,
                    onDateSelected: (index) => _onDateSelected(
                      index: index,
                      provider: provider,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                BookBigCard(
                  emoji: "⏰",
                  title: "Time",
                  value: selectedTimeText,
                  child: provider.isBookingSlotsLoading
                      ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    child: Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                      : BookTimeSelector(
                    availableSlots: availableSlots,
                    selectedSlotIndex: selectedSlotIndex,
                    onTimeSelected: _onTimeSelected,
                  ),
                ),
                SizedBox(height: 14.h),
                BookBigCard(
                  emoji: "📝",
                  title: "Reason",
                  value: "Tell the doctor what happened",
                  child: BookReasonFields(
                    reasonController: reasonController,
                    notesController: notesController,
                  ),
                ),
                SizedBox(height: 14.h),
                BookReviewCard(
                  pet: selectedPetName ?? "Not selected",
                  date: selectedDayText,
                  time: selectedTimeText,
                  fee: "${doctor?.appointmentFee ?? 0} EGP",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BookingErrorView extends StatelessWidget {
  final String message;

  const _BookingErrorView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        title: const Text("Book Appointment"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}