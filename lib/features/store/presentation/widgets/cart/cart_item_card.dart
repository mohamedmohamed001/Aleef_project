import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/store/presentation/models/product_model.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'cart_quantity_button.dart';

class CartItemCard extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final StoreProvider storeProvider;

  const CartItemCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.storeProvider,
  });

  @override
  Widget build(BuildContext context) {
    final int remainingStock = (product.stock - quantity).clamp(0, product.stock);
    final bool canIncrease = remainingStock > 0;
    final bool canDecrease = quantity > 1;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80.w,
            height: 80.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                product.thumbnail.url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, color: Colors.grey, size: 30.sp),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D1E20),
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "EGP ${product.finalPrice}",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  canIncrease
                      ? "Only $remainingStock more available"
                      : "Max stock reached",
                  style: TextStyle(
                    color: canIncrease ? Colors.grey : Colors.orange,
                    fontSize: 12.sp,
                    fontWeight: canIncrease ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    CartQuantityButton(
                      icon: Icons.remove,
                      isEnabled: canDecrease,
                      onTap: () {
                        storeProvider.decrementQuantity(product.id.toString());
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          "$quantity",
                          key: ValueKey(quantity),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    CartQuantityButton(
                      icon: Icons.add,
                      isPrimary: true,
                      isEnabled: canIncrease,
                      onTap: () {
                        if (!canIncrease) return;
                        storeProvider.incrementCartQuantity(product.id.toString());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 24.sp),
            onPressed: () {
              storeProvider.removeFromCart(product.id.toString());
            },
          ),
        ],
      ),
    );
  }
}
