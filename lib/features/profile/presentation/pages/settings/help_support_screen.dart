import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xFF111827),
            size: 20.sp,
          ),
        ),
        title: Text(
          "Help & Support",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            _SupportCard(
              title: "Contact Us",
              description: "We are here to help you 24/7",
              items: [
                _SupportItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: "Live Chat",
                  onTap: () {},
                ),
                _SupportItem(
                  icon: Icons.email_outlined,
                  title: "Email Support",
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _SupportCard(
              title: "FAQs",
              description: "Quick answers to common questions",
              items: [
                _SupportItem(
                  icon: Icons.help_outline_rounded,
                  title: "General Questions",
                  onTap: () {},
                ),
                _SupportItem(
                  icon: Icons.payment_rounded,
                  title: "Payments & Orders",
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> items;

  const _SupportCard({
    required this.title,
    required this.description,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.black16Bold.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          ...items,
        ],
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SupportItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF111827),
          fontSize: 14.5.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.grey),
      onTap: onTap,
    );
  }
}
