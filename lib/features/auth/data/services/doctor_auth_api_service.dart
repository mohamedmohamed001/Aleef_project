import 'dart:io';
import 'package:aleef/core/constants/api_constant.dart';
import 'package:dio/dio.dart';

class DoctorAuthApiService {
  final Dio _dio;
  final baseUrl = ApiConstant.baseUrl;
  DoctorAuthApiService([Dio? dio]) : _dio = dio ?? Dio();

  Future<bool> registerDoctor({
    required String name,
    required String email,
    required String phone,
    required String licenseNumber,
    required String city,
    required String password,
    required String address,
    required String specialization,
    required double appointmentFee,
    required File profilePic,
    required File NationalIdFront,
    required File NationalIdBack,
    required File IdentityVerificationImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'license_number': licenseNumber, // backend expects this key
        'city': city,
        'address': address,
        'specialization': specialization,
        'appointmentFee': appointmentFee, // send as number
        'profilePic': await MultipartFile.fromFile(
          profilePic.path,
          filename: profilePic.path.split('/').last,
        ),
        'NationalIdFront': await MultipartFile.fromFile(
          NationalIdFront.path,
          filename: NationalIdFront.path.split('/').last,
        ),
        'NationalIdBack': await MultipartFile.fromFile(
          NationalIdBack.path,
          filename: NationalIdBack.path.split('/').last,
        ),
        'IdentityVerificationImage': await MultipartFile.fromFile(
          IdentityVerificationImage.path,
          filename: IdentityVerificationImage.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '$baseUrl/doctors/register', // تأكد URL صح
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          validateStatus: (_) => true, // يسمح بمشاهدة أي status
        ),
      );

      print('Doctor registration status code: ${response.statusCode}');
      print('Doctor registration response body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Doctor registration error: $e');
      return false;
    }
  }
  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/doctors/verify-email',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  Future<Map<String, dynamic>?> login(
      String email,
      String password,
      ) async {
    try {
      final response = await _dio.post(
        '$baseUrl/doctors/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Doctor login response: ${response.data}');

      return response.data;
    } catch (e) {
      print('Doctor login error: $e');
      return null;
    }
  }


}