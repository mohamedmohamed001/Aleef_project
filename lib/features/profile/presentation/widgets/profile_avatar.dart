import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  final String? image;

  const ProfileAvatar({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 48.r,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: (image != null && image!.isNotEmpty)
            ? NetworkImage(image!)
            : null,
        child: (image == null || image!.isEmpty)
            ? Icon(
          Icons.person,
          size: 40.r,
          color: Colors.grey,
        )
            : null,
      ),
    );
  }
}