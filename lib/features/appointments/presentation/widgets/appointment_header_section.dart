import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'appointment_status_chip.dart';

class AppointmentHeaderSection extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String status;
  final String imagePath;

  const AppointmentHeaderSection({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF267D77),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title16SemiBold.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body14Regular.copyWith(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppointmentStatusChip(status: status),
        ],
      ),
    );
  }
}