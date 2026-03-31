import 'package:aleef/features/auth/data/services/auth_api_service.dart';
import 'package:aleef/features/profile/models/profile_option_item.dart';
import 'package:flutter/material.dart';
import '';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class AccountSettingItem extends StatelessWidget {
  const AccountSettingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
            bgColor: Color.fromRGBO(38, 125, 119, 0.08),
          ),
          const SizedBox(height: 28),
           ProfileOptionItem(
            onTap: () {} ,
            title: "Change Password",
            icon: Icons.lock_outlined,
            iconColor: Color.fromRGBO(59, 130, 246, 1),
            bgColor: Color.fromRGBO(59, 130, 246, 0.08),
          ),
          const SizedBox(height: 28),
          ProfileOptionItem(
            title: "Logout",
            icon: Icons.logout_outlined,
            iconColor: AppColors.error,
            bgColor: const Color.fromRGBO(220, 38, 38, 0.08),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false); // ❌ Cancel
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true); // ✅ Confirm
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );

              // 👇 لو المستخدم وافق
              if (shouldLogout == true) {
                final response = await AuthApiService().logOut();

                if (response == true) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                        (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
