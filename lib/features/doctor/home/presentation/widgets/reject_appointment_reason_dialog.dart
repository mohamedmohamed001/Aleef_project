import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class RejectAppointmentReasonDialog extends StatefulWidget {
  const RejectAppointmentReasonDialog({super.key});

  @override
  State<RejectAppointmentReasonDialog> createState() =>
      _RejectAppointmentReasonDialogState();
}

class _RejectAppointmentReasonDialogState
    extends State<RejectAppointmentReasonDialog> {
  final TextEditingController _reasonController = TextEditingController();

  String? _errorText;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _reasonController.text.trim();

    if (reason.isEmpty) {
      setState(() {
        _errorText = 'Cancellation reason is required';
      });
      return;
    }

    Navigator.pop(context, reason);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF5F5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.event_busy_rounded,
                        color: const Color(0xffE5484D),
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Cancel Appointment',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff172121),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please write the reason for cancelling this appointment.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.4,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                TextField(
                  controller: _reasonController,
                  maxLines: 4,
                  minLines: 3,
                  cursorColor: AppColors.primary,
                  textInputAction: TextInputAction.newline,
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Example: Doctor is unavailable...',
                    errorText: _errorText,
                    filled: true,
                    fillColor: const Color(0xffF8FAFA),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: Color(0xffE8EEEE),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.4,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: Color(0xffE5484D),
                        width: 1.2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: Color(0xffE5484D),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black54,
                            side: const BorderSide(
                              color: Color(0xffE8EEEE),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xffE5484D),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}