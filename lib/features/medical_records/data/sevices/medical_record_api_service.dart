import 'dart:convert';

import 'package:aleef/core/constants/api_constant.dart';
import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import '../models/medical_record_details_model.dart';

class MedicalRecordApiService {
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<MedicalRecordDetailsModel> getMedicalRecordDetails(
      String recordId, {
        bool useDoctorToken = false,
      }) async {
    final String? token = useDoctorToken
        ? await _secureStorage.getDoctorToken()
        : await _secureStorage.getToken();

    final url = Uri.parse(
      '${ApiConstant.baseUrl}/pets/medical-record/$recordId',
    );

    final response = await http.get(
      url,
      headers: {
        if (token != null && token.trim().isNotEmpty)
          'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      return MedicalRecordDetailsModel.fromJson(data['medicalRecord']);
    }

    throw Exception(
      'Failed to get medical record details: ${response.statusCode} ${response.body}',
    );
  }
}