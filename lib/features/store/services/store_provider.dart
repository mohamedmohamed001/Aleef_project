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

  void addToCart(ProductModel product) {
    int index = cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      String productId = product.id.toString();
      itemQuantities[productId] = (itemQuantities[productId] ?? 1) + 1;
    } else {
      cartItems.add(product);
      itemQuantities[product.id.toString()] = 1;
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

  void decrementQuantity(String productId) {
    if (itemQuantities.containsKey(productId) &&
        itemQuantities[productId]! > 1) {
      itemQuantities[productId] = itemQuantities[productId]! - 1;
      notifyListeners();
    }
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
