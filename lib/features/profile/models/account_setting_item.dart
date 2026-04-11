import 'package:aleef/features/auth/data/services/auth_api_service.dart';
import 'package:aleef/features/profile/models/profile_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class AccountSettingItem extends StatefulWidget {
  const AccountSettingItem({super.key});

  @override
  State<AccountSettingItem> createState() => _AccountSettingItemState();
}

class _AccountSettingItemState extends State<AccountSettingItem> {
  bool isLoading = false;

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    setState(() {
      isLoading = true;
    });

    final response = await AuthApiService().logOut();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (response == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileOptionItem(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
            title: "Edit Profile",
            icon: Icons.edit,
            iconColor: AppColors.success,
            bgColor: const Color.fromRGBO(38, 125, 119, 0.08),
          ),

          SizedBox(height: 20.h),

          ProfileOptionItem(
            onTap: () {},
            title: "Change Password",
            icon: Icons.lock_outlined,
            iconColor: const Color.fromRGBO(59, 130, 246, 1),
            bgColor: const Color.fromRGBO(59, 130, 246, 0.08),
          ),

          SizedBox(height: 20.h),

          ProfileOptionItem(
            title: "Logout",
            icon: Icons.logout_outlined,
            iconColor: AppColors.error,
            bgColor: const Color.fromRGBO(220, 38, 38, 0.08),
            onTap: isLoading ? null : _handleLogout,
            trailing: isLoading
                ? SizedBox(
              width: 20.r,
              height: 20.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AppColors.error,
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }
}