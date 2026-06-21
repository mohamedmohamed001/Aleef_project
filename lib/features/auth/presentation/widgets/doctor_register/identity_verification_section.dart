import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class IdentityVerificationSection extends StatelessWidget {
  final File? selectedProfilePic;
  final File? selectedNationalIdFront;
  final File? selectedNationalIdBack;
  final File? selectedIdentityVerificationImage;

  final ValueChanged<File> onProfilePicSelected;
  final ValueChanged<File> onIdFrontSelected;
  final ValueChanged<File> onIdBackSelected;
  final ValueChanged<File> onIdentityImageSelected;

  const IdentityVerificationSection({
    super.key,
    required this.selectedProfilePic,
    required this.selectedNationalIdFront,
    required this.selectedNationalIdBack,
    required this.selectedIdentityVerificationImage,
    required this.onProfilePicSelected,
    required this.onIdFrontSelected,
    required this.onIdBackSelected,
    required this.onIdentityImageSelected,
  });

  Future<void> _pickImage({
    required BuildContext context,
    required ValueChanged<File> onSelected,
  }) async {
    final source = await _showImageSourceSheet(context);

    if (source == null) return;

    try {
      final picker = ImagePicker();

      final pickedImage = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (pickedImage == null) return;

      onSelected(File(pickedImage.path));
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not pick image. Please try again.'),
        ),
      );
    }
  }

  Future<ImageSource?> _showImageSourceSheet(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 22.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.r),
            ),
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
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Upload Document',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Choose an image from gallery or take a new photo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Expanded(
                      child: _SourceButton(
                        icon: Icons.photo_library_outlined,
                        title: 'Gallery',
                        subtitle: 'Choose image',
                        onTap: () {
                          Navigator.pop(context, ImageSource.gallery);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _SourceButton(
                        icon: Icons.camera_alt_outlined,
                        title: 'Camera',
                        subtitle: 'Take photo',
                        onTap: () {
                          Navigator.pop(context, ImageSource.camera);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UploadDocumentCard(
          title: 'Professional Profile Picture',
          subtitle: 'Upload your professional license or official document.',
          file: selectedProfilePic,
          onTap: () {
            _pickImage(
              context: context,
              onSelected: onProfilePicSelected,
            );
          },
        ),
        SizedBox(height: 12.h),
        _UploadDocumentCard(
          title: 'National ID - Front Side',
          subtitle: 'Upload a clear front image of your national ID.',
          file: selectedNationalIdFront,
          onTap: () {
            _pickImage(
              context: context,
              onSelected: onIdFrontSelected,
            );
          },
        ),
        SizedBox(height: 12.h),
        _UploadDocumentCard(
          title: 'National ID - Back Side',
          subtitle: 'Upload a clear back image of your national ID.',
          file: selectedNationalIdBack,
          onTap: () {
            _pickImage(
              context: context,
              onSelected: onIdBackSelected,
            );
          },
        ),
        SizedBox(height: 12.h),
        _UploadDocumentCard(
          title: 'Identity Verification Image',
          subtitle: 'Upload an additional image for verification.',
          file: selectedIdentityVerificationImage,
          onTap: () {
            _pickImage(
              context: context,
              onSelected: onIdentityImageSelected,
            );
          },
        ),
      ],
    );
  }
}

class _UploadDocumentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final File? file;
  final VoidCallback onTap;

  const _UploadDocumentCard({
    required this.title,
    required this.subtitle,
    required this.file,
    required this.onTap,
  });

  bool get isSelected => file != null;

  String get fileName {
    if (file == null) return '';
    final path = file!.path;
    final parts = path.split(Platform.pathSeparator);
    return parts.isNotEmpty ? parts.last : path;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.07)
                : const Color(0xFFF8FAFA),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.55)
                  : AppColors.border.withOpacity(0.75),
              width: 1.1.w,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.35)
                        : AppColors.border.withOpacity(0.55),
                  ),
                ),
                child: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.upload_rounded,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: title,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isSelected ? fileName : subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        height: 1.25,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      isSelected
                          ? 'Image selected successfully'
                          : 'PNG, JPG or JPEG - max 10MB',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.85)
                            : AppColors.textSecondary.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                isSelected
                    ? Icons.edit_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: isSelected ? 19.sp : 15.sp,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFA),
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 15.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: AppColors.border.withOpacity(0.75),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 44.r,
                width: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}