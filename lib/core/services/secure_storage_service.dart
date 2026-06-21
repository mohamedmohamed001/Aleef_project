import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/appointments/data/models/doctor_model.dart';
import '../../features/auth/data/models/user_model.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'user_token';
  static const String _userKey = 'user';

  static const String _doctorTokenKey = 'doctor_token';
  static const String _doctorKey = 'doctor';

  static const String _selectedPetIdKey = 'selected_pet_id';

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

    if (userString == null || userString.isEmpty) return null;

    try {
      final userMap = jsonDecode(userString);

      return UserModel.fromJson(
        Map<String, dynamic>.from(userMap),
      );
    } catch (_) {
      await deleteUser();
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _storage.delete(
      key: _userKey,
    );
  }

  // ================= SELECTED PET =================

  Future<void> saveSelectedPetId(String petId) async {
    await _storage.write(
      key: _selectedPetIdKey,
      value: petId,
    );
  }

  Future<String?> getSelectedPetId() async {
    return await _storage.read(
      key: _selectedPetIdKey,
    );
  }

  Future<void> deleteSelectedPetId() async {
    await _storage.delete(
      key: _selectedPetIdKey,
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

    if (doctorString == null || doctorString.isEmpty) return null;

    try {
      final doctorMap = jsonDecode(doctorString);

      return DoctorModel.fromJson(
        Map<String, dynamic>.from(doctorMap),
      );
    } catch (_) {
      await deleteDoctor();
      return null;
    }
  }

  Future<void> deleteDoctor() async {
    await _storage.delete(
      key: _doctorKey,
    );
  }

  // ================= NOTIFICATION SETTINGS =================

  static const String _pushNotificationsKey =
      'push_notifications_enabled';

  static const String _appointmentRemindersKey =
      'appointment_reminders_enabled';

  static const String _orderUpdatesKey =
      'order_updates_enabled';

  static const String _chatMessagesKey =
      'chat_messages_enabled';

  Future<void> saveBool({
    required String key,
    required bool value,
  }) async {
    await _storage.write(
      key: key,
      value: value.toString(),
    );
  }

  Future<bool?> getBool({
    required String key,
  }) async {
    final value = await _storage.read(
      key: key,
    );

    if (value == null) return null;

    return value.toLowerCase() == 'true';
  }

  Future<void> saveNotificationSettings({
    required bool pushNotifications,
    required bool appointmentReminders,
    required bool orderUpdates,
    required bool chatMessages,
  }) async {
    await saveBool(
      key: _pushNotificationsKey,
      value: pushNotifications,
    );

    await saveBool(
      key: _appointmentRemindersKey,
      value: appointmentReminders,
    );

    await saveBool(
      key: _orderUpdatesKey,
      value: orderUpdates,
    );

    await saveBool(
      key: _chatMessagesKey,
      value: chatMessages,
    );
  }

  Future<Map<String, bool>> getNotificationSettings() async {
    final pushNotifications = await getBool(
      key: _pushNotificationsKey,
    );

    final appointmentReminders = await getBool(
      key: _appointmentRemindersKey,
    );

    final orderUpdates = await getBool(
      key: _orderUpdatesKey,
    );

    final chatMessages = await getBool(
      key: _chatMessagesKey,
    );

    return {
      'pushNotifications': pushNotifications ?? true,
      'appointmentReminders': appointmentReminders ?? true,
      'orderUpdates': orderUpdates ?? true,
      'chatMessages': chatMessages ?? true,
    };
  }

  Future<void> clearNotificationSettings() async {
    await _storage.delete(key: _pushNotificationsKey);
    await _storage.delete(key: _appointmentRemindersKey);
    await _storage.delete(key: _orderUpdatesKey);
    await _storage.delete(key: _chatMessagesKey);
  }

  // ================= USER LOGOUT =================

  Future<void> clearUserAuthData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _selectedPetIdKey);

    // Old user keys cleanup
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'userToken');
    await _storage.delete(key: 'user_token');
    await _storage.delete(key: 'user');
  }

  // ================= DOCTOR LOGOUT =================

  Future<void> clearDoctorAuthData() async {
    await _storage.delete(key: _doctorTokenKey);
    await _storage.delete(key: _doctorKey);

    // Old doctor keys cleanup
    await _storage.delete(key: 'doctorToken');
    await _storage.delete(key: 'doctor_token');
    await _storage.delete(key: 'doctor');
  }

  // ================= LOGOUT ALL =================

  Future<void> clearAll() async {
    await clearUserAuthData();
    await clearDoctorAuthData();

    // مخليناش notification settings تتمسح مع logout
    // عشان تفضل محفوظة على نفس الجهاز
  }

  // ================= DANGEROUS CLEAR =================
  // استخدمها بس لو عايز تمسح كل حاجة من الجهاز نهائيًا
  // بما فيهم notification settings

  Future<void> deleteEverything() async {
    await _storage.deleteAll();
  }
}