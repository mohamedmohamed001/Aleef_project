import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {

    final pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );


    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }

  Future<File?> pickFromCamera() async {

    final pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );


    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }
}