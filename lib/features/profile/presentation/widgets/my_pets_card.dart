import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_assets.dart';

class MyPetsCard extends StatelessWidget {
  const MyPetsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                AppAssets.profilePhoto,
                height: 65,
                width: 65,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Max",
              style: AppTextStyles.black16Bold.copyWith(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Dog · 3 years",
              style: AppTextStyles.hint14Regular.copyWith(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
