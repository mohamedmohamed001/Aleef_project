import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/product_model.dart';
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

  Timer? _collapseTimer;
  bool _isQuantityControlOpen = false;

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
    _collapseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _controller.reverse();
    await _controller.forward();
  }

  void _openQuantityControl() {
    if (!mounted) return;

    setState(() {
      _isQuantityControlOpen = true;
    });

    _startCollapseTimer();
  }

  void _startCollapseTimer() {
    _collapseTimer?.cancel();

    _collapseTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isQuantityControlOpen = false;
      });
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.fixed,
        ),
      );
  }

  Future<void> _handleIncrease() async {
    final storeProvider = context.read<StoreProvider>();

    final productId = widget.product.id.toString();
    final currentQty = storeProvider.itemQuantities[productId] ?? 0;
    final availableStock = widget.product.stock - currentQty;

    if (availableStock <= 0) {
      _showSnackBar('Cannot add more than available stock');
      return;
    }

    final added = storeProvider.addToCart(widget.product, 1);

    if (!added) {
      _showSnackBar('Cannot add more than available stock');
      return;
    }

    _openQuantityControl();
    await _animateButton();

    if (currentQty == 0) {
      _showSnackBar('${widget.product.title} added to cart');
    }
  }

  Future<void> _handleDecrease() async {
    final storeProvider = context.read<StoreProvider>();
    final productId = widget.product.id.toString();

    storeProvider.decrementQuantity(productId);

    _openQuantityControl();
    await _animateButton();
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final productId = widget.product.id.toString();

    final currentQty = storeProvider.itemQuantities[productId] ?? 0;

    final availableStock =
    (widget.product.stock - currentQty).clamp(0, widget.product.stock);

    final bool isOutOfStock = availableStock <= 0 && currentQty == 0;
    final bool hasDiscount = widget.product.discount > 0;
    final bool isInCart = currentQty > 0;

    if (!isInCart && _isQuantityControlOpen) {
      _isQuantityControlOpen = false;
      _collapseTimer?.cancel();
    }

    return GestureDetector(
      onTap: widget.onTap,
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
                            color: isOutOfStock
                                ? Colors.white
                                : AppColors.primary,
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
                        Flexible(
                          child: Text(
                            '(${widget.product.ratingsQuantity})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        Expanded(
                          child: _PriceBlock(
                            hasDiscount: hasDiscount,
                            originalPrice: widget.product.originalPrice,
                            finalPrice: widget.product.finalPrice,
                          ),
                        ),

                        SizedBox(width: 6.w),

                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutBack,
                            switchOutCurve: Curves.easeIn,
                            child: isInCart
                                ? _CartActionArea(
                              key: ValueKey(
                                _isQuantityControlOpen
                                    ? 'open_$currentQty'
                                    : 'closed_$currentQty',
                              ),
                              quantity: currentQty,
                              isOpen: _isQuantityControlOpen,
                              canIncrease: availableStock > 0,
                              onOpen: _openQuantityControl,
                              onIncrease: _handleIncrease,
                              onDecrease: _handleDecrease,
                            )
                                : _AddToCartButton(
                              key: const ValueKey('add_button'),
                              isOutOfStock: isOutOfStock,
                              onTap:
                              isOutOfStock ? null : _handleIncrease,
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

class _PriceBlock extends StatelessWidget {
  final bool hasDiscount;
  final num originalPrice;
  final num finalPrice;

  const _PriceBlock({
    required this.hasDiscount,
    required this.originalPrice,
    required this.finalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 70.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDiscount)
            Text(
              'EGP ${originalPrice.toStringAsFixed(0)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5.sp,
                color: Colors.grey.shade500,
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.w600,
              ),
            ),
          Text(
            'EGP ${finalPrice.toStringAsFixed(0)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 13.5.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final bool isOutOfStock;
  final VoidCallback? onTap;

  const _AddToCartButton({
    super.key,
    required this.isOutOfStock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: isOutOfStock ? Colors.grey.shade300 : AppColors.primary,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: isOutOfStock
              ? []
              : [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.28),
              blurRadius: 10.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Icon(
          isOutOfStock ? Icons.block_rounded : Icons.add_shopping_cart_rounded,
          color: Colors.white,
          size: 18.sp,
        ),
      ),
    );
  }
}

class _CartActionArea extends StatelessWidget {
  final int quantity;
  final bool isOpen;
  final bool canIncrease;
  final VoidCallback onOpen;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _CartActionArea({
    super.key,
    required this.quantity,
    required this.isOpen,
    required this.canIncrease,
    required this.onOpen,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) {
      return _CompactCartButton(
        quantity: quantity,
        onTap: onOpen,
      );
    }

    return _QuantityControl(
      quantity: quantity,
      canIncrease: canIncrease,
      onIncrease: onIncrease,
      onDecrease: onDecrease,
    );
  }
}

class _CompactCartButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onTap;

  const _CompactCartButton({
    required this.quantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 42.w,
        height: 42.w,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.28),
                      blurRadius: 10.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),

            Positioned(
              top: -5.h,
              right: -5.w,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 19.w,
                  minHeight: 19.w,
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  quantity > 99 ? '99+' : quantity.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final bool canIncrease;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _QuantityControl({
    required this.quantity,
    required this.canIncrease,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108.w,
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        children: [
          _QuantityButton(
            icon: Icons.remove_rounded,
            onTap: onDecrease,
          ),

          Expanded(
            child: Center(
              child: Text(
                quantity.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          _QuantityButton(
            icon: Icons.add_rounded,
            onTap: canIncrease ? onIncrease : null,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 28.w,
        height: 28.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isDisabled ? 0.16 : 0.26),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(isDisabled ? 0.45 : 1),
          size: 17.sp,
        ),
      ),
    );
  }
}