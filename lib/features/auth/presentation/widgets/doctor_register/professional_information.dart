import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../auth_field_label.dart';
import '../custom_text_form.dart';

class ProfessionalInformation extends StatefulWidget {
  final TextEditingController licenseController;
  final TextEditingController cityController;
  final TextEditingController addressController;

  final String? Function(String?)? licenseValidator;
  final String? Function(String?)? cityValidator;
  final String? Function(String?)? addressValidator;

  const ProfessionalInformation({
    super.key,
    required this.licenseController,
    required this.cityController,
    required this.addressController,
    this.licenseValidator,
    this.cityValidator,
    this.addressValidator,
  });

  @override
  State<ProfessionalInformation> createState() =>
      _ProfessionalInformationState();
}

class _ProfessionalInformationState extends State<ProfessionalInformation> {
  String? selectedSpecialization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthFieldLabel(
          title: "License Number",
          icon: Icons.shield_outlined,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: widget.licenseController,
          hintText: "Enter your license number",
          iconPrefix: Icons.shield_outlined,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: widget.licenseValidator,
        ),

        SizedBox(height: 16.h),

        const AuthFieldLabel(
          title: "Specialization",
          icon: Icons.medical_services_outlined,
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          initialValue: selectedSpecialization,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
            size: 24.sp,
          ),
          dropdownColor: Colors.white,
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Select your specialization",
            hintStyle: AppTextStyles.body14Regular.copyWith(
              color: AppColors.hint,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              Icons.medical_services_outlined,
              color: AppColors.hint,
              size: 22.sp,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 15.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.border.withOpacity(0.9),
                width: 1.2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.2.w,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.5.w,
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: "Dermatology",
              child: Text("Dermatology"),
            ),
            DropdownMenuItem(
              value: "Surgery",
              child: Text("Surgery"),
            ),
            DropdownMenuItem(
              value: "Dentistry",
              child: Text("Dentistry"),
            ),
            DropdownMenuItem(
              value: "General Care",
              child: Text("General Care"),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedSpecialization = value;
            });
          },
        ),

        SizedBox(height: 16.h),

        const AuthFieldLabel(
          title: "City",
          icon: Icons.location_on_outlined,
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: widget.cityController,
          hintText: "Enter your city",
          iconPrefix: Icons.location_on_outlined,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: widget.cityValidator,
        ),

        SizedBox(height: 16.h),

        const AuthFieldLabel(
          title: "Address",
          icon: Icons.home_outlined,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: widget.addressController,
          minLines: 3,
          maxLines: 4,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.done,
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          validator: widget.addressValidator,
          decoration: InputDecoration(
            hintText: "Enter your clinic or practice address",
            hintStyle: AppTextStyles.body14Regular.copyWith(
              color: AppColors.hint,
              fontSize: 14.sp,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 56.h),
              child: Icon(
                Icons.home_outlined,
                color: AppColors.hint,
                size: 22.sp,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.border.withOpacity(0.9),
                width: 1.2.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5.w,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.2.w,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}