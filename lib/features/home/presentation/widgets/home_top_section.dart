import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'notification_button.dart';
import 'selected_pet_summary_card.dart';

class HomeTopSection extends StatelessWidget {
  final String userName;
  final String? profilePic;
  final PetModel? selectedPet;
  final VoidCallback onPetTap;
  final VoidCallback onAddPetTap;

  const HomeTopSection({
    super.key,
    required this.userName,
    required this.profilePic,
    required this.selectedPet,
    required this.onPetTap,
    required this.onAddPetTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final firstName = _getFirstName(userName);

    final ImageProvider? profileImage =
    profilePic != null && profilePic!.trim().isNotEmpty
        ? NetworkImage(profilePic!)
        : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36.r),
          bottomRight: Radius.circular(36.r),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -70.h,
            right: -46.w,
            child: _GlowCircle(
              size: 190.r,
              opacity: 0.08,
            ),
          ),
          Positioned(
            top: 118.h,
            right: 26.w,
            child: _GlowCircle(
              size: 130.r,
              opacity: 0.06,
            ),
          ),
          Positioned(
            bottom: 42.h,
            left: -58.w,
            child: _GlowCircle(
              size: 115.r,
              opacity: 0.05,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              18.w,
              topPadding + 8.h,
              18.w,
              18.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Morning 👋",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.88),
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              firstName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.05,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    const NotificationButton(),
                    SizedBox(width: 12.w),
                    _ProfileAvatar(profileImage: profileImage),
                  ],
                ),

                SizedBox(height: 22.h),

                Text(
                  "How can we help your pet today?",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.94),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    letterSpacing: -0.3,
                  ),
                ),

                SizedBox(height: 14.h),

                SelectedPetSummaryCard(
                  pet: selectedPet,
                  onTap: onPetTap,
                  onAddPetTap: onAddPetTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFirstName(String name) {
    if (name.trim().isEmpty) return "Guest";

    final first = name.trim().split(' ').first;
    if (first.isEmpty) return "Guest";

    return first[0].toUpperCase() + first.substring(1);
  }
}

class _ProfileAvatar extends StatelessWidget {
  final ImageProvider? profileImage;

  const _ProfileAvatar({
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.r,
      height: 52.r,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.35),
          width: 1.4.w,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.18),
        backgroundImage: profileImage,
        child: profileImage == null
            ? Icon(
          Icons.person,
          color: Colors.white,
          size: 27.sp,
        )
            : null,
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}