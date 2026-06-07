import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        bottom: 12.h,
      ),
      child: Container(
        height: 72.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36.r),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.075),
              blurRadius: 24.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Row(
          children: [
            _NavItem(
              index: 0,
              icon: FontAwesomeIcons.house,
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
            ),
            _NavItem(
              index: 1,
              icon: FontAwesomeIcons.calendarDays,
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
            ),
            _NavItem(
              index: 2,
              icon: FontAwesomeIcons.comment,
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
            ),
            _NavItem(
              index: 3,
              icon: FontAwesomeIcons.bagShopping,
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
            ),
            _NavItem(
              index: 4,
              icon: FontAwesomeIcons.paw,
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final FaIconData icon;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          height: double.infinity,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            width: isSelected ? 48.r : 44.r,
            height: isSelected ? 48.r : 44.r,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.26),
                  blurRadius: 14.r,
                  offset: Offset(0, 7.h),
                ),
              ]
                  : [],
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              scale: isSelected ? 1.04 : 1.0,
              child: Center(
                child: FaIcon(
                  icon,
                  size: 18.sp,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF9A9A9A),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}