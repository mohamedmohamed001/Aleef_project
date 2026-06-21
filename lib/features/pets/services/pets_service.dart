import 'package:aleef/core/constants/api_constant.dart';
import 'package:dio/dio.dart';

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
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['pets'] as List<dynamic>;
      } else {
        throw Exception("Failed to load pets");
      }
    } on DioException catch (e) {
      throw Exception(
        "Error loading pets: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error loading pets: $e");
    }
  }

  Future<void> addPet({
    required String name,
    required String type,
    required String gender,
    required double weight,
    required String birthDate,
    String? breed,
    String? imagePath,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "weight": weight.toString(),
        "name": name,
        "type": type,
        "gender": gender,
        "birthDate": birthDate,
      };

      if (breed != null && breed.trim().isNotEmpty) {
        data["breed"] = breed.trim();
      }

      if (imagePath != null && imagePath.trim().isNotEmpty) {
        data["profilePic"] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      final formData = FormData.fromMap(data);

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
    } on DioException catch (e) {
      throw Exception(
        "Error adding pet: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error adding pet: $e");
    }
  }

  Future<Map<String, dynamic>> getPetById(String petId, String token) async {
    try {
      final response = await _dio.get(
        "$baseUrl/pets/$petId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception("Failed to load pet details");
      }
    } on DioException catch (e) {
      throw Exception(
        "Error fetching pet details: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error fetching pet details: $e");
    }
  }

  Future<Map<String, dynamic>> getPetByIdWithoutToken(String petId) async {
    try {
      final response = await _dio.get(
        "$baseUrl/pets/$petId",
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception("Failed to load pet details");
      }
    } on DioException catch (e) {
      throw Exception(
        "Error fetching pet details without token: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error fetching pet details without token: $e");
    }
  }

  Future<void> updatePet({
    required String petId,
    String? name,
    String? type,
    String? gender,
    String? breed,
    double? weight,
    int? age,
    String? birthDate,
    bool? deleteProfilePic,
    String? imagePath,
    required String token,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {};

      if (name != null && name.trim().isNotEmpty) {
        dataMap["name"] = name.trim();
      }

      if (type != null && type.trim().isNotEmpty) {
        dataMap["type"] = type.trim();
      }

      if (gender != null && gender.trim().isNotEmpty) {
        dataMap["gender"] = gender.trim();
      }

      if (breed != null && breed.trim().isNotEmpty) {
        dataMap["breed"] = breed.trim();
      }

      if (age != null) {
        dataMap["age"] = age;
      }

      if (weight != null) {
        dataMap["weight"] = weight;
      }

      if (birthDate != null && birthDate.trim().isNotEmpty) {
        dataMap["birthDate"] = birthDate.trim();
      }

      if (deleteProfilePic != null) {
        dataMap["deleteProfilePic"] = deleteProfilePic;
      }

      if (imagePath != null &&
          imagePath.trim().isNotEmpty &&
          !imagePath.startsWith('http') &&
          !imagePath.startsWith('assets')) {
        dataMap["profilePic"] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      final formData = FormData.fromMap(dataMap);

      final String url = "$baseUrl/pets/$petId";

      await _dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        "Error updating pet: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error updating pet: $e");
    }
  }

  Future<void> deletePetFromApi(String petId, String token) async {
    try {
      await _dio.delete(
        "$baseUrl/pets/$petId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        "Error deleting pet: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error deleting pet: $e");
    }
  }
}