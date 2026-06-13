import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_confirmed_appointments_provider.dart';
import '../widgets/confirmed_appointment_card.dart';

class ConfirmedAppointmentsScreen extends StatefulWidget {
  const ConfirmedAppointmentsScreen({super.key});

  @override
  State<ConfirmedAppointmentsScreen> createState() =>
      _ConfirmedAppointmentsScreenState();
}

class _ConfirmedAppointmentsScreenState
    extends State<ConfirmedAppointmentsScreen> {
  // إضافة خيار "All" للقائمة
  final List<String> _filterOptions = ['All Appointments'];
  String? _selectedDate;

  @override
  void initState() {
    super.initState();
    // ملء القائمة بالتواريخ السبعة القادمة
    for (int i = 0; i < 7; i++) {
      _filterOptions.add(
        DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: i))),
      );
    }
    _selectedDate = _filterOptions[0]; // البدء بـ "All Appointments"

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorConfirmedAppointmentsProvider>().getAppointmentsByDate(
        _selectedDate!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20.h, top: 40.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(32.r),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Confirmed Appointments',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Consumer<DoctorConfirmedAppointmentsProvider>(
                    builder: (context, provider, _) => Text(
                      '${provider.appointments.length} total appointments',
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // نقل الـ Dropdown داخل الهيدر الأخضر
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDate,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.calendar_month,
                        color: AppColors.primary,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    items: _filterOptions.map((val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val == 'All Appointments'
                              ? val
                              : DateFormat(
                                  'EEEE, dd/MM',
                                ).format(DateFormat('dd-MM-yyyy').parse(val)),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedDate = val);
                      context
                          .read<DoctorConfirmedAppointmentsProvider>()
                          .getAppointmentsByDate(val!);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DoctorConfirmedAppointmentsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading)
                  return const Center(child: CircularProgressIndicator());
                if (provider.appointments.isEmpty)
                  return const Center(child: Text("No appointments"));
                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: provider.appointments.length,
                  itemBuilder: (context, index) => ConfirmedAppointmentCard(
                    appointment: provider.appointments[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
