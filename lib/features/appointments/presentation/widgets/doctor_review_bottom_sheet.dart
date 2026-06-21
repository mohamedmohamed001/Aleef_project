import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/appointments/data/models/pending_review_model.dart';
import 'package:aleef/features/appointments/presentation/provider/appointment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DoctorReviewBottomSheet extends StatefulWidget {
  final PendingReviewModel pendingReview;

  const DoctorReviewBottomSheet({
    super.key,
    required this.pendingReview,
  });

  @override
  State<DoctorReviewBottomSheet> createState() =>
      _DoctorReviewBottomSheetState();
}

class _DoctorReviewBottomSheetState extends State<DoctorReviewBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  int _rate = 5;

  String get _rateTitle {
    if (_rate <= 2) return "Sorry about that";
    if (_rate == 3) return "Thanks for your feedback";
    return "Glad it went well";
  }

  String get _commentHint {
    if (_rate <= 2) return "Tell us what went wrong...";
    if (_rate == 3) return "Tell us how it could be better...";
    return "What did you like most?";
  }

  Color get _rateColor {
    if (_rate <= 2) return const Color(0xFFE5484D);
    if (_rate == 3) return const Color(0xFFE1A514);
    return AppColors.primary;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    FocusScope.of(context).unfocus();

    final success = await context.read<AppointmentProvider>().submitDoctorReview(
      appointmentId: widget.pendingReview.appointmentId,
      rate: _rate,
      comment: _commentController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          content: const Text(
            "Review submitted successfully",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      final error = context.read<AppointmentProvider>().submitReviewError;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFE5484D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          content: Text(
            error ?? "Something went wrong",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppointmentProvider>().isSubmitReviewLoading;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 28,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              SizedBox(height: 22.h),

              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.18),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 43.r,
                  backgroundColor: AppColors.primary.withOpacity(0.10),
                  backgroundImage: widget.pendingReview.doctorImage.isNotEmpty
                      ? NetworkImage(widget.pendingReview.doctorImage)
                      : null,
                  child: widget.pendingReview.doctorImage.isEmpty
                      ? Icon(
                    Icons.person_rounded,
                    size: 42.sp,
                    color: AppColors.primary,
                  )
                      : null,
                ),
              ),

              SizedBox(height: 14.h),

              Text(
                "How was your visit?",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1F2933),
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                "Rate Dr. ${widget.pendingReview.doctorName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 5.h),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  widget.pendingReview.specialization,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  _rateTitle,
                  key: ValueKey(_rateTitle),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _rateColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;
                  final selected = starValue <= _rate;

                  return GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                      setState(() {
                        _rate = starValue;
                      });
                    },
                    child: AnimatedScale(
                      scale: selected ? 1.12 : 1.0,
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutBack,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 160),
                          child: Icon(
                            selected
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            key: ValueKey("$starValue-$selected"),
                            size: 42.sp,
                            color: selected
                                ? const Color(0xFFFFB800)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: 18.h),

              TextField(
                controller: _commentController,
                minLines: 3,
                maxLines: 5,
                enabled: !isLoading,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: _commentHint,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF6F8F8),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.45),
                      width: 1.4,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rateColor,
                    disabledBackgroundColor: _rateColor.withOpacity(0.55),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    elevation: 0,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: isLoading
                        ? Row(
                      key: const ValueKey("loading"),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.3,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Submitting...",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                        : Row(
                      key: const ValueKey("normal"),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Submit Review",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              Consumer<AppointmentProvider>(
                builder: (context, provider, _) {
                  final isSkipLoading = provider.isSkipReviewLoading;

                  return TextButton(
                    onPressed: isLoading || isSkipLoading
                        ? null
                        : () async {
                      final success = await context
                          .read<AppointmentProvider>()
                          .skipDoctorReview(
                        appointmentId: widget.pendingReview.appointmentId,
                      );

                      if (!mounted) return;

                      if (success) {
                        Navigator.pop(context);
                      } else {
                        final error =
                            context.read<AppointmentProvider>().skipReviewError;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error ?? "Something went wrong"),
                          ),
                        );
                      }
                    },
                    child: isSkipLoading
                        ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey.shade500,
                      ),
                    )
                        : Text(
                      "Skip for now",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}