import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorInfoLine extends StatelessWidget {
  final IconData icon;
  final String value;

  const DoctorInfoLine({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final text = value.trim().isEmpty || value == 'null' ? '-' : value.trim();

    return Row(
      children: [
        Container(
          width: 22.r,
          height: 22.r,
          decoration: const BoxDecoration(
            color: Color(0xFFF3F7F7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 12.r,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}