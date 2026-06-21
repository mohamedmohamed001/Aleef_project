import 'package:aleef/core/routing/app_routes.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/notifications/data/models/app_notification_model.dart';
import 'package:aleef/features/notifications/presentation/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().getNotifications();
    });
  }

  void _openNotification(
      BuildContext context,
      AppNotificationModel notification,
      ) {
    context.read<NotificationProvider>().markAsRead(notification.id);

    if (notification.type == 'appointment') {
      final appointmentId = notification.data?['appointmentId'];

      if (appointmentId == null) return;

      Navigator.pushNamed(
        context,
        AppRoutes.appointmentUserDetails,
        arguments: {
          'appointmentId': appointmentId,
          'showActions': false,
        },
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime.toLocal());

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'appointment':
        return Icons.calendar_month_rounded;
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'chat_message':
        return Icons.chat_bubble_rounded;
      default:
        return Icons.notifications_active_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingNotifications) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (provider.notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 78.r,
                      height: 78.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.primary,
                        size: 38.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'New updates about appointments, orders, and chats will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.4,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () {
              return context.read<NotificationProvider>().getNotifications();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              itemCount: provider.notifications.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];

                return InkWell(
                  onTap: () => _openNotification(context, notification),
                  borderRadius: BorderRadius.circular(18.r),
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: notification.isRead
                          ? Colors.white
                          : AppColors.primary.withOpacity(0.045),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: notification.isRead
                            ? const Color(0xFFE5E7EB)
                            : AppColors.primary.withOpacity(0.28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14.r,
                          offset: Offset(0, 6.h),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getNotificationIcon(notification.type),
                            color: AppColors.primary,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: notification.isRead
                                            ? FontWeight.w700
                                            : FontWeight.w900,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    _formatTime(notification.createdAt),
                                    style: TextStyle(
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                notification.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  height: 1.35,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!notification.isRead) ...[
                          SizedBox(width: 8.w),
                          Container(
                            width: 9.r,
                            height: 9.r,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}