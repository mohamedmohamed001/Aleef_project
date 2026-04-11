import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorSearchField extends StatelessWidget {
  final Function(String)? onChanged;

  const DoctorSearchField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: "Search doctors...",
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),

        prefixIcon: Icon(
          Icons.search,
          size: 20,
          color: Colors.grey.shade600,
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
    );
  }
}