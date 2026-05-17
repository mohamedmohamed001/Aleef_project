import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_assets.dart';
import 'doctor_card.dart';

class RecommendedDoctors extends StatelessWidget {
  const RecommendedDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) {
        return SizedBox(height: 12.h);
      },
      itemBuilder: (context, index) {
        return DoctorCard(
          name: "Dr. Amira Hassan",
          specialty: "General Veterinarian",
          imagePath: AppAssets.profilePhoto,
          statusText: "Available",
          buttonText: "Book",
          isAvailable: true,
          onBookPressed: () {
            print("Book pressed");
          },
        );
      },
    );
  }
}