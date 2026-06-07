import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../auth_field_label.dart';
import '../auth_snackbar.dart';

class IdentityVerificationSection extends StatelessWidget {
  final void Function(File)? onProfilePicSelected;
  final void Function(File)? onIdFrontSelected;
  final void Function(File)? onIdBackSelected;
  final void Function(File)? onIdentityImageSelected;

  const IdentityVerificationSection({
    super.key,
    this.onProfilePicSelected,
    this.onIdFrontSelected,
    this.onIdBackSelected,
    this.onIdentityImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuthFieldLabel(
          title: "Identity Verification",
          icon: Icons.verified_user_outlined,
        ),
        SizedBox(height: 8.h),
        Text(
          "Upload clear documents so we can verify your doctor account safely.",
          style: AppTextStyles.body14Regular.copyWith(
            fontSize: 12.5.sp,
            height: 1.35,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 18.h),
        _UploadDocumentTile(
          title: "Professional License",
          subtitle: "Upload your professional license or official document.",
          onTap: () async {
            File? file = await _pickFile(context);
            if (file != null) onProfilePicSelected?.call(file);
          },
        ),
        SizedBox(height: 12.h),
        _UploadDocumentTile(
          title: "National ID - Front Side",
          subtitle: "Upload a clear front image of your national ID.",
          onTap: () async {
            File? file = await _pickFile(context);
            if (file != null) onIdFrontSelected?.call(file);
          },
        ),
        SizedBox(height: 12.h),
        _UploadDocumentTile(
          title: "National ID - Back Side",
          subtitle: "Upload a clear back image of your national ID.",
          onTap: () async {
            File? file = await _pickFile(context);
            if (file != null) onIdBackSelected?.call(file);
          },
        ),
        SizedBox(height: 12.h),
        _UploadDocumentTile(
          title: "Identity Verification Image",
          subtitle: "Upload an additional image for verification.",
          onTap: () async {
            File? file = await _pickFile(context);
            if (file != null) onIdentityImageSelected?.call(file);
          },
        ),
      ],
    );
  }

  Future<File?> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.isNotEmpty) {
      return File(result.files.first.path!);
    }
    showAuthSnackBar(
      context,
      message: "No file selected",
      type: AuthSnackBarType.error,
    );
    return null;
  }
}

class _UploadDocumentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UploadDocumentTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.045),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 42.h,
              width: 42.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.file_upload_outlined,
                color: AppColors.primary,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: title,
                      style: AppTextStyles.label14Medium.copyWith(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: " *",
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 13.5.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body14Regular.copyWith(
                      fontSize: 12.sp,
                      height: 1.3,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "PNG, JPG or JPEG - max 10MB",
                    style: AppTextStyles.body14Regular.copyWith(
                      fontSize: 11.5.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.primary.withOpacity(0.65),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}