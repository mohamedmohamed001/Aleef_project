import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../models/doctor_profile_model.dart';

class DoctorProfileService {
  final String _baseUrl =
      "https://aleef-server-production.up.railway.app/api/v1";

  // 1. جلب بيانات الطبيب (GET)
  Future<DoctorProfileModel> getDoctorProfile(String token) async {
    final url = Uri.parse("$_baseUrl/doctors/me");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // السيرفر يرسل البيانات داخل مفتاح "doctor"
      final doctorData =
          responseData['doctor'] ?? responseData['data'] ?? responseData;
      return DoctorProfileModel.fromJson(doctorData);
    } else {
      throw Exception("Failed to load profile: ${response.statusCode}");
    }
  }

  // 2. تحديث بيانات الطبيب (PATCH) - يدعم النصوص والصور (Multipart)
  Future<DoctorProfileModel> updateDoctorProfile({
    required String token,
    required Map<String, String> bodyData,
    File? imageFile,
  }) async {
    final url = Uri.parse("$_baseUrl/doctors/me");

    // نستخدم MultipartRequest لأننا نرفع صورة
    final request = http.MultipartRequest('PATCH', url);
    request.headers['Authorization'] = 'Bearer $token';

    // إضافة الحقول النصية (phone, name, etc.)
    bodyData.forEach((key, value) {
      request.fields[key] = value;
    });

    // إضافة الصورة إذا وجدت
    if (imageFile != null) {
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      request.files.add(await http.MultipartFile.fromPath(
    'profilePic', // تأكدي أن هذا هو الاسم الذي يتوقعه السيرفر بالضبط
    imageFile.path,
    contentType: MediaType.parse(mimeType),
  ));
}

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final doctorData =
          responseData['doctor'] ?? responseData['data'] ?? responseData;
      return DoctorProfileModel.fromJson(doctorData);
    } else {
      print("Error body: ${response.body}");
      throw Exception("Failed to update profile: ${response.statusCode}");
    }
  }

  // 3. جلب الجدول (Schedule)
  Future<List<ScheduleItem>> getDoctorSchedule(String token) async {
    final url = Uri.parse("$_baseUrl/doctors/me/schedule");
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List scheduleList = responseData['schedule'] ?? [];
      return scheduleList.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load schedule");
    }
  }

  // 4. تحديث الجدول (Update Schedule)
  Future<List<ScheduleItem>> updateDoctorSchedule({
    required String token,
    required List<ScheduleItem> updatedSchedule,
  }) async {
    final url = Uri.parse("$_baseUrl/doctors/me/schedule");
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'schedule': updatedSchedule.map((item) => item.toJson()).toList(),
      }),
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List scheduleList = responseData['schedule'] ?? [];
      return scheduleList.map((item) => ScheduleItem.fromJson(item)).toList();
    } else {
      throw Exception("Failed to update schedule");
    }
  }
}
