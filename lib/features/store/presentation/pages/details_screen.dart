import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/store/presentation/models/product_model.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../services/api_store.dart';
import '../widgets/details/details_action_buttons.dart';
import '../widgets/details/details_header_section.dart';
import '../widgets/details/details_rating_row.dart';
import '../widgets/details/quantity_selector.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  final Map<String, dynamic>? orderData;

  const ProductDetails({
    super.key,
    required this.productId,
    this.orderData,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductModel? product;
  bool isLoading = true;
  int quantity = 1;

  double get unitPrice {
    return double.tryParse(
      product!.finalPrice.toString().replaceAll('\$', ''),
    ) ??
        0.0;
  }

  String get totalPrice {
    final total = unitPrice * quantity;
    return total.toStringAsFixed(2);
  }

  int _getAvailableStock(StoreProvider storeProvider) {
    if (product == null) return 0;

    final inCartQuantity =
        storeProvider.itemQuantities[widget.productId.toString()] ?? 0;

    final availableStock = product!.stock - inCartQuantity;
    return availableStock < 0 ? 0 : availableStock;
  }

  void incrementQuantity() {
    if (product == null) return;

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final availableStock = _getAvailableStock(storeProvider);

    if (availableStock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This product is out of stock"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (quantity < availableStock) {
      setState(() => quantity++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Only $availableStock item(s) left"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void decrementQuantity() {
    if (quantity == 1) return;
    setState(() => quantity--);
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await ApiStore().getAllProductsDetails(widget.productId);
      if (mounted) {
        setState(() {
          product = response;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    final storeProvider = Provider.of<StoreProvider>(context);
    final availableStock = _getAvailableStock(storeProvider);

    if (availableStock == 0 && quantity != 1) {
      quantity = 1;
    } else if (availableStock > 0 && quantity > availableStock) {
      quantity = availableStock;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailsHeaderSection(
                imagePath: product!.productImages,
                onBackPressed: () => Navigator.pop(context),
                discount: product!.discount.toString(),
              ),
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    availableStock > 5
                        ? Text(
                      "in stock",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    )
                        : availableStock > 0
                        ? Text(
                      "only $availableStock left",
                      style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    )
                        : Text(
                      "out of stock",
                      style: AppTextStyles.title16SemiBold.copyWith(
                        color: Colors.red,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product!.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'EGP ${product!.finalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        DetailsRatingRow(
                          avgRate: product!.averageRate,
                          ratingQuantity: product!.ratingsQuantity,
                        ),
                        const Spacer(),
                        product!.discount != 0
                            ? Text(
                          product!.originalPrice.toString(),
                          style: TextStyle(
                            color: AppColors.hint,
                            fontSize: 18.sp,
                            decoration: TextDecoration.lineThrough,
                          ),
                        )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      'Description',
                      style: AppTextStyles.black16Bold.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      product!.description,
                      style: AppTextStyles.body14Regular.copyWith(height: 1.5),
                    ),
                    SizedBox(height: 28.h),
                    Text('Quantity', style: AppTextStyles.black16Bold),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuantitySelector(
                          quantity: quantity,
                          onIncrement: incrementQuantity,
                          onDecrement: decrementQuantity,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                color: AppColors.hint,
                                fontSize: 13.sp,
                              ),
                            ),
                            Text(
                              "EGP $totalPrice",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 36.h),
                    DetailsActionButtons(
                      onAddToCart: () {
                        if (product == null) return;

                        final storeProvider = Provider.of<StoreProvider>(
                          context,
                          listen: false,
                        );

                        final availableStock =
                        _getAvailableStock(storeProvider);

                        if (availableStock <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("This product is out of stock"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (quantity > availableStock) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Only $availableStock item(s) left",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final bool added = storeProvider.addToCart(
                          product!,
                          quantity,
                        );

                        if (!added) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Cannot add more than available stock",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${product!.title} added to cart!"),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      onBuyNow: () {},
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