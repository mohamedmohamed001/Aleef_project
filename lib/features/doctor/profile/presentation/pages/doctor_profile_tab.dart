import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/doctor/home/presentation/manager/doctor_profile_provider.dart';
import 'package:aleef/features/doctor/profile/presentation/pages/Edit_doctor_schedule_screen.dart';
import 'package:aleef/features/doctor/profile/presentation/pages/doctor_change_password.dart';
import 'package:aleef/features/doctor/profile/presentation/pages/doctor_edit_profile_screen.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/profile/doctor_profile_empty_view.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/profile/doctor_profile_header_card.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/profile/doctor_profile_info_row.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/profile/doctor_profile_logout_card.dart';
import 'package:aleef/features/doctor/profile/presentation/widgets/profile/doctor_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/session_service.dart';

class DoctorProfileTab extends StatefulWidget {
  const DoctorProfileTab({super.key});

  @override
  State<DoctorProfileTab> createState() => _DoctorProfileTabState();
}

class _DoctorProfileTabState extends State<DoctorProfileTab> {
  bool _isLoggingOut = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DoctorProfileProvider>().fetchDoctorProfile();
    });
  }

  Future<void> _goToEditProfile(
      BuildContext context,
      DoctorProfileProvider provider,
      ) async {
    final isUpdated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorEditProfileScreen(),
      ),
    );

    if (isUpdated == true && context.mounted) {
      provider.fetchDoctorProfile();
    }
  }

  Future<void> _goToEditSchedule(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorEditScheduleScreen(),
      ),
    );
  }

  Future<void> _goToChangePassword(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorChangePasswordScreen(),
      ),
    );
  }

  Future<void> _logout(
      BuildContext context,
      DoctorProfileProvider provider,
      ) async {
    if (provider.isLogoutLoading || _isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    final success = await provider.logOut();

    if (!context.mounted) return;

    if (success) {
      context.read<SessionService>().clearDoctorSession();

      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        AppRoutes.doctorLogin,
            (route) => false,
      );

      return;
    }

    setState(() {
      _isLoggingOut = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Logout failed.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildFullScreenLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: Consumer<DoctorProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading || provider.isLogoutLoading || _isLoggingOut) {
            return _buildFullScreenLoading();
          }

          final doctor = provider.doctorProfile;

          if (doctor == null) {
            return DoctorProfileEmptyView(
              onRetry: provider.fetchDoctorProfile,
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: provider.fetchDoctorProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 24.h),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  child: Column(
                    children: [
                      DoctorProfileHeaderCard(
                        doctor: doctor,
                        onScheduleTap: () => _goToEditSchedule(context),
                        onEditTap: () => _goToEditProfile(context, provider),
                      ),
                      SizedBox(height: 18.h),
                      DoctorProfileSection(
                        title: 'About',
                        icon: Icons.info_outline_rounded,
                        child: Text(
                          doctor.about.trim().isEmpty
                              ? 'No bio available.'
                              : doctor.about,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF3B4444),
                            height: 1.55,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DoctorProfileSection(
                        title: 'Contact Information',
                        icon: Icons.contact_phone_outlined,
                        child: Column(
                          children: [
                            DoctorProfileInfoRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value: doctor.phone.trim().isEmpty
                                  ? 'Not provided'
                                  : doctor.phone,
                            ),
                            SizedBox(height: 14.h),
                            DoctorProfileInfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: doctor.email.trim().isEmpty
                                  ? 'Not provided'
                                  : doctor.email,
                            ),
                          ],
                        ),
                      ),
                      DoctorProfileSection(
                        title: 'Clinic Address',
                        icon: Icons.local_hospital_outlined,
                        child: DoctorProfileInfoRow(
                          icon: Icons.location_on_outlined,
                          label: doctor.city.trim().isEmpty
                              ? 'Clinic location'
                              : doctor.city,
                          value: doctor.address.trim().isEmpty
                              ? 'No clinic address provided.'
                              : doctor.address,
                          maxLines: 4,
                        ),
                      ),
                      DoctorProfileSection(
                        title: 'Account Security',
                        icon: Icons.security_outlined,
                        child: _ChangePasswordTile(
                          onTap: () => _goToChangePassword(context),
                        ),
                      ),
                      DoctorProfileLogoutCard(
                        isLoading: provider.isLogoutLoading,
                        onTap: () => _logout(context, provider),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChangePasswordTile extends StatelessWidget {
  final VoidCallback onTap;

  const _ChangePasswordTile({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFA),
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.10),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2A2E),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Update your account password securely',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7A8A8A),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: const Color(0xFF9AA7A7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}