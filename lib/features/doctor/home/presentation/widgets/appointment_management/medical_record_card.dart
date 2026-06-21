import 'dart:io';

import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/labeled_field.dart';
import 'package:aleef/features/doctor/home/presentation/widgets/appointment_management/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalRecordCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController conditionController;
  final TextEditingController descController;
  final TextEditingController chatDaysController;

  final List<File> selectedAttachments;
  final VoidCallback onPickAttachments;
  final ValueChanged<int> onRemoveAttachment;

  const MedicalRecordCard({
    super.key,
    required this.titleController,
    required this.conditionController,
    required this.descController,
    required this.chatDaysController,
    required this.selectedAttachments,
    required this.onPickAttachments,
    required this.onRemoveAttachment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE8EAEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Medical Record',
            icon: Icons.medical_information_outlined,
          ),

          SizedBox(height: 18.h),

          LabeledField(
            label: 'Record Title',
            hint: 'e.g., Annual Checkup 2026',
            controller: titleController,
          ),

          SizedBox(height: 16.h),

          LabeledField(
            label: 'Condition',
            hint: 'e.g., Healthy, Skin Allergy, etc.',
            controller: conditionController,
          ),

          SizedBox(height: 16.h),

          LabeledField(
            label: 'Description',
            hint: 'Detailed notes about the examination and findings...',
            controller: descController,
            maxLines: 5,
          ),

          SizedBox(height: 16.h),

          LabeledField(
            label: 'Chat Expiry Days',
            hint: 'e.g., 3',
            controller: chatDaysController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.chat_bubble_outline_rounded,
          ),

          SizedBox(height: 18.h),

          Text(
            'Attachments',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF001533),
            ),
          ),

          SizedBox(height: 10.h),

          InkWell(
            onTap: onPickAttachments,
            borderRadius: BorderRadius.circular(18.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 24.h,
                horizontal: 14.w,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  width: 1.2.w,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.upload_rounded,
                    size: 34.sp,
                    color: const Color(0xFF98A2B3),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    selectedAttachments.isEmpty
                        ? 'Click to upload files'
                        : 'Add more files',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF526174),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Images or PDF files',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF98A2B3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (selectedAttachments.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Column(
              children: List.generate(
                selectedAttachments.length,
                    (index) {
                  final file = selectedAttachments[index];
                  final fileName = file.path.split('/').last;
                  final isPdf = fileName.toLowerCase().endsWith('.pdf');

                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFE1E5EA),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            color: isPdf
                                ? const Color(0xFFFFE8E8)
                                : const Color(0xFFE9F8F6),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            isPdf
                                ? Icons.picture_as_pdf_rounded
                                : Icons.image_rounded,
                            color: isPdf
                                ? const Color(0xFFE5484D)
                                : const Color(0xFF267D77),
                            size: 21.sp,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: Text(
                            fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              color: const Color(0xFF001533),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () => onRemoveAttachment(index),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 20.sp,
                            color: const Color(0xFFE5484D),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}