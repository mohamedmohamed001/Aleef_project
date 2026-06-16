import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutItemsList extends StatelessWidget {
  final StoreProvider storeProvider;

  const CheckoutItemsList({super.key, required this.storeProvider});

  @override
  Widget build(BuildContext context) {
    final items = storeProvider.cartItems;

    if (items.isEmpty) {
      return Text(
        "Your cart is empty",
        style: TextStyle(
          color: const Color(0xFF7A8C8A),
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Column(
      children: items.map((item) {
        final qty = storeProvider.itemQuantities[item.id.toString()] ?? 1;

        return Padding(
          padding: EdgeInsets.only(bottom: 11.h),
          child: Row(
            children: [
              Container(
                height: 9.h,
                width: 9.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF152E2C),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                "x$qty",
                style: TextStyle(
                  color: const Color(0xFF7A8C8A),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 14.w),
              Text(
                "\$${(item.finalPrice * qty).toStringAsFixed(2)}",
                style: TextStyle(
                  color: const Color(0xFF152E2C),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
