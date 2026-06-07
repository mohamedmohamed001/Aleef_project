import 'package:dio/dio.dart';

import '../../../core/constants/api_constant.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/service_locator.dart';

class ChatApi {
  final String _baseUrl = ApiConstant.baseUrl;
  final SecureStorageService _storage = getIt<SecureStorageService>();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<Map<String, dynamic>> getChats() async {
    try {
      final response = await _dio.get(
        '/chats',
        options: await _authOptions(),
      );

      if (_isSuccess(response.statusCode)) {
        final responseData = _asMap(response.data);
        final chats = responseData['chats'];

        return {
          'status': 'success',
          'data': chats is List ? chats : [],
        };
      }

      if (_isUnauthorized(response.statusCode)) {
        return {'status': 'unauthorized'};
      }

      return {
        'status': 'error',
        'message': _errorMessage(response.data),
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getChatMessages(String chatId) async {
    try {
      final response = await _dio.get(
        '/chats/$chatId/messages',
        options: await _authOptions(),
      );

      if (_isSuccess(response.statusCode)) {
        final responseData = _asMap(response.data);

        return {
          'status': 'success',
          'messages': responseData['messages'] is List
              ? responseData['messages']
              : [],
          'user': responseData['user'],
        };
      }

      if (_isUnauthorized(response.statusCode)) {
        return {'status': 'unauthorized'};
      }

      return {
        'status': 'error',
        'message': _errorMessage(response.data),
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getChatbotMessages() async {
    try {
      final response = await _dio.get(
        '/chats/chatbot',
        options: await _authOptions(),
      );

      if (_isSuccess(response.statusCode)) {
        final responseData = _asMap(response.data);

        return {
          'status': 'success',
          'messages': responseData['messages'] is List
              ? responseData['messages']
              : [],
        };
      }

      if (_isUnauthorized(response.statusCode)) {
        return {'status': 'unauthorized'};
      }

      return {
        'status': 'error',
        'message': _errorMessage(response.data),
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Future<Options> _authOptions() async {
    final token = await _storage.getToken();

    return Options(
      headers: {
        'Authorization': 'Bearer ${token ?? ''}',
      },
    );
  }

  bool _isSuccess(int? statusCode) {
    return statusCode == 200 || statusCode == 201;
  }

  bool _isUnauthorized(int? statusCode) {
    return statusCode == 401 || statusCode == 403;
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return {};
  }

  String _errorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'Something went wrong';
    }

    return 'Something went wrong';
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;

    if (_isUnauthorized(statusCode)) {
      return {'status': 'unauthorized'};
    }

    return {
      'status': 'error',
      'message': e.message ?? 'Network error',
    };
  }
}