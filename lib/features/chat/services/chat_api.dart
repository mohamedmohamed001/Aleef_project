import 'dart:io';

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
          'chatId': responseData['chatId'],
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

  Future<Map<String, dynamic>> uploadChatbotImage(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/chats/chatbot/image',
        data: formData,
        options: await _authOptions(
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      if (_isSuccess(response.statusCode)) {
        final responseData = _asMap(response.data);

        if (responseData['status'] == 'success' &&
            responseData['image'] != null) {
          return {
            'status': 'success',
            'image': responseData['image'].toString(),
          };
        }

        return {
          'status': 'error',
          'message': responseData['message']?.toString() ??
              'Image uploaded but URL not found',
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

  Future<Options> _authOptions({String? contentType}) async {
    final token = await _storage.getToken();
    final doctorToken = await _storage.getDoctorToken();

    return Options(
      contentType: contentType,
      headers: {
        'Authorization': 'Bearer ${token ?? doctorToken ?? ''}',
        'Accept': 'application/json',
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
      'message': e.response?.data is Map<String, dynamic>
          ? _errorMessage(e.response?.data)
          : e.message ?? 'Network error',
    };
  }
}