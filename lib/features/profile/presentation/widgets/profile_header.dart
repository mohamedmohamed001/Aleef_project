import 'package:aleef/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        final user = session.currentUser;
        debugPrint("ProfileHeader rebuild: ${user?.name}");

        if (user == null) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          width: double.infinity,
          height: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
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
              const SizedBox(height: 10),
              Text(
                user.name,
                style: AppTextStyles.userNameAppbar.copyWith(fontSize: 20),
              ),
              Text(
                user.email,
                style: AppTextStyles.hint14Regular.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Pet Owner",
                  style: AppTextStyles.primary12Regular.copyWith(
                    color: Colors.white,
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