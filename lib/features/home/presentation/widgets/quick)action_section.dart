import 'package:aleef/features/home/presentation/widgets/quick_action_button.dart';
import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.05,
      children: [
        QuickActionButton(
          title: 'Book Appointment',
          icon: Icons.calendar_month_outlined,
          gradientColors: const [
            Color(0xFF2F8A83),
            Color(0xFF1F6E67),
          ],
        ),
        QuickActionButton(
          title: 'Chat with Doctor',
          icon: Icons.chat_bubble_outline,
          gradientColors: const [
            Color(0xFFFF8A26),
            Color(0xFFFF6A00),
          ],
        ),
        QuickActionButton(
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