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

  static const List<_BottomNavItemData> _items = [
    _BottomNavItemData(
      icon: FontAwesomeIcons.house,
      label: 'Home',
    ),
    _BottomNavItemData(
      icon: FontAwesomeIcons.calendarDays,
      label: 'Book',
    ),
    _BottomNavItemData(
      icon: FontAwesomeIcons.commentDots,
      label: 'Chat',
    ),
    _BottomNavItemData(
      icon: FontAwesomeIcons.bagShopping,
      label: 'Store',
    ),
    _BottomNavItemData(
      icon: FontAwesomeIcons.paw,
      label: 'Pets',
    ),
  ];

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
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34.r),
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
          children: List.generate(_items.length, (index) {
            final bool isSelected = selectedIndex == index;

            return Expanded(
              flex: isSelected ? 16 : 10,
              child: _NavItem(
                isSelected: isSelected,
                item: _items[index],
                onTap: () => onItemSelected(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final bool isSelected;
  final _BottomNavItemData item;
  final VoidCallback onTap;

  const _NavItem({
    required this.isSelected,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 6.w : 0,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    width: isSelected ? 34.r : 40.r,
                    height: isSelected ? 34.r : 40.r,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFF4F7F7),
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.24),
                          blurRadius: 12.r,
                          offset: Offset(0, 6.h),
                        ),
                      ]
                          : [],
                    ),
                    child: Center(
                      child: FaIcon(
                        item.icon,
                        size: isSelected ? 14.sp : 16.sp,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF8A9696),
                      ),
                    ),
                  ),

                  if (isSelected) ...[
                    SizedBox(width: 5.w),
                    Text(
                      item.label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        height: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItemData {
  final FaIconData icon;
  final String label;

  const _BottomNavItemData({
    required this.icon,
    required this.label,
  });
}