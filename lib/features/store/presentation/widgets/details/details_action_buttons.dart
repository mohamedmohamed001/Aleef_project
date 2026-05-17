import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DetailsActionButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const DetailsActionButtons({
    super.key,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 🟢 Add to Cart
        Expanded(
          child: SizedBox(
            height: 52.h,
            child: OutlinedButton(

              onPressed: onAddToCart,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        /// 🔥 Buy Now
        // Expanded(
        //   child: SizedBox(
        //     height: 52.h,
        //     child: ElevatedButton(
        //       onPressed: onBuyNow,
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: AppColors.primary,
        //         padding: EdgeInsets.symmetric(vertical: 14.h),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(14.r),
        //         ),
        //         elevation: 0,
        //       ),
        //       child: const Text(
        //         'Buy Now',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 15,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}