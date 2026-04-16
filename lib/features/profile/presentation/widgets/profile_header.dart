import 'package:aleef/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late final SessionService session;

  @override
  void initState() {
    super.initState();
    session = getIt<SessionService>();
    _init();
  }

  Future<void> _init() async {
    final storage = getIt<SecureStorageService>();
    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        final user = session.currentUser;

        if (user == null) {
          return SizedBox(
            height: 300.h,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Container(
          width: double.infinity,
          height: 300.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF267D77), Color(0xFF1A5550), Colors.white],
              stops: [0.0, 0.65, 1.0],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileAvatar(image: user.profilePic),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.userNameAppbar.copyWith(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.hint14Regular.copyWith(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4.h,
                  horizontal: 10.w,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Pet Owner",
                  style: AppTextStyles.primary12Regular.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}