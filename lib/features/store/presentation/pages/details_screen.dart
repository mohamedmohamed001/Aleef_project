import 'package:aleef/features/store/presentation/models/product_model.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../services/api_store.dart';
import '../widgets/details/details_header_section.dart';
import '../widgets/details/product_details_bottom_bar.dart';
import '../widgets/details/product_details_description_card.dart';
import '../widgets/details/product_details_info_card.dart';
import '../widgets/details/product_details_quantity_card.dart';

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

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await ApiStore().getAllProductsDetails(widget.productId);

      if (!mounted) return;

      setState(() {
        product = response;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
      _showSnack(e.toString(), Colors.red);
    }
  }

  void incrementQuantity() {
    if (product == null) return;

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final availableStock = _getAvailableStock(storeProvider);

    if (availableStock <= 0) {
      _showSnack("This product is out of stock", Colors.red);
      return;
    }

    if (quantity < availableStock) {
      setState(() => quantity++);
    } else {
      _showSnack("Only $availableStock item(s) left", Colors.red);
    }
  }

  void decrementQuantity() {
    if (quantity == 1) return;
    setState(() => quantity--);
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(
          16.w,
          0,
          16.w,
          90.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        duration: const Duration(milliseconds: 1100),
      ),
    );
  }

  void _addToCart() {
    if (product == null) return;

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final availableStock = _getAvailableStock(storeProvider);

    if (availableStock <= 0) {
      _showSnack("This product is out of stock", Colors.red);
      return;
    }

    if (quantity > availableStock) {
      _showSnack("Only $availableStock item(s) left", Colors.red);
      return;
    }

    final bool added = storeProvider.addToCart(product!, quantity);

    if (!added) {
      _showSnack("Cannot add more than available stock", Colors.red);
      return;
    }

    setState(() => quantity = 1);
    _showSnack("${product!.title} added to cart!", AppColors.primary);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F7F8),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }

    final storeProvider = Provider.of<StoreProvider>(context);
    final availableStock = _getAvailableStock(storeProvider);

    if (availableStock == 0 && quantity != 1) {
      quantity = 1;
    } else if (availableStock > 0 && quantity > availableStock) {
      quantity = availableStock;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      bottomNavigationBar: ProductDetailsBottomBar(
        onAddToCart: _addToCart,
        onBuyNow: () {},
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailsHeaderSection(
                imagePath: product!.productImages,
                onBackPressed: () => Navigator.pop(context),
                discount: product!.discount.toString(),
              ),
              ProductDetailsInfoCard(
                product: product!,
                availableStock: availableStock,
              ),
              Transform.translate(
                offset: Offset(0, -10.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      ProductDetailsDescriptionCard(
                        description: product!.description,
                      ),
                      SizedBox(height: 16.h),
                      ProductDetailsQuantityCard(
                        quantity: quantity,
                        totalPrice: totalPrice,
                        onIncrement: incrementQuantity,
                        onDecrement: decrementQuantity,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
