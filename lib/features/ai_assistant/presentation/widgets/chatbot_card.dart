import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class ChatBotCard extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDetails;

  const ChatBotCard({
    super.key,
    this.onTap,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapDetails ?? onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: const Color(0x1A267D77),
                  backgroundImage: AssetImage(AppAssets.chatBot),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "ALEEF Assistant",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleLarge.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w),

                          Container(
                            height: 38.r,
                            width: 38.r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.r),
                              color: const Color(0x1A267D77),
                            ),
                            child: Center(
                              child: Text(
                                "AI",
                                style: AppTextStyles.body14Regular.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        "24/7 Pet Care Advisor",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body14Regular.copyWith(
                          color: const Color(0xff6B7280),
                          fontSize: 13.sp,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        "Ask me anything about your pet's health...",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body14Regular.copyWith(
                          color: const Color(0xff374151),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}