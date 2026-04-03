import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppointmentsHeader extends StatelessWidget {
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onPreviousTap;

  const AppointmentsHeader({
    super.key,
    this.notificationCount = 3,
    this.onNotificationTap,
    this.onPreviousTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      color: const Color(0xFFF7F8FA),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 LEFT TEXT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Appointments",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title16SemiBold.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Manage your vet visits",
                    style: AppTextStyles.body14Regular.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// 🔔 NOTIFICATION BUTTON
          InkWell(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4F4),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      top: -10,
                      right: -8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3B30),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF7F8FA),
                            width: 2.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$notificationCount',
                          style: AppTextStyles.title16SemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// 🟢 PREVIOUS BUTTON
          InkWell(
            onTap: onPreviousTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 41,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4F4),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                "Previous",
                style: AppTextStyles.title16SemiBold.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}