import 'package:flutter/material.dart';

import '../../../core/exceptions/session_expired_exception.dart';
import '../presentation/models/product_model.dart';
import '../services/api_store.dart';

class StoreProvider extends ChangeNotifier {
  final ApiStore _apiStore = ApiStore();

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
      final response = await _apiStore.calculateCart(
        cart: cartRequestBody,
      );

      cartSubtotal = response.subTotal;
      cartDelivery = response.delivery;
      cartTotal = response.total;
    } on SessionExpiredException catch (e) {
      cartErrorMessage = e.message;
      cartSubtotal = totalPrice;
      cartDelivery = 0.0;
      cartTotal = totalPrice;
    } catch (e) {
      cartErrorMessage = e.toString().replaceFirst('Exception: ', '');
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
    } on SessionExpiredException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
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
    } on SessionExpiredException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
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
    } on SessionExpiredException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
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

  String? upcomingOrdersError;
  String? previousOrdersError;

  Future<void> getUpcomingOrders() async {
    isLoadingUpcoming = true;
    upcomingOrdersError = null;
    notifyListeners();

    try {
      upcomingOrders = await _apiStore.getUpcomingOrders();
    } on SessionExpiredException catch (e) {
      upcomingOrdersError = e.message;
    } catch (e) {
      upcomingOrdersError = e.toString().replaceFirst('Exception: ', '');
      debugPrint(upcomingOrdersError);
    }

    isLoadingUpcoming = false;
    notifyListeners();
  }

  Future<void> getPreviousOrders() async {
    isLoadingPrevious = true;
    previousOrdersError = null;
    notifyListeners();

    try {
      previousOrders = await _apiStore.getPreviousOrders();
    } on SessionExpiredException catch (e) {
      previousOrdersError = e.message;
    } catch (e) {
      previousOrdersError = e.toString().replaceFirst('Exception: ', '');
      debugPrint(previousOrdersError);
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
    } on SessionExpiredException catch (e) {
      placeOrderError = e.message;
      isPlacingOrder = false;
      notifyListeners();
      return false;
    } catch (e) {
      placeOrderError = e.toString().replaceFirst('Exception: ', '');
      isPlacingOrder = false;
      notifyListeners();
      return false;
    }
  }
}