import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/chat_model.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = chat.unreadCount > 0;

    final String imageUrl = chat.person.profilePic.trim();

    final String name = chat.person.name.trim().isEmpty
        ? 'Doctor'
        : chat.person.name.trim();

    final bool hasLastText =
        chat.lastMessage?.text.trim().isNotEmpty == true;

    final bool hasLastImage =
        chat.lastMessage?.image != null &&
            chat.lastMessage!.image!.trim().isNotEmpty;

    final String lastMessage = hasLastText
        ? chat.lastMessage!.text.trim()
        : hasLastImage
        ? 'Photo'
        : 'No message yet';

    final bool isLastMessageImageOnly = !hasLastText && hasLastImage;

    final String time = chat.lastMessage != null
        ? _formatTime(chat.lastMessage!.createdAt)
        : '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(13.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: hasUnread
                  ? AppColors.primary.withOpacity(0.14)
                  : Colors.black.withOpacity(0.035),
              width: hasUnread ? 1.2.w : 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 13.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Row(
            children: [
              _ChatAvatar(
                imageUrl: imageUrl,
                name: name,
                hasUnread: hasUnread,
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: _ChatInfo(
                  name: name,
                  lastMessage: lastMessage,
                  time: time,
                  hasUnread: hasUnread,
                  isLastMessageImageOnly: isLastMessageImageOnly,
                ),
              ),

              if (hasUnread) ...[
                SizedBox(width: 9.w),
                _UnreadBadge(count: chat.unreadCount),
              ] else ...[
                SizedBox(width: 7.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xffB5BABC),
                  size: 22.sp,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return '1d';
    if (diff.inDays < 7) return '${diff.inDays}d';

    return '${date.day}/${date.month}';
  }
}

class _ChatAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool hasUnread;

  const _ChatAvatar({
    required this.imageUrl,
    required this.name,
    required this.hasUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xffF3F4F6),
            border: Border.all(
              color: hasUnread
                  ? AppColors.primary.withOpacity(0.20)
                  : Colors.transparent,
              width: 1.2.w,
            ),
          ),
          child: ClipOval(
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return _AvatarPlaceholder(name: name);
              },
            )
                : _AvatarPlaceholder(name: name),
          ),
        ),

        if (hasUnread)
          Positioned(
            right: 0,
            bottom: 2.h,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                color: AppColors.primary,
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

class _ChatInfo extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool hasUnread;
  final bool isLastMessageImageOnly;

  const _ChatInfo({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.hasUnread,
    required this.isLastMessageImageOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title16SemiBold.copyWith(
                  fontSize: 15.5.sp,
                  fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),

            if (time.isNotEmpty) ...[
              SizedBox(width: 8.w),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: hasUnread
                      ? AppColors.primary
                      : const Color(0xff9CA3AF),
                  fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ],
        ),

        SizedBox(height: 7.h),

        if (isLastMessageImageOnly)
          Row(
            children: [
              Icon(
                Icons.photo_rounded,
                size: 15.sp,
                color: hasUnread
                    ? AppColors.primary
                    : const Color(0xff6B7280),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: hasUnread
                        ? const Color(0xff374151)
                        : const Color(0xff6B7280),
                    height: 1.25,
                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
        else
          Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: hasUnread
                  ? const Color(0xff374151)
                  : const Color(0xff6B7280),
              height: 1.25,
              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
      ],
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 22.r,
        minHeight: 22.r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  final String name;

  const _AvatarPlaceholder({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final String firstLetter =
    name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return Container(
      color: AppColors.primary.withOpacity(0.08),
      child: Center(
        child: Text(
          firstLetter,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}