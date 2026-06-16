import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CutCircle extends StatelessWidget {
  const CutCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 30.w,
      decoration: const BoxDecoration(
        color: Color(0xFFEEF4F3),
        shape: BoxShape.circle,
      ),
    );
  }
}
