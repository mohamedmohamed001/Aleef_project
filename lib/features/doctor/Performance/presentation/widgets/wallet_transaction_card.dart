import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../data/models/doctor_wallet_transaction_model.dart';

class WalletTransactionCard extends StatelessWidget {
  final DoctorWalletTransactionModel transaction;

  const WalletTransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isDebit = transaction.isDebit;
    final isCredit = transaction.isCredit;

    final amountColor = isDebit
        ? const Color(0xff19D58B)
        : const Color(0xffE5484D);

    final icon = isDebit
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    final title = isDebit ? 'Wallet income' : 'Wallet deduction';

    final ownerName = transaction.owner?.name ?? 'Unknown owner';
    final petName = transaction.pet?.name ?? 'Unknown pet';

    final date = DateFormat('dd MMM yyyy - hh:mm a').format(
      transaction.createdAt.toLocal(),
    );

    final sign = isDebit
        ? '+'
        : isCredit
        ? '-'
        : '';

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: amountColor,
              size: 24.sp,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff1F2937),
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  '$ownerName • $petName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff6B7280),
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign${transaction.amount.toStringAsFixed(2)} EGP',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: amountColor,
                ),
              ),

              SizedBox(height: 6.h),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${transaction.balanceAfter.toStringAsFixed(2)} EGP',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}