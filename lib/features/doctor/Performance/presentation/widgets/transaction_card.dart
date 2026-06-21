import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/doctor_transaction_model.dart';
import '../helpers/performance_ui_helpers.dart';

class TransactionCard extends StatelessWidget {
  final DoctorTransaction transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount > 0;
    final isOutcome = transaction.amount < 0;

    final color = transactionAmountColor(transaction.amount);

    final icon = isIncome
        ? Icons.add_rounded
        : isOutcome
        ? Icons.remove_rounded
        : Icons.schedule_rounded;

    final sign = amountSign(transaction.amount);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48.w,
            width: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(17.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      transaction.time,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        transaction.status,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '$sign${transaction.amount.abs().toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}