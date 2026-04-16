import 'dart:convert';
import 'package:aleef/core/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';
import '../presentation/models/product_model.dart';

class ApiStore {
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final String baseUrl = ApiConstant.baseUrl;
      final storage = getIt<SecureStorageService>();
      final token = await storage.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/products?limit=100'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final List productsJson = data['products'] ?? [];
        return productsJson.map((json) => ProductModel.fromJson(json)).toList();
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
}
