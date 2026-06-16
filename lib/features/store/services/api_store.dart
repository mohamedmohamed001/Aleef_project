import 'dart:convert';
import 'package:aleef/core/constants/api_constant.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';
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

class ApiStore {
  Future<ProductPaginationResponse> getAllProducts({
    int page = 1,
    int limit = 8,
    String? category,
    num? minPrice,
    num? maxPrice,
    String? search,
    String? sort,
  }) async {
    try {
      final String baseUrl = ApiConstant.baseUrl;
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null && category.trim().isNotEmpty)
          'category': category.trim(),
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (search != null && search.trim().isNotEmpty)
          'search': search.trim(),
        if (sort != null && sort.trim().isNotEmpty) 'sort': sort.trim(),
      };

      final uri = Uri.parse('$baseUrl/products').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final List productsJson = data['products'] ?? [];

        return ProductPaginationResponse(
          products:
          productsJson.map((json) => ProductModel.fromJson(json)).toList(),
          page: int.tryParse(data['page']?.toString() ?? '1') ?? 1,
          totalPages:
          int.tryParse(data['totalPages']?.toString() ?? '1') ?? 1,
          totalProducts:
          int.tryParse(data['totalProducts']?.toString() ?? '0') ?? 0,
        );
      } else {
        throw Exception('Failed to load products: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in getAllProducts: $error');
    }
  }

  Future<ProductModel> getAllProductsDetails(String id) async {
    try {
      final String baseUrl = ApiConstant.baseUrl;
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ProductModel.fromJson(data["product"]);
      } else {
        throw Exception('Failed to load product details: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in getAllProductsDetails: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getUpcomingOrders() async {
    try {
      final String baseUrl = ApiConstant.baseUrl;
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-upcoming-orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['orders']);
      } else {
        throw Exception('Failed to load upcoming orders: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in getUpcomingOrders: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getPreviousOrders() async {
    try {
      final String baseUrl = ApiConstant.baseUrl;
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/orders/my-previous-orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['orders']);
      } else {
        throw Exception('Failed to load previous orders: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error in getPreviousOrders: $error');
    }
  }

  Future<Map<String, dynamic>> placeOrder({
    required List<Map<String, dynamic>> cart,
    required String address,
    required String city,
    required String phone,
    required String paymentMethod,
  }) async {
    final String baseUrl = ApiConstant.baseUrl;
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/orders/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(data['message'] ?? 'Failed to place order');
  }
}