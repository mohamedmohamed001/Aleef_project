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
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTapDetails ?? onTap,
          borderRadius: BorderRadius.circular(22.r),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 58.r,
                      height: 58.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.09),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(7.r),
                        child: Image.asset(
                          AppAssets.chatBot,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 1.w,
                      bottom: 2.h,
                      child: Container(
                        width: 13.r,
                        height: 13.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFF27C26A),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 13.w),

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
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w),

                          Text(
                            "Online",
                            style: AppTextStyles.body14Regular.copyWith(
                              color: AppColors.primary,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6.h),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 11.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F6),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(14.r),
                            bottomLeft: Radius.circular(14.r),
                            bottomRight: Radius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          "How can I help your pet today?",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body14Regular.copyWith(
                            color: const Color(0xFF374151),
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 19.sp,
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