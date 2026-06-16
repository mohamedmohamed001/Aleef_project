import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:aleef/core/theme/app_colors.dart';
import '../widgets/cart/cart_checkout_section.dart';
import '../widgets/cart/cart_empty_state.dart';
import '../widgets/cart/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StoreProvider>().calculateCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xFF1D1E20), size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Cart",
          style: TextStyle(
            color: const Color(0xFF1D1E20),
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${storeProvider.cartItems.length}",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: storeProvider.cartItems.isEmpty
          ? const CartEmptyState()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20.r),
                    itemCount: storeProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = storeProvider.cartItems[index];
                      final currentQuantity =
                          storeProvider.itemQuantities[product.id.toString()] ?? 1;

                      return CartItemCard(
                        product: product,
                        quantity: currentQuantity,
                        storeProvider: storeProvider,
                      );
                    },
                  ),
                ),
                CartCheckoutSection(
                  subtotal: storeProvider.cartSubtotal,
                  delivery: storeProvider.cartDelivery,
                  total: storeProvider.cartTotal,
                  isCalculating: storeProvider.isCalculatingCart,
                  errorMessage: storeProvider.cartErrorMessage,
                ),
              ],
            ),
    );
  }
}
