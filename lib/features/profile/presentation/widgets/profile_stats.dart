import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "2",
                style: AppTextStyles.primary12Regular.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text("pets", style: AppTextStyles.hint14Regular),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
          ),
          Column(
            children: [
              Text(
                "2",
                style: AppTextStyles.primary12Regular.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text("pets", style: AppTextStyles.hint14Regular),
            ],
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
          ),
          Column(
            children: [
              Text(
                "2",
                style: AppTextStyles.primary12Regular.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text("pets", style: AppTextStyles.hint14Regular),
            ],
          ),
        ],
      ),
    );
  }
}
