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


      if (request.files.isNotEmpty) {

      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);



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
      return false;
    }
  }
}