import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../services/profile_api.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _editName = TextEditingController();
  final TextEditingController _editPhone = TextEditingController();

  final session = getIt<SessionService>();
  late final user = session.currentUser;

  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _init();

    if (user != null) {
      _editName.text = user!.name;
      _editPhone.text = user!.phone;
    }
  }

  Future<void> _init() async {
    final storage = getIt<SecureStorageService>();
    final session = getIt<SessionService>();

    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user != null && token != null && token.isNotEmpty) {
      session.setSession(user: user, tokenValue: token);
      debugPrint("User موجود ✅");
    } else {
      debugPrint("User مش موجود ❌");
    }

    if (!mounted) return;

    setState(() {
      if (session.currentUser != null) {
        _editName.text = session.currentUser!.name;
        _editPhone.text = session.currentUser!.phone;
      }
    });
  }

  Future<void> _pickImage({required bool fromCamera}) async {
    try {
      final imagePickerService = ImagePickerService();

      final File? file = fromCamera
          ? await imagePickerService.pickFromCamera()
          : await imagePickerService.pickFromGallery();

      if (file == null) return;

      setState(() {
        _selectedImage = file;
      });
    } catch (e) {
      debugPrint("Pick image error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error picking image: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  await Future.delayed(const Duration(milliseconds: 200));
                  await _pickImage(fromCamera: true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  await Future.delayed(const Duration(milliseconds: 200));
                  await _pickImage(fromCamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeProfilePhoto() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Remove Photo"),
          content: const Text(
            "Are you sure you want to remove your profile picture?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    if (_selectedImage != null) {
      setState(() {
        _selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selected image removed"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final success = await ProfileApi().removeProfilePic();

    if (!mounted) return;

    if (success) {
      await _init();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile picture removed"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to remove profile picture"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    final success = await ProfileApi().editProfileWithImage(
      name: _editName.text.trim(),
      phone: _editPhone.text.trim(),
      imageFile: _selectedImage,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      await _init();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
    }
  }  @override
  void dispose() {
    _editName.dispose();
    _editPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = getIt<SessionService>();
    final user = session.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 122,
                          height: 122,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 56,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (user != null && user.profilePic.isNotEmpty
                                ? NetworkImage(user.profilePic)
                                : null),
                            child: _selectedImage == null &&
                                (user == null || user.profilePic.isEmpty)
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: 6,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _showImageSourceSheet,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2B8C84),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.file_upload_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: _removeProfilePhoto,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFFFF5A5F),
                            size: 20,
                          ),
                          label: const Text(
                            'Remove',
                            style: TextStyle(
                              color: Color(0xFFFF5A5F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Basic Information',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Full Name',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _editName,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone Number',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _editPhone,
                decoration: const InputDecoration(
                  hintText: 'Enter your phone number',
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B8C84),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}