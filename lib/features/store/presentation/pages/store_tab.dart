import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../services/store_provider.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/store_category_chip.dart';
import '../widgets/store_header.dart';
import '../widgets/store_search_bar.dart';

class StoreTab extends StatefulWidget {
  const StoreTab({super.key});

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  String selectedCategory = 'All';

  final List<String> categories = const ['All', 'Dogs', 'Cats', 'Food', 'Toys'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().getAllProducts();
    });
  }

  List<ProductModel> getFilteredProducts(List<ProductModel> products) {
    if (selectedCategory == 'All') {
      return products;
    }

    return products.where((product) {
      return product.categories.any(
            (category) =>
        category.name.toLowerCase() == selectedCategory.toLowerCase(),
      );
    }).toList();
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final allProducts = storeProvider.allProducts;
    final filteredProducts = getFilteredProducts(allProducts);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const StoreHeader(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            const StoreSearchBar(),

            SizedBox(height: 24.h),

            /// 🔥 Categories Title
            const Text(
              'Categories',
              style: TextStyle(
                color: Color(0xFF1D1E20),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12.h),

            SizedBox(
              height: 38.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return StoreCategoryChip(
                    title: category,
                    isSelected: category == selectedCategory,
                    onTap: () => onCategorySelected(category),
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            /// 🔥 Products Title
            const Text(
              'Popular Products',
              style: TextStyle(
                color: Color(0xFF1D1E20),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12.h),

            /// 🔄 حالات الـ API
            if (storeProvider.isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (storeProvider.errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    storeProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (filteredProducts.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72, // 🔥 أهم تعديل
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return ProductCard(
                      product: product,
                      onTap: () {},
                    );
                  },
                ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}