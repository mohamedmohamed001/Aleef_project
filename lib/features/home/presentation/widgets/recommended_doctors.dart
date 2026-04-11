import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        return const DoctorCard();
      },
    );
  }
}