import 'package:flutter/material.dart';

import 'doctor_card.dart';

class RecommendedDoctors extends StatelessWidget {
  const RecommendedDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) {
        return SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        return DoctorCard();
      },
    )
      ;
  }
}
