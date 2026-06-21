import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/confirmed_appointment_model.dart';

class PetInfoBox extends StatelessWidget {
  final AppointmentPetModel pet;
  final AppointmentOwnerModel owner;

  const PetInfoBox({
    super.key,
    required this.pet,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    final String petName =
    pet.name.trim().isEmpty ? 'Pet Name' : pet.name.trim();

    final String petType =
    pet.type.trim().isEmpty ? 'Pet' : pet.type.trim();

    final String petBreed =
    pet.breed?.trim().isNotEmpty == true ? pet.breed!.trim() : 'N/A';

    final String petImage = pet.profilePic?.trim() ?? '';

    final String ownerName =
    owner.name.trim().isEmpty ? 'Owner name not provided' : owner.name.trim();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: petImage.isNotEmpty
                    ? NetworkImage(petImage)
                    : null,
                child: petImage.isEmpty
                    ? Icon(
                  Icons.pets,
                  size: 26.sp,
                  color: Colors.grey,
                )
                    : null,
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      petName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      '$petType • $petBreed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              _buildSmallBox('Type', petType),
              _buildSmallBox('Breed', petBreed),
            ],
          ),

          Divider(
            color: Colors.grey.shade200,
            height: 30.h,
          ),

          _buildInfoRow(
            Icons.person,
            ownerName,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBox(String label, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
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
          Icon(
            icon,
            size: 16.sp,
            color: Colors.grey,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}