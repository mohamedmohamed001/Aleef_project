import 'package:flutter/material.dart';


import '../data/models/doctor_performance_model.dart';
import '../data/services/doctor_performance_api_service.dart';

class DoctorPerformanceProvider extends ChangeNotifier {
  final DoctorPerformanceApiService _apiService =
  DoctorPerformanceApiService();

  DoctorPerformanceModel? performance;

  bool isLoading = false;
  String? errorMessage;

  Future<void> getDoctorPerformance() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _apiService.getDoctorPerformance();

    if (result['status'] == 'success') {
      performance = DoctorPerformanceModel.fromJson(result);
    } else {
      performance = null;
      errorMessage = result['message'] ?? 'Something went wrong';
    }

    isLoading = false;
    notifyListeners();
  }
}