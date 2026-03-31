import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constant.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../auth/data/models/user_model.dart';

class ProfileApi {
  Future<bool> editProfile(String name, String phone) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/edit-user-profile");

    try {
      final storage = getIt<SecureStorageService>();
      final session = getIt<SessionService>();
      final token = await storage.getToken();

      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("editProfile response: $data");

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveUser(user);
        final savedToken = await storage.getToken();

        session.setSession(
          user: user,
          tokenValue: savedToken ?? '',
        );

        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint("editProfile error: $error");
      return false;
    }
  }

  Future<bool> removeProfilePic() async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/edit-user-profile");

    try {
      final storage = getIt<SecureStorageService>();
      final session = getIt<SessionService>();
      final token = await storage.getToken();

      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "deleteProfilePic": "true",
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("removeProfilePic response: $data");

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveUser(user);
        final savedToken = await storage.getToken();

        session.setSession(
          user: user,
          tokenValue: savedToken ?? '',
        );

        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint("removeProfilePic error: $error");
      return false;
    }
  }

  Future<bool> editProfileWithImage({required String name, required String phone, File? imageFile,}) async {
    final url = Uri.parse("${ApiConstant.baseUrl}/users/edit-user-profile");

    try {
      final storage = getIt<SecureStorageService>();
      final session = getIt<SessionService>();
      final token = await storage.getToken();

      final request = http.MultipartRequest('PATCH', url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields['name'] = name;
      request.fields['phone'] = phone;

      if (imageFile != null) {
        request.fields['changeProfilePic'] = 'true';

        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePic',
            imageFile.path,
          ),
        );
      } else {
        request.fields['changeProfilePic'] = 'false';
      }

      debugPrint("request fields: ${request.fields}");
      debugPrint("request files count: ${request.files.length}");

      if (request.files.isNotEmpty) {
        debugPrint("file field name: ${request.files.first.field}");
        debugPrint("file path: ${imageFile?.path}");
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("editProfileWithImage status code: ${response.statusCode}");
      debugPrint("editProfileWithImage body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data['user']),
        );

        await storage.saveUser(user);
        final savedToken = await storage.getToken();

        session.setSession(
          user: user,
          tokenValue: savedToken ?? '',
        );

        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugPrint("editProfileWithImage error: $error");
      return false;
    }
  }
}