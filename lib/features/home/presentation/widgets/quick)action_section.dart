import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/home/presentation/widgets/quick_action_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quick Actions", style: AppTextStyles.black16Bold),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                onPressed: () {},
                title: "Booking",
                icon: Icons.calendar_month,
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionButton(
                iconColor: AppColors.warning,
                onPressed: () {},
                title: "Chat",
                icon: Icons.chat_bubble_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionButton(
                iconColor: Colors.deepPurpleAccent,
                onPressed: () {},
                title: "Store",
                icon: Icons.shopping_bag,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
