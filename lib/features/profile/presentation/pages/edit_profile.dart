import 'package:aleef/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../manager/edit_profile_provider.dart';
import '../widgets/edit_profile/edit_profile_avatar_section.dart';
import '../widgets/edit_profile/edit_profile_form_section.dart';
import '../widgets/edit_profile/edit_profile_save_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<EditProfileProvider>().init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final editProvider = context.watch<EditProfileProvider>();
    final user = context.watch<UserProvider>().user ??
        editProvider.session.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      body: Stack(
        children: [
          const _EditProfileBackground(),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 0),
                  child: _EditProfileTopBar(
                    onBack: () => Navigator.pop(context),
                  ),
                ),

                SizedBox(height: 22.h),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 22.h),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            22.h,
                            16.w,
                            20.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.07),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.055),
                                blurRadius: 24.r,
                                offset: Offset(0, 12.h),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Update your profile",
                                style: TextStyle(
                                  color: const Color(0xFF1F2937),
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.4,
                                ),
                              ),

                              SizedBox(height: 6.h),

                              Text(
                                "Keep your personal information up to date.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.35,
                                ),
                              ),

                              SizedBox(height: 22.h),

                              EditProfileAvatarSection(
                                selectedImage: editProvider.selectedImage,
                                profileImageUrl: user?.profilePic,
                                onPickImage: () {
                                  editProvider.showImageSourceSheet(context);
                                },
                                onRemoveImage: () {
                                  editProvider.removeProfilePhoto(context);
                                },
                              ),

                              SizedBox(height: 30.h),

                              EditProfileFormSection(
                                nameController: editProvider.nameController,
                                phoneController: editProvider.phoneController,
                              ),

                              SizedBox(height: 30.h),

                              EditProfileSaveButton(
                                isLoading: editProvider.isLoading,
                                onPressed: editProvider.isLoading
                                    ? null
                                    : () {
                                  editProvider.saveChanges(context);
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 18.h),

                        Text(
                          "Your changes will appear across ALEEF.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileBackground extends StatelessWidget {
  const _EditProfileBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2D928B),
                AppColors.primary,
                Color(0xFF14504B),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(38.r),
              bottomRight: Radius.circular(38.r),
            ),
          ),
        ),
        Positioned(
          top: -56.h,
          right: -42.w,
          child: _SoftCircle(
            size: 165.r,
            opacity: 0.14,
          ),
        ),
        Positioned(
          top: 112.h,
          left: -60.w,
          child: _SoftCircle(
            size: 135.r,
            opacity: 0.10,
          ),
        ),
        Positioned(
          top: 92.h,
          right: 34.w,
          child: Icon(
            Icons.person_rounded,
            color: Colors.white.withOpacity(0.08),
            size: 88.r,
          ),
        ),
      ],
    );
  }
}

class _EditProfileTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const _EditProfileTopBar({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: onBack,
            child: SizedBox(
              width: 42.r,
              height: 42.r,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 21.sp,
              ),
            ),
          ),
        ),

        SizedBox(width: 8.w),

        Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),

        const Spacer(),

        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
            ),
          ),
          child: Icon(
            Icons.edit_rounded,
            color: Colors.white,
            size: 19.sp,
          ),
        ),
      ],
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _SoftCircle({
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