import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'book_empty_message.dart';

class BookTimeSelector extends StatelessWidget {
  final List<String> availableSlots;
  final int selectedSlotIndex;
  final ValueChanged<int> onTimeSelected;

  const BookTimeSelector({
    super.key,
    required this.availableSlots,
    required this.selectedSlotIndex,
    required this.onTimeSelected,
  });

  static const int _previewCount = 8;

  @override
  Widget build(BuildContext context) {
    if (availableSlots.isEmpty) {
      return const BookEmptyMessage(message: "No available slots");
    }

    final int displayCount =
    availableSlots.length > _previewCount ? _previewCount : availableSlots.length;

    final bool hasMore = availableSlots.length > _previewCount;

    final bool hasValidSelectedSlot =
        selectedSlotIndex >= 0 && selectedSlotIndex < availableSlots.length;

    final bool selectedSlotIsHidden =
        hasValidSelectedSlot && selectedSlotIndex >= displayCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            displayCount,
                (index) {
              return _TimeChip(
                slot: availableSlots[index],
                isSelected: selectedSlotIndex == index,
                onTap: () => onTimeSelected(index),
              );
            },
          ),
        ),

        if (selectedSlotIsHidden) ...[
          SizedBox(height: 12.h),
          _SelectedHiddenTimeChip(
            slot: availableSlots[selectedSlotIndex],
            onTap: () => _showAllTimesSheet(context),
          ),
        ],

        if (hasMore) ...[
          SizedBox(height: 12.h),
          Center(
            child: InkWell(
              onTap: () => _showAllTimesSheet(context),
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                    SizedBox(width: 7.w),
                    Text(
                      "View all ${availableSlots.length} times",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: AppColors.primary,
                      size: 19.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showAllTimesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _AllTimesBottomSheet(
          availableSlots: availableSlots,
          selectedSlotIndex: selectedSlotIndex,
          onTimeSelected: (index) {
            Navigator.pop(sheetContext);
            onTimeSelected(index);
          },
        );
      },
    );
  }
}

class _SelectedHiddenTimeChip extends StatelessWidget {
  final String slot;
  final VoidCallback onTap;

  const _SelectedHiddenTimeChip({
    required this.slot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.22),
                blurRadius: 14.r,
                offset: Offset(0, 7.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 17.sp,
              ),
              SizedBox(width: 7.w),
              Text(
                "Selected: $slot",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllTimesBottomSheet extends StatelessWidget {
  final List<String> availableSlots;
  final int selectedSlotIndex;
  final ValueChanged<int> onTimeSelected;

  const _AllTimesBottomSheet({
    required this.availableSlots,
    required this.selectedSlotIndex,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.72,
      ),
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 22.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE1E8E8),
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),

            SizedBox(height: 18.h),

            Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.access_time_filled_rounded,
                    color: AppColors.primary,
                    size: 23.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available times",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1F2A2E),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Choose the best time for your appointment",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7A8A8A),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 22.sp,
                    color: const Color(0xFF6B7A80),
                  ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: List.generate(
                    availableSlots.length,
                        (index) {
                      return _TimeChip(
                        slot: availableSlots[index],
                        isSelected: selectedSlotIndex == index,
                        onTap: () => onTimeSelected(index),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String slot;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 11.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Text(
          slot,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}