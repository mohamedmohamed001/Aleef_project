import 'package:aleef/core/widgets/app_snack_bar.dart';
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
      barrierDismissible: !isLoading,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 28.r,
                  offset: Offset(0, 14.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74.r,
                  height: 74.r,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 35.sp,
                  ),
                ),

                SizedBox(height: 18.h),

                Text(
                  "Logout?",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.black16Bold.copyWith(
                    color: const Color(0xFF1F2A2E),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Are you sure you want to logout from your ALEEF account?",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body14Regular.copyWith(
                    color: const Color(0xFF6B7A80),
                    fontSize: 13.5.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 24.h),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFFE1E8E8),
                              width: 1.2.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.r),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: const Color(0xFF3B4444),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.r),
                            ),
                          ),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      return;
    }

    AppSnackBar.error(
      context,
      message: "Logout failed, please try again",
    );
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
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.userChangePassword);
            },
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