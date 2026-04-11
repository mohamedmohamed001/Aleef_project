import 'package:flutter/material.dart';
import '../presentation/models/product_model.dart';
import '../services/api_store.dart';

class StoreProvider extends ChangeNotifier {
  final ApiStore _apiStore = ApiStore();

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
}