import 'package:aleef/features/store/presentation/pages/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'cart_summary_row.dart';

class CartCheckoutSection extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double total;
  final bool isCalculating;
  final String? errorMessage;

  const CartCheckoutSection({
    super.key,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.isCalculating,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, -5.h),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCalculating)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 12.w,
                    height: 12.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Recalculating...",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          CartSummaryRow(
            label: "Subtotal",
            value: "EGP ${subtotal.toStringAsFixed(2)}",
          ),
          SizedBox(height: 10.h),
          CartSummaryRow(
            label: "Delivery Fee",
            value: "EGP ${delivery.toStringAsFixed(2)}",
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Divider(thickness: 1.h),
          ),
          CartSummaryRow(
            label: "Total",
            value: "EGP ${total.toStringAsFixed(2)}",
            isTotal: true,
          ),
          if (errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(height: 25.h),
          ElevatedButton(
            onPressed: isCalculating
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 55.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              elevation: 0,
            ),
            child: Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
