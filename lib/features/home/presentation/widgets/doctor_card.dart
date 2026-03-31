import 'package:aleef/features/home/presentation/widgets/Interactive_rating_stars.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
                AssetImage(AppAssets.profilePhoto),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. Amira Hassan",
                  style: AppTextStyles.black16Bold.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "General Veterinarian",
                  style: AppTextStyles.hint14Regular.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                const DoctorRatingWidget(),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 253, 244, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Available",
                  style: AppTextStyles.primary12Regular.copyWith(
                    color: const Color.fromRGBO(22, 163, 74, 1),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 32,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(38, 125, 119, 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                  ),
                  onPressed: () {},
                  child: Text(
                    "Book ",
                    style: AppTextStyles.primary12Regular,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
