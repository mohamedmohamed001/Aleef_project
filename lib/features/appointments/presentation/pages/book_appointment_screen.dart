import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/sound_helper.dart';
import '../../data/models/doctor_model.dart';
import '../../data/models/scheduled_day_model.dart';
import '../../services/appointment_api.dart';
import '../widgets/booking_success_view.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;

  const BookAppointmentScreen({super.key, required this.doctorId});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DoctorModel? doctor;
  List<PetModel?> pets=[];
  List<ScheduledDayModel> availableDays = [];
  List<String> availableSlots = [];
  String? petId;
  bool isSubmitted=false;

  bool isLoading = true;
  int selectedIndex = 0;
  int selectedSlotIndex = 0;
  bool isButtonLoading=false;

  @override
  void initState() {
    super.initState();
    getDoctorSchedule(widget.doctorId);
    getPets();
  }
  @override
  void dispose() {
    reasonController.dispose();
    notesController.dispose();
    super.dispose();
  }
Future<void> getPets() async{
    final response= await AppointmentApi().getPets();
    if (response["status"] == "success") {
      final data = response["data"];


      if (!mounted) return;
      setState(() {


        pets = (data as List<dynamic>).map((e) => PetModel.fromJson(e)).toList();
      });
    } else if (response["status"] == "unauthorized") {
      setState(() {
        isLoading = false;
      });

      SecureStorageService().deleteToken();
      SecureStorageService().deleteUser();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    } else {


      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }

}
  Future<void> getDoctorSchedule(String doctorId) async {
    final response = await AppointmentApi().getDoctorSchedule(doctorId);



    if (response["status"] == "success") {
      final data = response["data"];

      if (!mounted) return;

      setState(() {
        doctor = DoctorModel.fromJson(data["doctor"]);

        availableDays = (data["schedual"] as List<dynamic>)
            .map((e) => ScheduledDayModel.fromJson(e))
            .toList();

        availableSlots = List<String>.from(data["firstDaySlots"] ?? []);



        isLoading = false;
      });
    } else if (response["status"] == "unauthorized") {
      setState(() {
        isLoading = false;
      });

      SecureStorageService().deleteToken();
      SecureStorageService().deleteUser();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } else {


      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> bookAppointment() async {
    setState(() {
      isButtonLoading = true;
    });
    final selectedDay = availableDays[selectedIndex];
    final selectedSlot = availableSlots[selectedSlotIndex];
    final time = selectedSlot;
    final reason = reasonController.text;
    final notes = notesController.text;
    if (petId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select your pet"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isButtonLoading = false;
      });
      return;
    }
    if (reason.isEmpty || reason.length < 5 || reason.length > 100) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid reason"),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        isButtonLoading = false;
      });

      return; // 👈 مهم جدًا
    }
    final response = await AppointmentApi().bookAppointment(
      petId!,
      widget.doctorId,
      selectedDay.date,
      time,
      reason,
      notes,
    );
    if(response ["status"]=="success"){
      if (!mounted) return;
      setState(() {
        isButtonLoading = false;
        isSubmitted=true;
      });
    }else if(response["status"]=="unauthorized"){
      setState(() {
        isButtonLoading = false;
      });
      SecureStorageService().deleteToken();
      SecureStorageService().deleteUser();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }else{
      setState(() {
        isButtonLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if(isSubmitted){
      return BookingSuccessView();
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    doctor?.profilePic ?? '',
                    width: 65.w,
                    height: 65.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 65.w,
                        height: 65.w,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 28.sp,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor?.name ?? "",
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 20.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),

                          Text(
                            doctor?.specialization ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text("${doctor?.rating ?? 0}"),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.location_on_outlined,
                            size: 16.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              doctor?.city ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${doctor?.appointmentFee ?? 0} \EGP",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary, // أو Colors.green
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            Text(
              "Select Date",
              style: AppTextStyles.titleLarge.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),

            SizedBox(
              height: 90.h,
              child: availableDays.isEmpty
                  ? Center(
                      child: Text(
                        "No available days",
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableDays.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final item = availableDays[index];
                        final isSelected = selectedIndex == index;

                        final parts = item.display.split(" ");
                        final day = parts.isNotEmpty ? parts[0] : "";
                        final date = parts.length >= 3 ? parts[2] : "";

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 60.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade400,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(height: 24.h),

            Text(
              "Available Time Slots",
              style: AppTextStyles.titleLarge.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),

            availableSlots.isEmpty
                ? Center(
                    child: Text(
                      "No available slots",
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    ),
                  )
                : SizedBox(
                    height: 110.h,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: availableSlots.length > 8
                          ? 8
                          : availableSlots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 1.9,
                      ),
                      itemBuilder: (context, index) {
                        final slot = availableSlots[index];
                        final isSelected = selectedSlotIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSlotIndex = index;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade400,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 3.h),
                                ),
                              ],
                            ),
                            child: Text(
                              slot,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 24.h),
            Text(
              "Booking Details",
              style: AppTextStyles.titleLarge.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField(
              hint: Text("Select your pet"),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text("Select your pet"),
                ),
                ...pets.map((pet) {
                  return DropdownMenuItem(
                    value: pet?.id.toString() ?? "",
                    child: Text(pet?.name ?? ""),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  petId = value;
                });
              },
            ),
            SizedBox(height: 12.h),
            Text("Reason for Visit"),
            SizedBox(height: 12.h),
            TextFormField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: "e.g. Annual checkup, vaccination...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text("Additional Notes (optional)"),
            SizedBox(height: 12.h,),
            TextFormField(
              controller:notesController,
              decoration: InputDecoration(
                hintText: "Any additional info for the doctor...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24.h,),
            ElevatedButton(
                onPressed: isButtonLoading == true? null:
                    () {
              bookAppointment();

            }, child: isButtonLoading == true ? CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.sp,
            ) :
            Text("Book Appointment")),
            SizedBox(height: 24.h,)
          ],
        ),
      ),
    );
  }
}
