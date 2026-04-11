import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/account_setting_item.dart';
import '../widgets/my_pets_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_options_card.dart';
import '../widgets/profile_stats.dart';
import 'edit_profile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => ProfileTabState();
}

class ProfileTabState extends State<ProfileTab> {
  final ScrollController _scrollController = ScrollController();

  Future<void> scrollToTop({bool animated = true}) async {
    if (!_scrollController.hasClients) return;

    if (animated) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(0);
    }
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfile(),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {});

      await scrollToTop();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToTop(animated: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const ProfileHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  const ProfileStats(),
                  SizedBox(height: 24.h),

                  Row(
                    children: [
                      Text(
                        "My Pets",
                        style: AppTextStyles.black16Bold.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "+Add Pet",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      const Expanded(child: MyPetsCard()),
                      SizedBox(width: 12.w),
                      const Expanded(child: MyPetsCard()),
                      SizedBox(width: 12.w),
                      const Expanded(child: MyPetsCard()),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  const ProfileOptionsCard(),

                  SizedBox(height: 24.h),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Account Settings",
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: _openEditProfile,
                    child: const AccountSettingItem(),
                  ),

                  SizedBox(height: 24.h),

                  const Text(
                    "ALEEF v1.0.0 · Pet Healthcare Platform",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}