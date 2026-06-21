import 'dart:convert';

import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/exceptions/session_expired_exception.dart';
import 'package:aleef/core/services/auth_guard_service.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:http/http.dart' as http;

import '../presentation/models/product_model.dart';

class ProductPaginationResponse {
  final List<ProductModel> products;
  final int page;
  final int totalPages;
  final int totalProducts;

  ProductPaginationResponse({
    required this.products,
    required this.page,
    required this.totalPages,
    required this.totalProducts,
  });
}

class CartCalculationResponse {
  final double subTotal;
  final double delivery;
  final double total;

  CartCalculationResponse({
    required this.subTotal,
    required this.delivery,
    required this.total,
  });
}

class ApiStore {
  final SecureStorageService _storage = getIt<SecureStorageService>();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  void _checkSession(http.Response response) {
    if (AuthGuardService.isSessionExpiredResponse(
      statusCode: response.statusCode,
      body: response.body,
    )) {
      throw SessionExpiredException();
    }
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }

  String _errorMessage(http.Response response, String fallback) {
    try {
      final data = _decodeBody(response);

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Future<ProductPaginationResponse> getAllProducts({
    int page = 1,
    int limit = 8,
    String? category,
    num? minPrice,
    num? maxPrice,
    String? search,
    String? sort,
  }) {
    return AuthGuardService.runWithAutoLogout(() async {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null && category.trim().isNotEmpty)
          'category': category.trim(),
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (sort != null && sort.trim().isNotEmpty) 'sort': sort.trim(),
      };

      final uri = Uri.parse('${ApiConstant.baseUrl}/products').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: await _headers(),
      );

      _checkSession(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _decodeBody(response);
        final List productsJson = data['products'] ?? [];

        return ProductPaginationResponse(
          products: productsJson
              .map((json) => ProductModel.fromJson(json))
              .toList(),
          page: int.tryParse(data['page']?.toString() ?? '1') ?? 1,
          totalPages: int.tryParse(data['totalPages']?.toString() ?? '1') ?? 1,
          totalProducts:
          int.tryParse(data['totalProducts']?.toString() ?? '0') ?? 0,
        );
      }

      throw Exception(_errorMessage(response, 'Failed to load products'));
    });
  }

  Future<ProductModel> getAllProductsDetails(String id) {
    return AuthGuardService.runWithAutoLogout(() async {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/products/$id'),
        headers: await _headers(),
      );

      _checkSession(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _decodeBody(response);
        return ProductModel.fromJson(data["product"]);
      }

      throw Exception(_errorMessage(response, 'Failed to load product details'));
    });
  }

  Future<CartCalculationResponse> calculateCart({
    required List<Map<String, dynamic>> cart,
  }) {
    return AuthGuardService.runWithAutoLogout(() async {
      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/products/calculate-cart'),
        headers: await _headers(),
        body: jsonEncode({
          "cart": cart,
        }),
      );

      _checkSession(response);

      if (response.statusCode == 200) {
        final data = _decodeBody(response);

        final subTotal = _toDouble(data['subTotal']);
        final delivery = _toDouble(data['delivery']);

        return CartCalculationResponse(
          subTotal: subTotal,
          delivery: delivery,
          total: subTotal + delivery,
        );
      }

      throw Exception(_errorMessage(response, 'Failed to calculate cart'));
    });
  }

  Future<List<Map<String, dynamic>>> getUpcomingOrders() {
    return AuthGuardService.runWithAutoLogout(() async {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/orders/my-upcoming-orders'),
        headers: await _headers(),
      );

      _checkSession(response);

      if (response.statusCode == 200) {
        final data = _decodeBody(response);
        return List<Map<String, dynamic>>.from(data['orders'] ?? []);
      }

      throw Exception(_errorMessage(response, 'Failed to load upcoming orders'));
    });
  }

  Future<List<Map<String, dynamic>>> getPreviousOrders() {
    return AuthGuardService.runWithAutoLogout(() async {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/orders/my-previous-orders'),
        headers: await _headers(),
      );

      _checkSession(response);

      if (response.statusCode == 200) {
        final data = _decodeBody(response);
        return List<Map<String, dynamic>>.from(data['orders'] ?? []);
      }

      throw Exception(_errorMessage(response, 'Failed to load previous orders'));
    });
  }

  Future<Map<String, dynamic>> placeOrder({
    required List<Map<String, dynamic>> cart,
    required String address,
    required String city,
    required String phone,
    required String paymentMethod,
  }) {
    return AuthGuardService.runWithAutoLogout(() async {
      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/orders/'),
        headers: await _headers(),
        body: jsonEncode({
          "cart": cart,
          "shippingAddress": {
            "address": address,
            "city": city,
            "phone": phone,
          },
          "paymentMethod": paymentMethod,
        }),
      );

      _checkSession(response);

      final data = _decodeBody(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(data);
      }

      throw Exception(
        data is Map && data['message'] != null
            ? data['message'].toString()
            : 'Failed to place order',
      );
    });
  }
}