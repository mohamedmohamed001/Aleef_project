import 'dart:convert';

import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../presentation/models/product_model.dart';
import '../services/api_store.dart';

class StoreProvider extends ChangeNotifier {
  final ApiStore _apiStore = ApiStore();
  final SecureStorageService _storage = getIt<SecureStorageService>();

  // =========================
  // Cart State
  // =========================

  final List<ProductModel> cartItems = [];
  final Map<String, int> itemQuantities = {};

  double cartSubtotal = 0.0;
  double cartDelivery = 0.0;
  double cartTotal = 0.0;
  bool isPlacingOrder = false;
  String? placeOrderError;
  bool isCalculatingCart = false;
  String? cartErrorMessage;

  bool get isCartEmpty => cartItems.isEmpty;

  int get cartItemsCount => cartItems.length;

  double get totalPrice {
    double total = 0.0;

    for (final item in cartItems) {
      final qty = itemQuantities[item.id.toString()] ?? 1;
      total += item.finalPrice * qty;
    }

    return total;
  }

  List<Map<String, dynamic>> get cartRequestBody {
    return cartItems.map((item) {
      final productId = item.id.toString();

      return {
        "productId": item.id,
        "quantity": itemQuantities[productId] ?? 1,
      };
    }).toList();
  }

  bool addToCart(ProductModel product, int quantity) {
    final productId = product.id.toString();
    final currentQty = itemQuantities[productId] ?? 0;
    final newQty = currentQty + quantity;

    if (quantity <= 0) return false;
    if (newQty > product.stock) return false;

    final index = cartItems.indexWhere((item) => item.id == product.id);

    if (index == -1) {
      cartItems.add(product);
    }

    itemQuantities[productId] = newQty;

    notifyListeners();
    calculateCart();

    return true;
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.id.toString() == productId);
    itemQuantities.remove(productId);

    if (cartItems.isEmpty) {
      _resetCartSummary();
    }

