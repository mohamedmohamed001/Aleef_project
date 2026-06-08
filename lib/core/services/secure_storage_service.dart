import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/appointments/data/models/doctor_model.dart';
import '../../features/auth/data/models/user_model.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  static const String _tokenKey = 'user_token';
  static const String _userKey = 'user';

  static const String _doctorTokenKey = 'doctor_token';
  static const String _doctorKey = 'doctor';

  // ================= USER TOKEN =================

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }

  Future<void> deleteToken() async {
    await _storage.delete(
      key: _tokenKey,
    );
  }

  // ================= USER =================

  Future<void> saveUser(UserModel user) async {
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> getUser() async {
    final userString = await _storage.read(
      key: _userKey,
    );

    if (userString == null) return null;

    final userMap = jsonDecode(userString);

    return UserModel.fromJson(
      Map<String, dynamic>.from(userMap),
    );
  }

  Future<void> deleteUser() async {
    await _storage.delete(
      key: _userKey,
    );
  }

  // ================= DOCTOR TOKEN =================

  Future<void> saveDoctorToken(String token) async {
    await _storage.write(
      key: _doctorTokenKey,
      value: token,
    );
  }

  Future<String?> getDoctorToken() async {
    return await _storage.read(
      key: _doctorTokenKey,
    );
  }

  Future<void> deleteDoctorToken() async {
    await _storage.delete(
      key: _doctorTokenKey,
    );
  }

  // ================= DOCTOR =================

  Future<void> saveDoctor(DoctorModel doctor) async {
    await _storage.write(
      key: _doctorKey,
      value: jsonEncode(doctor.toJson()),
    );
  }

  Future<DoctorModel?> getDoctor() async {
    final doctorString = await _storage.read(
      key: _doctorKey,
    );

    if (doctorString == null) return null;

    final doctorMap = jsonDecode(doctorString);

    return DoctorModel.fromJson(
      Map<String, dynamic>.from(doctorMap),
    );
  }

  Future<void> deleteDoctor() async {
    await _storage.delete(
      key: _doctorKey,
    );
  }

  // ================= LOGOUT =================

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}