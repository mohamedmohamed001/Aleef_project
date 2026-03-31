import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/data/models/user_model.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'token';
  static const String _userKey = 'user'; // 👈 ده الجديد

  // 🔹 TOKEN
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // 🔹 USER

  Future<void> saveUser(UserModel user) async {
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user.toJson()), // 👈 نحوله String
    );
  }

  Future<UserModel?> getUser() async {
    final userString = await _storage.read(key: _userKey);

    if (userString == null)  return null;

    final userMap = jsonDecode(userString);

    return UserModel.fromJson(
      Map<String, dynamic>.from(userMap),
    );
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

  // 🔥 (اختياري بس مهم)
  Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}