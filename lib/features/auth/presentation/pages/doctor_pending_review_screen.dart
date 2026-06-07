import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_scaffold.dart';

class DoctorPendingReviewScreen extends StatelessWidget {
  const DoctorPendingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Application Submitted",
      subtitle: "Your veterinarian account is under review.",
      backgroundHeight: 290,
      backgroundIcon: Icons.medical_services_rounded,
      accentIcon: Icons.hourglass_top_rounded,
      spacingAfterHero: 18,
      child: AuthCard(
        title: "Review In Progress",
        subtitle:
        "We've received your documents and our team is reviewing your application.",
        children: [
          SizedBox(height: 12.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E8),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFFFD66B),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 52.h,
                  width: 52.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE7A8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    color: Color(0xFFC68B00),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Estimated Review Time",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Usually within 24 - 48 hours",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 28.h),

          _buildStep(
            title: "Account Registration",
            icon: Icons.check_circle,
            color: Colors.green,
            completed: true,
          ),

          _buildDivider(),

          _buildStep(
            title: "Email Verification",
            icon: Icons.check_circle,
            color: Colors.green,
            completed: true,
          ),

          _buildDivider(),

          _buildStep(
            title: "Documents Review",
            icon: Icons.hourglass_top_rounded,
            color: Colors.orange,
            completed: false,
            active: true,
          ),

          _buildDivider(),

          _buildStep(
            title: "Account Approval",
            icon: Icons.radio_button_unchecked,
            color: Colors.grey,
            completed: false,
          ),

          SizedBox(height: 28.h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Text(
              "We'll notify you by email once your account has been approved.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 24.h),

          AuthPrimaryButton(
            text: "Back to Login",
            isLoading: false,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.doctorLogin,
                    (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: Container(
        width: 2,
        height: 22.h,
        color: Colors.grey.shade300,
      ),
    );
  }

  static Widget _buildStep({
    required String title,
    required IconData icon,
    required Color color,
    bool completed = false,
    bool active = false,
  }) {
    return Row(
      children: [
        Container(
          height: 32.h,
          width: 32.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 18.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight:
              active ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}