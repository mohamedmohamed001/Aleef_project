import 'dart:io';
import 'package:aleef/core/constants/api_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';

class PetsService {
  final Dio _dio = Dio();

  PetsService() {
    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );
  }

  final String baseUrl = ApiConstant.baseUrl;

  Future<List<dynamic>> getPets(String token) async {
    try {
      final response = await _dio.get(
        "$baseUrl/pets/get-my-pets",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        return response.data['pets'];
      } else {
        throw Exception("Failed to load pets");
      }
    } catch (e) {
      throw Exception("Error loading pets: $e");
    }
  }

  Future<void> addPet({
    required String name,
    required String type,
    required String gender,
    required double weight,
    required int age,
    required String imagePath,
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        "weight": weight.toString(),
        "name": name,
        "type": type,
        "gender": gender,
        "age": age.toString(),
        "profilePic": await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      await _dio.post(
        "$baseUrl/pets",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } catch (e) {
      throw Exception("Error adding pet: $e");
    }
  }

  Future<Map<String, dynamic>> getPetById(String petId, String token) async {
    try {
      final response = await _dio.get(
        "$baseUrl/pets/$petId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load pet details");
      }
    } catch (e) {
      throw Exception("Error fetching pet details: $e");
    }
  }

  Future<void> updatePet({
    required String petId,
    String? name,
    String? type,
    String? gender,
    double? weight,
    int? age,
    String? birthDate,
    bool? deleteProfilePic,
    String? imagePath,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {};
      if (name != null) dataMap["name"] = name;
      if (type != null) dataMap["type"] = type;
      if (gender != null) dataMap["gender"] = gender;
      if (age != null) dataMap["age"] = age.toString();
      if (weight != null) dataMap["weight"] = weight.toString();
      if (birthDate != null) dataMap["birthDate"] = birthDate;
      if (deleteProfilePic != null)
        dataMap["deleteProfilePic"] = deleteProfilePic.toString();

      if (imagePath != null &&
          !imagePath.startsWith('http') &&
          !imagePath.startsWith('assets')) {
        dataMap["profilePic"] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      final formData = FormData.fromMap(dataMap);
      await _dio.patch(
        "$baseUrl/pets/$petId",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
    } catch (e) {
      throw Exception("Error updating pet: $e");
    }
  }

  Future<void> deletePetFromApi(String petId, String token) async {
    try {
      await _dio.delete(
        "$baseUrl/pets/$petId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      throw Exception("Error deleting pet: $e");
    }
  }
}
