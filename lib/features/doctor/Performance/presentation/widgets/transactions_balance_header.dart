import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/performance_ui_helpers.dart';
import 'mini_amount_box.dart';

class TransactionsBalanceHeader extends StatelessWidget {
  final double balance;
  final double income;
  final double outcome;

  const TransactionsBalanceHeader({
    super.key,
    required this.balance,
    required this.income,
    required this.outcome,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;
    final sign = amountSign(balance);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28.w,
            top: -24.h,
            child: Container(
              height: 110.w,
              width: 110.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Balance',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.82),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '$sign${balance.abs().toStringAsFixed(0)} EGP',
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Text(
                  isPositive ? 'Positive balance' : 'Negative balance',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: isPositive ? Colors.white : const Color(0xffFFD3D3),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: MiniAmountBox(
                      title: 'Income',
                      amount: income,
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: MiniAmountBox(
                      title: 'Outcome',
                      amount: outcome,
                      icon: Icons.arrow_upward_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}