    notifyListeners();
    calculateCart();
  }

  void incrementCartQuantity(String productId) {
    final index = cartItems.indexWhere(
          (item) => item.id.toString() == productId,
    );

    if (index == -1) return;

    final product = cartItems[index];
    final currentQty = itemQuantities[productId] ?? 1;

    if (currentQty >= product.stock) return;

    itemQuantities[productId] = currentQty + 1;

    notifyListeners();
    calculateCart();
  }

  void decrementQuantity(String productId) {
    if (!itemQuantities.containsKey(productId)) return;

    final currentQty = itemQuantities[productId] ?? 1;

    if (currentQty > 1) {
      itemQuantities[productId] = currentQty - 1;
      notifyListeners();
      calculateCart();
      return;
    }

    removeFromCart(productId);
  }

  Future<void> calculateCart() async {
    if (isCalculatingCart) return;

    if (cartItems.isEmpty) {
      _resetCartSummary();
      notifyListeners();
      return;
    }

    isCalculatingCart = true;
    cartErrorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/products/calculate-cart'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "cart": cartRequestBody,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        cartSubtotal = _toDouble(data['subTotal']);
        cartDelivery = _toDouble(data['delivery']);
        cartTotal = cartSubtotal + cartDelivery;
      } else {
        cartErrorMessage = 'Failed to calculate cart';
        cartSubtotal = totalPrice;
        cartDelivery = 0.0;
        cartTotal = totalPrice;
      }
    } catch (e) {
      cartErrorMessage = e.toString();
      cartSubtotal = totalPrice;
      cartDelivery = 0.0;
      cartTotal = totalPrice;
    }

    isCalculatingCart = false;
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    itemQuantities.clear();
    _resetCartSummary();
    notifyListeners();
  }

  void _resetCartSummary() {
    cartSubtotal = 0.0;
    cartDelivery = 0.0;
    cartTotal = 0.0;
    cartErrorMessage = null;
    isCalculatingCart = false;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? 0.0;
  }

  // =========================
  // Products State
  // =========================

  List<ProductModel> _allProducts = [];

  List<ProductModel> get allProducts => _allProducts;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  int _page = 1;

  int get page => _page;

  int _totalPages = 1;

  int get totalPages => _totalPages;

  int _totalProducts = 0;

  int get totalProducts => _totalProducts;

  final int _limit = 8;

  String? selectedCategory;
  num? minPrice;
  num? maxPrice;
  String search = "";
  String? sort;

  bool get hasMoreProducts => _page < _totalPages;

  Future<void> getAllProducts({bool forceRefresh = false}) async {
    if (_isLoading) return;

    if (!forceRefresh && _allProducts.isNotEmpty) return;

    _page = 1;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiStore.getAllProducts(
        page: _page,
        limit: _limit,
        category: selectedCategory,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: search,
        sort: sort,
      );

      _allProducts = response.products;
      _page = response.page;
      _totalPages = response.totalPages;
      _totalProducts = response.totalProducts;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    _page = 1;
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiStore.getAllProducts(
        page: _page,
        limit: _limit,
        category: selectedCategory,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: search,
        sort: sort,
      );

      _allProducts = response.products;
      _page = response.page;
      _totalPages = response.totalPages;
      _totalProducts = response.totalProducts;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || _isLoading || !hasMoreProducts) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _page + 1;

      final response = await _apiStore.getAllProducts(
        page: nextPage,
        limit: _limit,
        category: selectedCategory,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: search,
        sort: sort,
      );

      _allProducts.addAll(response.products);
      _page = response.page;
      _totalPages = response.totalPages;
      _totalProducts = response.totalProducts;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> updateSearch(String value) async {
    search = value;
    await refreshProducts();
  }

  Future<void> updateSort(String? value) async {
    sort = value;
    await refreshProducts();
  }

  Future<void> updateFilters({
    String? category,
    num? newMinPrice,
    num? newMaxPrice,
  }) async {
    selectedCategory = category;
    minPrice = newMinPrice;
    maxPrice = newMaxPrice;
    await refreshProducts();
  }

  Future<void> clearFilters() async {
    selectedCategory = null;
    minPrice = null;
    maxPrice = null;
    search = "";
    sort = null;
    await refreshProducts();
  }

  // =========================
  // Orders State
  // =========================

  List<Map<String, dynamic>> upcomingOrders = [];
  List<Map<String, dynamic>> previousOrders = [];

  bool isLoadingUpcoming = false;
  bool isLoadingPrevious = false;

  Future<void> getUpcomingOrders() async {
    isLoadingUpcoming = true;
    notifyListeners();

    try {
      final token = await _storage.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/orders/my-upcoming-orders'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        upcomingOrders = List<Map<String, dynamic>>.from(data['orders']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoadingUpcoming = false;
    notifyListeners();
  }

  Future<void> getPreviousOrders() async {
    isLoadingPrevious = true;
    notifyListeners();

    try {
      final token = await _storage.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/orders/my-previous-orders'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        previousOrders = List<Map<String, dynamic>>.from(data['orders']);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoadingPrevious = false;
    notifyListeners();
  }

  Future<bool> placeOrder({
    required String address,
    required String city,
    required String phone,
    required String paymentMethod,
  }) async {
    if (cartItems.isEmpty) {
      placeOrderError = 'Cart is empty';
      notifyListeners();
      return false;
    }

    isPlacingOrder = true;
    placeOrderError = null;
    notifyListeners();

    try {
      final cartData = cartItems.map((product) {
        final qty = itemQuantities[product.id.toString()] ?? 1;

        return {
          "productId": product.id,
          "quantity": qty,
          "price": product.finalPrice,
        };
      }).toList();

      await _apiStore.placeOrder(
        cart: cartData,
        address: address,
        city: city,
        phone: phone,
        paymentMethod: paymentMethod,
      );

      clearCart();

      isPlacingOrder = false;
      notifyListeners();
      return true;
    } catch (e) {
      placeOrderError = e.toString().replaceFirst('Exception: ', '');
      isPlacingOrder = false;
      notifyListeners();
      return false;
    }
  }
}