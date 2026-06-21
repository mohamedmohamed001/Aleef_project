import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatHeader extends StatelessWidget {
  final String profilePic;
  final String name;
  final String status;
  final VoidCallback? onBackTap;
  final VoidCallback? onMoreTap;
  final bool showMoreButton;
  final bool showOnlineDot;

  const ChatHeader({
    super.key,
    required this.profilePic,
    required this.name,
    required this.status,
    this.onBackTap,
    this.onMoreTap,
    this.showMoreButton = false,
    this.showOnlineDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = profilePic.trim();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 16.r,
            offset: Offset(0, 7.h),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _HeaderActionButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBackTap ?? () => Navigator.pop(context),
            ),

            SizedBox(width: 11.w),

            _HeaderAvatar(
              imageUrl: imageUrl,
              showOnlineDot: showOnlineDot,
            ),

            SizedBox(width: 11.w),

            Expanded(
              child: _HeaderTitle(
                name: name,
                status: status,
                showOnlineDot: showOnlineDot,
              ),
            ),

            if (showMoreButton) ...[
              SizedBox(width: 8.w),
              _HeaderActionButton(
                icon: Icons.more_horiz_rounded,
                iconSize: 22.sp,
                onTap: onMoreTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double? iconSize;

  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.16),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38.r,
          height: 38.r,
          child: Icon(
            icon,
            color: Colors.white,
            size: iconSize ?? 17.sp,
          ),
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final String imageUrl;
  final bool showOnlineDot;

  const _HeaderAvatar({
    required this.imageUrl,
    required this.showOnlineDot,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 46.r,
          height: 46.r,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
              width: 2.w,
            ),
          ),
          child: ClipOval(
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const _HeaderAvatarPlaceholder();
              },
            )
                : const _HeaderAvatarPlaceholder(),
          ),
        ),

        if (showOnlineDot)
          Positioned(
            right: 1.w,
            bottom: 1.h,
            child: Container(
              width: 13.r,
              height: 13.r,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  final String name;
  final String status;
  final bool showOnlineDot;

  const _HeaderTitle({
    required this.name,
    required this.status,
    required this.showOnlineDot,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasStatus = status.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.trim().isEmpty ? 'Chat' : name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.8.sp,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),

        if (hasStatus) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              if (showOnlineDot) ...[
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF25D366),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
              ],
              Expanded(
                child: Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _HeaderAvatarPlaceholder extends StatelessWidget {
  const _HeaderAvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.18),
      child: Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }
}