import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    debugPrint("Picking from gallery...");

    final pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    debugPrint("Gallery result: ${pickedImage?.path}");

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }

  Future<File?> pickFromCamera() async {
    debugPrint("Picking from camera...");

    final pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    debugPrint("Camera result: ${pickedImage?.path}");

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }
}