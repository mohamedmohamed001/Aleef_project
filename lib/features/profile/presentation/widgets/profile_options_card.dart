import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/profile_option_item.dart';

class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          const ProfileOptionItem(
            title: "My Appointments",
            icon: Icons.calendar_month_outlined,
            iconColor: Color(0xFF4A8CFF),
            bgColor: Color(0xFFEAF2FF),
          ),

          SizedBox(height: 20.h),

          const ProfileOptionItem(
            title: "My Orders",
            icon: Icons.inventory_2_outlined,
            iconColor: Color(0xFFFF7A1A),
            bgColor: Color(0xFFFFF1E8),
          ),

          SizedBox(height: 20.h),

          const ProfileOptionItem(
            title: "Settings",
            icon: Icons.settings_outlined,
            iconColor: Color(0xFF8B5CF6),
            bgColor: Color(0xFFF1ECFF),
          ),
        ],
      ),
    );
  }
}