import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetInfoBox extends StatelessWidget {
  final dynamic pet; // هذا هو كائن الـ pet الخاص بك

  const PetInfoBox({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: pet.profilePic.isNotEmpty
                    ? NetworkImage(pet.profilePic)
                    : null,
                child: pet.profilePic.isEmpty ? const Icon(Icons.pets) : null,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${pet.type} • ${pet.breed ?? 'Unknown'}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // الـ Boxes الصغيرة (السن، الوزن، إلخ)
          Row(
            children: [
              _buildSmallBox("Age", "3y"), // استبدليها بـ pet.age إذا توفرت
              _buildSmallBox("Weight", "25kg"),
              _buildSmallBox("Gender", pet.gender),
              _buildSmallBox("Breed", pet.breed ?? "N/A"),
            ],
          ),
          Divider(color: Colors.grey.shade200, height: 30.h),
          // بيانات صاحب الحيوان
          _buildInfoRow(
            Icons.person,
            "Layla Abdullah",
          ), // استبدلي بـ pet.owner.name
          _buildInfoRow(Icons.phone, "+971 50 890 1234"),
        ],
      ),
    );
  }

  Widget _buildSmallBox(String label, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 8.w),
          Text(text),
        ],
      ),
    );
  }
}
