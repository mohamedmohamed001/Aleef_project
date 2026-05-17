import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../presentation/models/product_model.dart';
import '../services/api_store.dart';
import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';

class StoreProvider extends ChangeNotifier {
  final ApiStore _apiStore = ApiStore();

  List<ProductModel> cartItems = [];
  Map<String, int> itemQuantities = {};

  bool addToCart(ProductModel product, int quantity) {
    final String productId = product.id.toString();
    final int currentQty = itemQuantities[productId] ?? 0;
    final int newQty = currentQty + quantity;

    if (quantity <= 0) return false;
    if (newQty > product.stock) return false;

    final int index = cartItems.indexWhere((item) => item.id == product.id);

    if (index == -1) {
      cartItems.add(product);
    }

    itemQuantities[productId] = newQty;
    notifyListeners();
    return true;
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.id.toString() == productId);
    itemQuantities.remove(productId);
    notifyListeners();
  }

  void incrementCartQuantity(String productId) {
    final int index = cartItems.indexWhere(
          (item) => item.id.toString() == productId,
    );

    if (index == -1) return;

    final product = cartItems[index];
    final currentQty = itemQuantities[productId] ?? 1;

    if (currentQty < product.stock) {
      itemQuantities[productId] = currentQty + 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    if (!itemQuantities.containsKey(productId)) return;

    if (itemQuantities[productId]! > 1) {
      itemQuantities[productId] = itemQuantities[productId]! - 1;
    } else {
      removeFromCart(productId);
      return;
    }

    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in cartItems) {
      int qty = itemQuantities[item.id.toString()] ?? 1;
      total += (item.finalPrice * qty);
    }
    return total;
  }

  List<ProductModel> _allProducts = [];
  List<ProductModel> get allProducts => _allProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasFetched = false;
  bool get hasFetched => _hasFetched;

  Future<void> getAllProducts() async {
    if (_hasFetched) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final products = await _apiStore.getAllProducts();
      _allProducts = products;
      _hasFetched = true;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final products = await _apiStore.getAllProducts();
      _allProducts = products;
      _hasFetched = true;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> upcomingOrders = [];
  List<Map<String, dynamic>> previousOrders = [];
  bool isLoadingUpcoming = false;
  bool isLoadingPrevious = false;

  Future<void> getUpcomingOrders() async {
    final String baseUrl = ApiConstant.baseUrl;
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    isLoadingUpcoming = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-upcoming-orders'),
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
      print(e);
    }

    isLoadingUpcoming = false;
    notifyListeners();
  }

  Future<void> getPreviousOrders() async {
    final String baseUrl = ApiConstant.baseUrl;
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    isLoadingPrevious = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-previous-orders'),
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
      print(e);
    }

    isLoadingPrevious = false;
    notifyListeners();
  }
}