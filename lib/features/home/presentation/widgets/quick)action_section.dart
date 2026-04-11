import 'package:aleef/features/home/presentation/widgets/quick_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/bottom_nav_provider.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20.w,
      mainAxisSpacing: 20.h,
      childAspectRatio: 1.02,
      children: [
        QuickActionButton(
          onPressed: () {
            context.read<BottomNavProvider>().changeTab(1);
          },
          title: 'Book Appointment',
          icon: Icons.calendar_month_outlined,
          gradientColors: const [
            Color(0xFF2F8A83),
            Color(0xFF1F6E67),
          ],
        ),
        QuickActionButton(
          onPressed: () {
            context.read<BottomNavProvider>().changeTab(2);
          },
          title: 'Chat with Doctor',
          icon: Icons.chat_bubble_outline,
          gradientColors: const [
            Color(0xFFFF8A26),
            Color(0xFFFF6A00),
          ],
        ),
        QuickActionButton(
          onPressed: () {
            context.read<BottomNavProvider>().changeTab(3);
          },
          title: 'Shop Products',
          icon: Icons.shopping_bag_outlined,
          gradientColors: const [
            Color(0xFF9B5CFF),
            Color(0xFF7B3FF2),
          ],
        ),
        QuickActionButton(
          title: 'Add Pet',
          icon: Icons.add_circle_outline,
          gradientColors: const [
            Color(0xFF4B8DFF),
            Color(0xFF2F6FEA),
          ],
        ),
      ],
    );
  }
}