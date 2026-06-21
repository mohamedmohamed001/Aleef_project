import 'package:flutter/material.dart';

import '../../data/models/medical_record_details_model.dart';
import '../../data/sevices/medical_record_api_service.dart';

class MedicalRecordDetailsProvider extends ChangeNotifier {
  final MedicalRecordApiService _apiService = MedicalRecordApiService();

  MedicalRecordDetailsModel? _record;
  MedicalRecordDetailsModel? get record => _record;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getMedicalRecordDetails(
      String recordId, {
        bool useDoctorToken = false,
      }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _record = await _apiService.getMedicalRecordDetails(
        recordId,
        useDoctorToken: useDoctorToken,
      );
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Failed to load medical record details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _record = null;
    _errorMessage = null;
    _isLoading = false;
  }
}