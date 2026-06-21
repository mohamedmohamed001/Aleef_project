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
  final VoidCallback onProfileTap;

  const HomeTopSection({
    super.key,
    required this.userName,
    required this.profilePic,
    required this.selectedPet,
    required this.onPetTap,
    required this.onAddPetTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final firstName = _getFirstName(userName);
    final greeting = _getGreeting();

    final ImageProvider? profileImage =
    profilePic != null && profilePic!.trim().isNotEmpty
        ? NetworkImage(profilePic!)
        : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            const Color(0xFF1F6F6A),
            const Color(0xFF155E5A),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.r),
          bottomRight: Radius.circular(34.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -82.h,
            right: -54.w,
            child: _GlowCircle(
              size: 195.r,
              opacity: 0.11,
            ),
          ),
          Positioned(
            top: 82.h,
            right: 16.w,
            child: _GlowCircle(
              size: 124.r,
              opacity: 0.07,
            ),
          ),
          Positioned(
            bottom: -44.h,
            left: -54.w,
            child: _GlowCircle(
              size: 126.r,
              opacity: 0.06,
            ),
          ),
          Positioned(
            top: 78.h,
            left: 22.w,
            child: _SmallDot(
              size: 5.5.r,
              opacity: 0.25,
            ),
          ),
          Positioned(
            right: 92.w,
            bottom: 48.h,
            child: _SmallDot(
              size: 7.r,
              opacity: 0.20,
            ),
          ),
          Positioned(
            right: 154.w,
            top: 29.h,
            child: _SmallDot(
              size: 4.5.r,
              opacity: 0.18,
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              18.w,
              topPadding + 7.h,
              18.w,
              17.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderTopRow(
                  greeting: greeting,
                  firstName: firstName,
                  profileImage: profileImage,
                  onProfileTap: onProfileTap,
                ),

                SizedBox(height: 18.h),

                _HeaderMessage(
                  selectedPet: selectedPet,
                ),

                SizedBox(height: 12.h),

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

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String _getFirstName(String name) {
    if (name.trim().isEmpty) return "Guest";

    final first = name.trim().split(' ').first;
    if (first.isEmpty) return "Guest";

    return first[0].toUpperCase() + first.substring(1);
  }
}

class _HeaderTopRow extends StatelessWidget {
  final String greeting;
  final String firstName;
  final ImageProvider? profileImage;
  final VoidCallback onProfileTap;

  const _HeaderTopRow({
    required this.greeting,
    required this.firstName,
    required this.profileImage,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingPill(
                text: "$greeting 👋",
              ),
              SizedBox(height: 6.h),
              Text(
                firstName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -0.65,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 10.w),

        _GlassCircle(
          child: const NotificationButton(),
        ),

        SizedBox(width: 9.w),

        GestureDetector(
          onTap: onProfileTap,
          behavior: HitTestBehavior.opaque,
          child: _ProfileAvatar(profileImage: profileImage),
        ),
      ],
    );
  }
}

class _GreetingPill extends StatelessWidget {
  final String text;

  const _GreetingPill({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white.withOpacity(0.90),
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _HeaderMessage extends StatelessWidget {
  final PetModel? selectedPet;

  const _HeaderMessage({
    required this.selectedPet,
  });

  @override
  Widget build(BuildContext context) {
    final hasPet = selectedPet != null;
    final petName = selectedPet?.name.trim() ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3.5.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.32),
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasPet && petName.isNotEmpty
                    ? "Care for $petName"
                    : "Start pet care",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -0.35,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                hasPet
                    ? "Book visits, ask ALEEF, and track records."
                    : "Add your first pet to unlock reminders and visits.",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassCircle extends StatelessWidget {
  final Widget child;

  const _GlassCircle({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.r,
      height: 45.r,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
          width: 1.w,
        ),
      ),
      child: Center(child: child),
    );
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
      width: 47.r,
      height: 47.r,
      padding: EdgeInsets.all(2.3.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.14),
        border: Border.all(
          color: Colors.white.withOpacity(0.26),
          width: 1.1.w,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.16),
        backgroundImage: profileImage,
        child: profileImage == null
            ? Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: 23.sp,
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

class _SmallDot extends StatelessWidget {
  final double size;
  final double opacity;

  const _SmallDot({
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