import 'package:aleef/features/auth/data/services/auth_api_service.dart';
import 'package:aleef/features/profile/models/profile_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
          title: Text(
            "Logout",
            style: AppTextStyles.black16Bold.copyWith(
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: AppTextStyles.body14Regular.copyWith(
              height: 1.4,
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Logout failed, please try again"),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(12.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
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
            icon: Icons.edit_rounded,
            iconColor: AppColors.success,
            bgColor: AppColors.success.withOpacity(0.09),
          ),

          const _OptionDivider(),

          ProfileOptionItem(
            onTap: () {},
            title: "Change Password",
            icon: Icons.lock_rounded,
            iconColor: AppColors.info,
            bgColor: AppColors.info.withOpacity(0.09),
          ),

          const _OptionDivider(),

          ProfileOptionItem(
            title: "Logout",
            icon: Icons.logout_rounded,
            iconColor: AppColors.error,
            bgColor: AppColors.error.withOpacity(0.09),
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

class _OptionDivider extends StatelessWidget {
  const _OptionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 62.w),
      child: Divider(
        height: 18.h,
        thickness: 1,
        color: AppColors.border.withOpacity(0.8),
      ),
    );
  }
}