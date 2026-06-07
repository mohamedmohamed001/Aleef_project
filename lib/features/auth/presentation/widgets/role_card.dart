import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleCard extends StatelessWidget {
  final String role;
  final String roleDescription;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.roleDescription,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(18.r),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: isSelected ? 2.w : 1.w,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(.15),
                blurRadius: 18.r,
                spreadRadius: 1.r,
                offset: Offset(0, 8.h),
              ),
            ]
                : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(.12)
                      : Colors.teal.withOpacity(.08),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  icon,
                  size: 32.sp,
                  color: isSelected ? AppColors.primary : Colors.teal,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role,
                      style: AppTextStyles.black16Bold.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      roleDescription,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade400,
                    width: 2.w,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
