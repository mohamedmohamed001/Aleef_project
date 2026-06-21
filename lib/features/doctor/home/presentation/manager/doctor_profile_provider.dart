import 'dart:io';

import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';

import '../../../../../core/services/secure_storage_service.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/services/session_service.dart';
import '../../../../../core/services/socket_service.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../data/services/doctor_profile_service.dart';

class DoctorProfileProvider with ChangeNotifier {
  final SecureStorageService _storage = getIt<SecureStorageService>();
  final DoctorProfileService _profileService = DoctorProfileService();
  final SessionService _sessionService = getIt<SessionService>();

  DoctorProfileModel? _doctorProfile;
  List<ScheduleItem> _doctorSchedule = [];

  bool _isLoading = false;
  bool _isUpdating = false;
  bool _isLogoutLoading = false;
  bool _isChangingPassword = false;

  String? _errorMessage;

  DoctorProfileModel? get doctorProfile => _doctorProfile;
  List<ScheduleItem> get doctorSchedule => _doctorSchedule;

  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  bool get isLogoutLoading => _isLogoutLoading;
  bool get isChangingPassword => _isChangingPassword;

  String? get errorMessage => _errorMessage;

  String _cleanError(Object error) {
    return error.toString().replaceAll("Exception:", "").trim();
  }

  DoctorModel _toDoctorModel(DoctorProfileModel profile) {
    return DoctorModel.fromJson(profile.toJson());
  }

  Future<void> _saveUpdatedDoctorSession(DoctorProfileModel profile) async {
    final doctorModel = _toDoctorModel(profile);

    await _storage.saveDoctor(doctorModel);

    final token = await _storage.getDoctorToken();

    if (token != null && token.trim().isNotEmpty) {
      _sessionService.setDoctorSession(
        doctor: doctorModel,
        doctorTokenValue: token,
      );
    }
  }

  // ================= FETCH DOCTOR PROFILE =================

  Future<void> fetchDoctorProfile() async {
    if (_isLogoutLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception("Authentication token missing.");
      }

      _doctorProfile = await _profileService.getDoctorProfile(token);
      _doctorSchedule = _doctorProfile?.schedule ?? [];

      if (_doctorProfile != null) {
        await _saveUpdatedDoctorSession(_doctorProfile!);
      }
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= UPDATE DOCTOR PROFILE =================

  Future<bool> updateProfile({
    required Map<String, String> bodyData,
    File? imageFile,
  }) async {
    if (_isUpdating) return false;

    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception("Authentication token missing.");
      }

      final updatedDoctor = await _profileService.updateDoctorProfile(
        token: token,
        bodyData: bodyData,
        imageFile: imageFile,
      );

      _doctorProfile = updatedDoctor;
      _doctorSchedule = updatedDoctor.schedule;

      await _saveUpdatedDoctorSession(updatedDoctor);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // ================= FETCH DOCTOR SCHEDULE =================

  Future<void> fetchDoctorSchedule() async {
    if (_isLogoutLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception("Authentication token missing.");
      }

      _doctorSchedule = await _profileService.getDoctorSchedule(token);

      if (_doctorProfile != null) {
        _doctorProfile = DoctorProfileModel(
          id: _doctorProfile!.id,
          name: _doctorProfile!.name,
          email: _doctorProfile!.email,
          phone: _doctorProfile!.phone,
          city: _doctorProfile!.city,
          specialization: _doctorProfile!.specialization,
          about: _doctorProfile!.about,
          clinicName: _doctorProfile!.clinicName,
          address: _doctorProfile!.address,
          profilePic: _doctorProfile!.profilePic,
          appointmentFee: _doctorProfile!.appointmentFee,
          schedule: _doctorSchedule,
        );

        await _saveUpdatedDoctorSession(_doctorProfile!);
      }
    } catch (e) {
      _errorMessage = _cleanError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= UPDATE DOCTOR SCHEDULE =================

  Future<bool> updateDoctorSchedule(List<ScheduleItem> newSchedule) async {
    if (_isUpdating) return false;

    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception("Authentication token missing.");
      }

      _doctorSchedule = await _profileService.updateDoctorSchedule(
        token: token,
        updatedSchedule: newSchedule,
      );

      if (_doctorProfile != null) {
        _doctorProfile = DoctorProfileModel(
          id: _doctorProfile!.id,
          name: _doctorProfile!.name,
          email: _doctorProfile!.email,
          phone: _doctorProfile!.phone,
          city: _doctorProfile!.city,
          specialization: _doctorProfile!.specialization,
          about: _doctorProfile!.about,
          clinicName: _doctorProfile!.clinicName,
          address: _doctorProfile!.address,
          profilePic: _doctorProfile!.profilePic,
          appointmentFee: _doctorProfile!.appointmentFee,
          schedule: _doctorSchedule,
        );

        await _saveUpdatedDoctorSession(_doctorProfile!);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // ================= CHANGE DOCTOR PASSWORD =================

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_isChangingPassword) return false;

    _isChangingPassword = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception("Authentication token missing.");
      }

      final success = await _profileService.changePassword(
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        _errorMessage = null;
        return true;
      }

      _errorMessage = "Password change failed. Please try again.";
      return false;
    } catch (e) {
      _errorMessage = _cleanError(e);
      return false;
    } finally {
      _isChangingPassword = false;
      notifyListeners();
    }
  }

  // ================= DOCTOR LOGOUT =================

  Future<bool> logOut() async {
    if (_isLogoutLoading) return false;

    _isLogoutLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      try {
        await _profileService.logOut();
      } catch (_) {
        // حتى لو API logout فشل، هنكمل local logout
      }

      SocketService().disconnect();

      await _storage.clearDoctorAuthData();

      _sessionService.clearDoctorSession();

      _errorMessage = null;

      return true;
    } catch (e) {
      _errorMessage = _cleanError(e);
      return false;
    } finally {
      _isLogoutLoading = false;
      notifyListeners();
    }
  }

  // ================= CLEAR LOCAL PROFILE STATE =================

  void clearProfile() {
    _doctorProfile = null;
    _doctorSchedule = [];
    _errorMessage = null;
    notifyListeners();
  }
}