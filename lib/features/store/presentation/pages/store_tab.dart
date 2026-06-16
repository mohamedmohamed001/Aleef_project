import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../services/store_provider.dart';
import '../models/product_model.dart';
import '../widgets/store_header.dart';
import '../widgets/store_search_box.dart';
import '../widgets/store_category_list.dart';
import '../widgets/store_products_header.dart';
import '../widgets/store_sort_button.dart';
import '../widgets/store_products_grid.dart';
import '../widgets/store_state_view.dart';
import 'details_screen.dart';

class StoreTab extends StatefulWidget {
  const StoreTab({super.key});

  static const List<String> categories = [
    'All',
    'Dogs',
    'Cats',
    'Food',
    'Toys',
  ];

  static const Map<String, String> sortOptions = {
    'Price: Low to High': 'price_asc',
    'Price: High to Low': 'price_desc',
    'Newest': 'newest',
    'Most Popular': 'popular',
  };

  @override
  State<StoreTab> createState() => _StoreTabState();
}

class _StoreTabState extends State<StoreTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  String selectedCategory = 'All';
  String? selectedSort;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StoreProvider>().getAllProducts(forceRefresh: true);
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<StoreProvider>();

    if (provider.isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      provider.loadMoreProducts();
    }
  }

  List<ProductModel> getFilteredProducts(List<ProductModel> products) {
    if (selectedCategory == 'All') return products;

    return products.where((product) {
      return product.categories.any(
        (category) =>
            category.name.toLowerCase() == selectedCategory.toLowerCase(),
      );
    }).toList();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<StoreProvider>().updateSearch(value);
      }
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {});
    _onSearchChanged('');
  }

  Future<void> _onSortChanged(String? title) async {
    setState(() {
      selectedSort = title;
    });

    final sortValue = title == null ? null : StoreTab.sortOptions[title];
    await context.read<StoreProvider>().updateSort(sortValue);
  }

  void _onProductTap(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(productId: product.id),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final products = getFilteredProducts(storeProvider.allProducts);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: const StoreHeader(),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: storeProvider.refreshProducts,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StoreSearchBox(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                        _onSearchChanged(value);
                      },
                      onClear: _onClearSearch,
                    ),
                    SizedBox(height: 18.h),
                    StoreCategoryList(
                      categories: StoreTab.categories,
                      selectedCategory: selectedCategory,
                      onCategorySelected: _onCategorySelected,
                    ),
                    SizedBox(height: 22.h),
                    StoreProductsHeader(
                      title: selectedCategory == 'All'
                          ? 'All Products'
                          : '$selectedCategory Products',
                      count: products.length,
                      sortButton: StoreSortButton(
                        sortOptions: StoreTab.sortOptions,
                        selectedSort: selectedSort,
                        onSortChanged: _onSortChanged,
                      ),
                    ),
                    SizedBox(height: 14.h),
                  ],
                ),
              ),
            ),
            if (storeProvider.isLoading)
              const SliverFillRemaining(
                child: StoreStateView(type: StoreStateType.loading),
              )
            else if (storeProvider.errorMessage != null)
              SliverFillRemaining(
                child: StoreStateView(
                  type: StoreStateType.error,
                  errorMessage: storeProvider.errorMessage!,
                ),
              )
            else if (products.isEmpty)
              const SliverFillRemaining(
                child: StoreStateView(type: StoreStateType.empty),
              )
            else
              StoreProductsGrid(
                products: products,
                onProductTap: _onProductTap,
              ),
            if (storeProvider.isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 22.h),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),
    );
  }
}
