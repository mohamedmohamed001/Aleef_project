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
      duration: const Duration(milliseconds: 170),
      lowerBound: 0.90,
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

  Future<void> _handleAddToCart() async {
    final storeProvider = context.read<StoreProvider>();

    final productId = widget.product.id.toString();
    final currentQty = storeProvider.itemQuantities[productId] ?? 0;
    final availableStock = widget.product.stock - currentQty;

    if (availableStock <= 0) {
      if (!mounted) return;

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
      if (!mounted) return;

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
    final availableStock =
    (widget.product.stock - currentQty).clamp(0, widget.product.stock);

    final bool isOutOfStock = availableStock <= 0;
    final bool hasDiscount = widget.product.discount > 0;

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFFF2F7F6),
                        child: Image.network(
                          widget.product.thumbnail.url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.pets_rounded,
                                size: 42.r,
                                color: AppColors.primary.withOpacity(0.45),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.03),
                              Colors.black.withOpacity(0.18),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (hasDiscount)
                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            '${widget.product.discount}% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? Colors.red.withOpacity(0.92)
                              : Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          isOutOfStock ? 'Out' : '$availableStock left',
                          style: TextStyle(
                            color:
                            isOutOfStock ? Colors.white : AppColors.primary,
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1F2D2B),
                        height: 1.1,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 15.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          widget.product.averageRate.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF52615F),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${widget.product.ratingsQuantity})',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasDiscount)
                                Text(
                                  'EGP ${widget.product.originalPrice.toStringAsFixed(0)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              Text(
                                'EGP ${widget.product.finalPrice.toStringAsFixed(0)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 8.w),

                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: GestureDetector(
                            onTap: isOutOfStock
                                ? null
                                : () =>  _handleAddToCart,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: isOutOfStock
                                    ? Colors.grey.shade300
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(13.r),
                                boxShadow: isOutOfStock
                                    ? []
                                    : [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withOpacity(0.28),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 5.h),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isOutOfStock
                                    ? Icons.block_rounded
                                    : Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 18.sp,
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
      ),
    );
  }
}