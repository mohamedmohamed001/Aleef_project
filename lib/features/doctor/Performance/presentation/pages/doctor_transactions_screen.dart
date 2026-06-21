import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../manager/doctor_performance_provider.dart';
import '../widgets/empty_transactions.dart';
import '../widgets/transactions_balance_header.dart';
import '../widgets/wallet_transaction_card.dart';

class DoctorTransactionsScreen extends StatefulWidget {
  const DoctorTransactionsScreen({super.key});

  @override
  State<DoctorTransactionsScreen> createState() =>
      _DoctorTransactionsScreenState();
}

class _DoctorTransactionsScreenState extends State<DoctorTransactionsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DoctorPerformanceProvider>().getWalletTransactions();
    });
  }

  Future<void> _refreshTransactions() async {
    await context.read<DoctorPerformanceProvider>().getWalletTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 16.w,
        iconTheme: const IconThemeData(
          color: Color(0xff1F2937),
        ),
        title: Text(
          'Transactions',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff1F2937),
          ),
        ),
      ),
      body: Consumer<DoctorPerformanceProvider>(
        builder: (context, provider, _) {
          final transactions = provider.walletTransactions;

          final balance = provider.wallet?.balance ?? 0.0;

          final income = transactions
              .where((transaction) => transaction.isDebit)
              .fold<double>(
            0.0,
                (sum, transaction) => sum + transaction.amount,
          );

          final outcome = transactions
              .where((transaction) => transaction.isCredit)
              .fold<double>(
            0.0,
                (sum, transaction) => sum + transaction.amount,
          );

          if (provider.isWalletTransactionsLoading && transactions.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (provider.walletTransactionsErrorMessage != null &&
              transactions.isEmpty) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refreshTransactions,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 80.h,
                ),
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 44.sp,
                    color: const Color(0xffE5484D),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    provider.walletTransactionsErrorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff6B7280),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refreshTransactions,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
              children: [
                TransactionsBalanceHeader(
                  balance: balance,
                  income: income,
                  outcome: outcome,
                ),

                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xff1F2937),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.grey.shade100,
                        ),
                      ),
                      child: Text(
                        '${transactions.length} items',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                if (transactions.isEmpty)
                  const EmptyTransactions()
                else
                  ...transactions.map(
                        (transaction) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: WalletTransactionCard(
                          transaction: transaction,
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}