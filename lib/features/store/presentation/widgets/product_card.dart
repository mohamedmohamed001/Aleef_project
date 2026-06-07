import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/product_model.dart';
import 'package:aleef/features/store/presentation/pages/details_screen.dart';
import '../../services/store_provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _controller.reverse();
    await _controller.forward();
  }

  void _handleAddToCart(BuildContext context) async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final productId = widget.product.id.toString();
    final currentQty = storeProvider.itemQuantities[productId] ?? 0;
    final availableStock = widget.product.stock - currentQty;

    if (availableStock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This product is out of stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final added = storeProvider.addToCart(widget.product, 1);

    if (!added) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot add more than available stock'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _animateButton();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.title} added to cart'),
        backgroundColor: AppColors.primary,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final productId = widget.product.id.toString();
    final currentQty = storeProvider.itemQuantities[productId] ?? 0;
    final availableStock = (widget.product.stock - currentQty).clamp(0, widget.product.stock);

    final bool isOutOfStock = availableStock <= 0;
    final bool disableAddButton = isOutOfStock;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetails(productId: widget.product.id),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                      child: Image.network(
                        widget.product.thumbnail.url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.pets,
                            size: 40.r,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                    // Positioned(
                    //   top: 10.h,
                    //   left: 10.w,
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 8.w,
                    //       vertical: 4.h,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: isOutOfStock ? Colors.red : AppColors.primary,
                    //       borderRadius: BorderRadius.circular(20.r),
                    //     ),
                    //     // child: Text(
                    //     //   isOutOfStock ? 'Out' : 'In stock',
                    //     //   style: TextStyle(
                    //     //     color: Colors.white,
                    //     //     fontSize: 10.sp,
                    //     //     fontWeight: FontWeight.w600,
                    //     //   ),
                    //     // ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: List.generate(
                      5,
                          (index) => Icon(
                        Icons.star,
                        color: index < widget.product.averageRate.round()
                            ? const Color(0xFF5DB1A3)
                            : Colors.grey.shade300,
                        size: 12,
                      ),
                    ),
                  ),
                  // Text(
                  //   isOutOfStock
                  //       ? 'Out of stock'
                  //       : 'Only $availableStock left',
                  //   style: TextStyle(
                  //     color: isOutOfStock ? Colors.red : Colors.grey.shade600,
                  //     fontSize: 11.sp,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'EGP ${widget.product.finalPrice.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: disableAddButton ? 0.45 : 1,
                          child: GestureDetector(
                            onTap: disableAddButton
                                ? null
                                : () => _handleAddToCart(context),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: disableAddButton
                                    ? Colors.grey.shade300
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                disableAddButton ? Icons.block : Icons.add,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}