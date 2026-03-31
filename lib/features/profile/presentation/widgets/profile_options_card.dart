import 'package:flutter/material.dart';

import '../../models/profile_option_item.dart';


class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        children: [
          ProfileOptionItem(
            title: "My Appointments",
            icon: Icons.calendar_month_outlined,
            iconColor: Color(0xFF4A8CFF),
            bgColor: Color(0xFFEAF2FF),
          ),
          SizedBox(height: 28),
          ProfileOptionItem(
            title: "My Orders",
            icon: Icons.inventory_2_outlined,
            iconColor: Color(0xFFFF7A1A),
            bgColor: Color(0xFFFFF1E8),
          ),
          SizedBox(height: 28),
          ProfileOptionItem(
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