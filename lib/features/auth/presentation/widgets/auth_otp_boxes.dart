import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthOtpBoxes extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function({
  required String value,
  required int index,
  }) onChanged;
  final void Function({
  required KeyEvent event,
  required int index,
  }) onKeyEvent;

  const AuthOtpBoxes({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == 5 ? 0 : 8.w,
            ),
            child: Focus(
              onKeyEvent: (_, event) {
                onKeyEvent(event: event, index: index);
                return KeyEventResult.ignored;
              },
              child: TextFormField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction:
                index == 5 ? TextInputAction.done : TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: AppTextStyles.heading24Bold.copyWith(
                  fontSize: 20.sp,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: AppColors.primary.withOpacity(0.045),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.10),
                      width: 1.2.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.6.w,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 1.2.w,
                    ),
                  ),
                ),
                onChanged: (value) {
                  onChanged(value: value, index: index);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
