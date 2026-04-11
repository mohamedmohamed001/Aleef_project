import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:aleef/features/store/presentation/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../services/api_store.dart';
import '../widgets/details/details_action_buttons.dart';
import '../widgets/details/details_header_section.dart';
import '../widgets/details/details_rating_row.dart';
import '../widgets/details/quantity_selector.dart';

class DetailsScreen extends StatefulWidget {
  final String productId;

  const DetailsScreen({super.key, required this.productId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
    return '\$${total.toStringAsFixed(2)}';
  }

  void incrementQuantity() {
    setState(() => quantity++);
  }

  void decrementQuantity() {
    if (quantity == 1) return;
    setState(() => quantity--);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await ApiStore().getAllProductsDetails(widget.productId);

      setState(() {
        product = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
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
                    /// 🔥 Stock
                    Text(
                      "in stock",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    /// 🔥 Name + Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product!.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleLarge,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          '\$${product!.finalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    product!.discount !=0?
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        product!.originalPrice.toString(),
                        style: TextStyle(
                          color: AppColors.hint,
                          fontSize: 18,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ) : Container(),

                    SizedBox(height: 10.h),

                     DetailsRatingRow(avgRate: product!.averageRate, ratingQuantity: product!.ratingsQuantity,),

                    SizedBox(height: 28.h),

                    /// 🔥 Description
                    Text(
                      'Description',
                      style: AppTextStyles.black16Bold.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      product!.description,
                      style: AppTextStyles.body14Regular.copyWith(height: 1.5),
                    ),

                    SizedBox(height: 28.h),

                    /// 🔥 Quantity
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
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              totalPrice,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1E20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 36.h),

                    /// 🔥 Buttons
                    DetailsActionButtons(onAddToCart: () {}, onBuyNow: () {}),

                    SizedBox(height: 20.h),
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
