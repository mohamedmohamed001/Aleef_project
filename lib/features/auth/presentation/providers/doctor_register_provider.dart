import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aleef/features/auth/data/services/doctor_auth_api_service.dart';

class DoctorRegisterProvider extends ChangeNotifier {
  final DoctorAuthApiService apiService;

  DoctorRegisterProvider(this.apiService);

  bool isLoading = false;

  Future<bool> registerDoctor({
    required String name,
    required String email,
    required String phone,
    required String licenseNumber,
    required String city,
    required String address,
    required String specialization,
    required double appointmentFee,
    required File profilePic,
    required File NationalIdFront,
    required File NationalIdBack,
    required File IdentityVerificationImage,
    required String password,
  }) async {
    if (isLoading) return false;

    isLoading = true;
    notifyListeners();

    try {
      final success = await apiService.registerDoctor(
        name: name,
        email: email,
        phone: phone,
        licenseNumber: licenseNumber, // سيرفر متوقع license_number
        city: city,
        address: address,
        specialization: specialization,
        appointmentFee: appointmentFee, // number
        profilePic: profilePic,
        NationalIdFront: NationalIdFront,
        NationalIdBack: NationalIdBack,
        IdentityVerificationImage: IdentityVerificationImage,
        password: password,
      );

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Doctor registration error: $e");
      return false;
    }
  }
}