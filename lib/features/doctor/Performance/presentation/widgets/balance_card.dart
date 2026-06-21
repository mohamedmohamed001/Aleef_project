import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/performance_ui_helpers.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final int transactionsCount;
  final VoidCallback onTap;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.transactionsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;
    final balanceColor = transactionAmountColor(balance);
    final sign = amountSign(balance);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Ink(
          width: double.infinity,
          height: 172.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xff2F8F88),
                AppColors.primary,
                const Color(0xff155C58),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.20),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -8.w,
                  top: -20.h,
                  child: Container(
                    height: 118.w,
                    width: 118.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.075),
                    ),
                  ),
                ),

                Positioned(
                  right: 42.w,
                  bottom: -26.h,
                  child: Container(
                    height: 90.w,
                    width: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.055),
                    ),
                  ),
                ),

                Positioned(
                  right: -34.w,
                  bottom: 42.h,
                  child: Container(
                    height: 86.w,
                    width: 86.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.045),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 18.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 44.w,
                            width: 44.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              isPositive
                                  ? Icons.account_balance_wallet_rounded
                                  : Icons.trending_down_rounded,
                              color: balanceColor,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Balance',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  isPositive
                                      ? 'Available to withdraw'
                                      : 'Needs settlement',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.72),
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 38.w,
                            width: 38.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.12),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Text(
                        '$sign${balance.abs().toStringAsFixed(0)} EGP',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),

                      SizedBox(height: 14.h),

                      Row(
                        children: [
                          _BalanceChip(
                            icon: Icons.receipt_long_rounded,
                            text: '$transactionsCount Transactions',
                          ),
                          SizedBox(width: 8.w),
                          _BalanceChip(
                            icon: isPositive
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            text: isPositive ? 'Positive' : 'Negative',
                          ),
                        ],
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

class _BalanceChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BalanceChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.11),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13.sp,
            color: Colors.white,
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}