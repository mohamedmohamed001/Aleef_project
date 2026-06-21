import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final SecureStorageService _storage = SecureStorageService();

  bool _isLoading = true;

  bool _pushNotifications = true;
  bool _appointmentReminders = true;
  bool _orderUpdates = true;
  bool _chatMessages = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _storage.getNotificationSettings();

    if (!mounted) return;

    setState(() {
      _pushNotifications = settings['pushNotifications'] ?? true;
      _appointmentReminders = settings['appointmentReminders'] ?? true;
      _orderUpdates = settings['orderUpdates'] ?? true;
      _chatMessages = settings['chatMessages'] ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await _storage.saveNotificationSettings(
      pushNotifications: _pushNotifications,
      appointmentReminders: _appointmentReminders,
      orderUpdates: _orderUpdates,
      chatMessages: _chatMessages,
    );
  }

  Future<void> _updateSetting({
    required String type,
    required bool value,
  }) async {
    setState(() {
      switch (type) {
        case 'push':
          _pushNotifications = value;

          if (!value) {
            _appointmentReminders = false;
            _orderUpdates = false;
            _chatMessages = false;
          }
          break;

        case 'appointments':
          _appointmentReminders = value;
          break;

        case 'orders':
          _orderUpdates = value;
          break;

        case 'chat':
          _chatMessages = value;
          break;
      }
    });

    await _saveSettings();

    if (!mounted) return;

    _showSavedSnackBar();
  }

  void _showSavedSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Notification settings saved"),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        margin: EdgeInsets.all(12.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF111827),
            size: 20.sp,
          ),
        ),
        title: Text(
          "Notifications",
          style: AppTextStyles.black16Bold.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24.r),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            _HeaderInfoCard(
              isEnabled: _pushNotifications,
            ),

            SizedBox(height: 16.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 18.r,
                    offset: Offset(0, 8.h),
                  ),
                ],
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.06),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "App Notifications",
                    style: AppTextStyles.black16Bold.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  _NotificationToggleItem(
                    icon: Icons.notifications_active_outlined,
                    title: "Push Notifications",
                    subtitle: "Receive alerts on your device",
                    value: _pushNotifications,
                    onChanged: (val) {
                      _updateSetting(
                        type: 'push',
                        value: val,
                      );
                    },
                  ),

                  const _SettingsDivider(),

                  _NotificationToggleItem(
                    icon: Icons.calendar_month_outlined,
                    title: "Appointment Reminders",
                    subtitle: "Get notified before your vet visits",
                    value: _appointmentReminders,
                    isEnabled: _pushNotifications,
                    onChanged: (val) {
                      _updateSetting(
                        type: 'appointments',
                        value: val,
                      );
                    },
                  ),

                  const _SettingsDivider(),

                  _NotificationToggleItem(
                    icon: Icons.inventory_2_outlined,
                    title: "Order Updates",
                    subtitle: "Track your pet supply deliveries",
                    value: _orderUpdates,
                    isEnabled: _pushNotifications,
                    onChanged: (val) {
                      _updateSetting(
                        type: 'orders',
                        value: val,
                      );
                    },
                  ),

                  const _SettingsDivider(),

                  _NotificationToggleItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: "Chat Messages",
                    subtitle: "Receive new message alerts",
                    value: _chatMessages,
                    isEnabled: _pushNotifications,
                    onChanged: (val) {
                      _updateSetting(
                        type: 'chat',
                        value: val,
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            Text(
              "These preferences are saved on this device.",
              textAlign: TextAlign.center,
              style: AppTextStyles.hint14Regular.copyWith(
                fontSize: 12.sp,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderInfoCard extends StatelessWidget {
  final bool isEnabled;

  const _HeaderInfoCard({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
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
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 22.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
              ),
            ),
            child: Icon(
              isEnabled
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_rounded,
              color: Colors.white,
              size: 25.sp,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnabled ? "Notifications Enabled" : "Notifications Off",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isEnabled
                      ? "You’ll receive updates about your pet care activity."
                      : "Turn on push notifications to receive updates.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 12.5.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
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

class _NotificationToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final contentOpacity = isEnabled ? 1.0 : 0.42;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Opacity(
        opacity: contentOpacity,
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.09),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 21.sp,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF111827),
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            Switch.adaptive(
              value: value,
              onChanged: isEnabled ? onChanged : null,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 18.h,
      thickness: 1,
      color: AppColors.border.withOpacity(0.75),
    );
  }
}