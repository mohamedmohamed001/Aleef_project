import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../notifications/pages/notifications_screen.dart';
import '../../../notifications/presentation/provider/notification_provider.dart';

class ProfileHeader extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const ProfileHeader({
    super.key,
    this.showBackButton = false,
    this.onBackTap,
  });

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

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        final user = session.currentUser;

        if (user == null) {
          return SizedBox(
            height: 275.h,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        return SizedBox(
          height: 275.h,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 245.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(34.r),
                    bottomRight: Radius.circular(34.r),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2D928B),
                      AppColors.primary,
                      Color(0xFF14504B),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.22),
                      blurRadius: 28.r,
                      offset: Offset(0, 14.h),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: -42.h,
                right: -36.w,
                child: _GlowCircle(size: 145.r),
              ),

              Positioned(
                top: 78.h,
                left: -55.w,
                child: _GlowCircle(size: 125.r, opacity: 0.11),
              ),

              Positioned(
                right: 28.w,
                top: 82.h,
                child: Icon(
                  Icons.pets_rounded,
                  size: 64.r,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),

              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (widget.showBackButton) ...[
                            _HeaderBackButton(
                              onTap: widget.onBackTap ??
                                      () => Navigator.pop(context),
                            ),
                            SizedBox(width: 8.w),
                          ],

                          Text(
                            "Profile",
                            style: AppTextStyles.userNameAppbar.copyWith(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const Spacer(),

                          Consumer<NotificationProvider>(
                            builder: (context, notificationProvider, _) {
                              final unreadCount = notificationProvider.unreadCount;

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50.r),
                                  onTap: () async {
                                    if (notificationProvider.unreadCount > 0) {
                                      await notificationProvider.markAllAsRead();
                                    }

                                    if (!context.mounted) return;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const NotificationsScreen(),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 36.r,
                                        width: 36.r,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.16),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.18),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.notifications_none_rounded,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),

                                      if (unreadCount > 0)
                                        Positioned(
                                          right: -4.w,
                                          top: -4.h,
                                          child: Container(
                                            constraints: BoxConstraints(
                                              minWidth: 17.r,
                                              minHeight: 17.r,
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE53935),
                                              borderRadius: BorderRadius.circular(20.r),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.6.w,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                unreadCount > 9 ? '9+' : unreadCount.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8.5.sp,
                                                  fontWeight: FontWeight.w900,
                                                  height: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.20),
                          ),
                        ),
                        child: Row(
                          children: [
                            _HeaderAvatar(image: user.profilePic),

                            SizedBox(width: 13.w),

                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    AppTextStyles.userNameAppbar.copyWith(
                                      fontSize: 18.sp,
                                      height: 1.1,
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  Text(
                                    user.email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    AppTextStyles.hint14Regular.copyWith(
                                      color: Colors.white.withOpacity(0.78),
                                      fontSize: 12.sp,
                                    ),
                                  ),

                                  SizedBox(height: 8.h),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.h,
                                      horizontal: 9.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.verified_rounded,
                                          size: 13.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          "Pet Owner",
                                          style: AppTextStyles.primary12Regular
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: 10.5.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _HeaderBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderBackButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: SizedBox(
          width: 30.r,
          height: 36.r,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final String? image;

  const _HeaderAvatar({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 38.r,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: (image != null && image!.isNotEmpty)
            ? NetworkImage(image!)
            : null,
        child: (image == null || image!.isEmpty)
            ? Icon(
          Icons.person,
          size: 34.r,
          color: Colors.grey,
        )
            : null,
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowCircle({
    required this.size,
    this.opacity = 0.16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}