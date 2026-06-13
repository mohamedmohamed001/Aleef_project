import 'dart:io';
import 'package:aleef/features/appointments/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../../../../core/services/service_locator.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../data/services/doctor_profile_service.dart';

class DoctorProfileProvider with ChangeNotifier {
  final SecureStorageService _storage = getIt<SecureStorageService>();
  final DoctorProfileService _profileService = DoctorProfileService();

  DoctorProfileModel? _doctorProfile;
  List<ScheduleItem> _doctorSchedule = [];
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;

  // Getters
  DoctorProfileModel? get doctorProfile => _doctorProfile;
  List<ScheduleItem> get doctorSchedule => _doctorSchedule;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  // 1. جلب بيانات البروفايل (تُحمل الجدول معها تلقائياً)
  Future<void> fetchDoctorProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();
      if (token == null) throw Exception("Authentication token missing.");

      _doctorProfile = await _profileService.getDoctorProfile(token);
      _doctorSchedule = _doctorProfile?.schedule ?? [];
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception:", "").trim();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. تحديث البروفايل (اسم، تليفون، صورة)
  Future<bool> updateProfile({
    required Map<String, String> bodyData,
    File? imageFile,
  }) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();
      if (token == null) throw Exception("Authentication token missing.");

      // الخدمة ستتلقى البيانات وستقوم بدمجها في multipart request
      final updatedDoctor = await _profileService.updateDoctorProfile(
        token: token,
        bodyData: bodyData,
        imageFile: imageFile,
      );
      print("بيانات الطبيب التي عادت من السيرفر: ${updatedDoctor.toJson()}");

      // تحديث الحالة المحلية بالبيانات الجديدة القادمة من السيرفر
      _doctorProfile = updatedDoctor;
      _doctorSchedule = updatedDoctor.schedule;

      // تحديث الـ Secure Storage
      await _storage.saveDoctor(DoctorModel.fromJson(updatedDoctor.toJson()));

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception:", "").trim();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // 3. جلب الجدول (بشكل منفصل)
  Future<void> fetchDoctorSchedule() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();
      if (token != null) {
        _doctorSchedule = await _profileService.getDoctorSchedule(token);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception:", "").trim();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. تحديث الجدول
  Future<bool> updateDoctorSchedule(List<ScheduleItem> newSchedule) async {
    _isUpdating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _storage.getDoctorToken();
      if (token == null) return false;

      _doctorSchedule = await _profileService.updateDoctorSchedule(
        token: token,
        updatedSchedule: newSchedule,
      );

      // تحديث البروفايل محلياً ليعكس التغيير في الجدول
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
          clinicAddress: _doctorProfile!.clinicAddress,
          profilePic: _doctorProfile!.profilePic,
          schedule: _doctorSchedule,
        );
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception:", "").trim();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // 5. مسح البيانات عند تسجيل الخروج
  void clearProfile() {
    _doctorProfile = null;
    _doctorSchedule = [];
    _errorMessage = null;
    notifyListeners();
  }
}
