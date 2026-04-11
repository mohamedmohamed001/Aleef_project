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
      minimum: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 74.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(38.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 18.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Row(
          children: [
            _NavBarItem(
              index: 0,
              title: "Home",
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
              iconBuilder: (isSelected) => FaIcon(
                FontAwesomeIcons.house,
                size: 18.sp,
                color: isSelected ? Colors.white : const Color(0xFF8D8D8D),
              ),
            ),
            _NavBarItem(
              index: 1,
              title: "Booking",
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
              iconBuilder: (isSelected) => FaIcon(
                FontAwesomeIcons.calendarDays,
                size: 18.sp,
                color: isSelected ? Colors.white : const Color(0xFF8D8D8D),
              ),
            ),
            _NavBarItem(
              index: 2,
              title: "Chatbot",
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
              iconBuilder: (isSelected) => FaIcon(
                FontAwesomeIcons.comment,
                size: 18.sp,
                color: isSelected ? Colors.white : const Color(0xFF8D8D8D),
              ),
            ),
            _NavBarItem(
              index: 3,
              title: "Shop",
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
              iconBuilder: (isSelected) => FaIcon(
                FontAwesomeIcons.bagShopping,
                size: 18.sp,
                color: isSelected ? Colors.white : const Color(0xFF8D8D8D),
              ),
            ),
            _NavBarItem(
              index: 4,
              title: "Profile",
              selectedIndex: selectedIndex,
              onTap: onItemSelected,
              iconBuilder: (isSelected) => FaIcon(
                FontAwesomeIcons.paw,
                size: 18.sp,
                color: isSelected ? Colors.white : const Color(0xFF8D8D8D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Widget Function(bool isSelected) iconBuilder;
  final String title;

  const _NavBarItem({
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.iconBuilder,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              width: isSelected ? 42.r : 38.r,
              height: isSelected ? 42.r : 38.r,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: iconBuilder(isSelected),
              ),
            ),
            SizedBox(height: 2.h),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  title,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    height: 1,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF8D8D8D),
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