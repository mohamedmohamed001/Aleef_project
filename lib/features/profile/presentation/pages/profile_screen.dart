import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

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
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const ProfileStats(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        "My Pets",
                        style: AppTextStyles.black16Bold.copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      const Text(
                        "+Add Pet",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Expanded(child: MyPetsCard()),
                      SizedBox(width: 12),
                      Expanded(child: MyPetsCard()),
                      SizedBox(width: 12),
                      Expanded(child: MyPetsCard()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ProfileOptionsCard(),
                  const SizedBox(height: 24),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Account Settings",
                      style: AppTextStyles.titleLarge.copyWith(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _openEditProfile,
                    child: const AccountSettingItem(),
                  ),
                  const SizedBox(height: 24),
                  const Text("ALEEF v1.0.0 · Pet Healthcare Platform"),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}