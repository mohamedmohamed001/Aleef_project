import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DoctorRatingWidget extends StatelessWidget {
  const DoctorRatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 4.9,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 24,
      itemPadding: const EdgeInsets.symmetric(horizontal: 2),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Color(0xFF2E8B7F),
      ),
      onRatingUpdate: (rating) {
      },
    );
  }
}