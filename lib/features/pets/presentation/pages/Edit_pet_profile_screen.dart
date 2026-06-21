import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/pet_model.dart';
import '../manager/pets_provider.dart';
import '../widgets/add_pet/custom_pet_fields.dart';

class EditPetProfileScreen extends StatefulWidget {
  final PetModel pet;

  const EditPetProfileScreen({
    super.key,
    required this.pet,
  });

  @override
  State<EditPetProfileScreen> createState() => _EditPetProfileScreenState();
}

class _EditPetProfileScreenState extends State<EditPetProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _imageController;

  final ImagePicker _picker = ImagePicker();

  bool _deleteProfilePic = false;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.pet.name);
    _typeController = TextEditingController(text: widget.pet.type);
    _genderController = TextEditingController(text: widget.pet.gender);
    _ageController = TextEditingController(text: widget.pet.age.toString());
    _weightController = TextEditingController(
      text: widget.pet.weight.toString(),
    );
    _imageController = TextEditingController(text: widget.pet.profilePic);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;

    setState(() => _isPickingImage = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageController.text = image.path;
          _deleteProfilePic = false;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imageController.text = "";
      _deleteProfilePic = true;
    });
  }

  Future<void> _savePetData() async {
    FocusScope.of(context).unfocus();

    final petsProvider = context.read<PetsProvider>();
    final secureStorage = SecureStorageService();
    final String? token = await secureStorage.getToken();

    if (token == null || token.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session expired, please login again"),
        ),
      );
      return;
    }

    final String name = _nameController.text.trim();
    final String type = _typeController.text.trim();
    final String gender = _genderController.text.trim();

    if (name.isEmpty || type.isEmpty || gender.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill pet name, type and gender"),
        ),
      );
      return;
    }

    final double? parsedWeight = double.tryParse(
      _weightController.text.trim(),
    );

    final int? inputtedAge = int.tryParse(
      _ageController.text.trim(),
    );

    String? calculatedBirthDate;

    if (inputtedAge != null) {
      final now = DateTime.now();
      final int targetYear = now.year - inputtedAge;

      final String currentMonthDay =
          "${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      calculatedBirthDate = "$targetYear-$currentMonthDay";
    }

    final String imageText = _imageController.text.trim();

    final String? imagePath = imageText.startsWith('http') || imageText.isEmpty
        ? null
        : imageText;

    debugPrint("========== EDIT PET SCREEN SAVE ==========");
    debugPrint("PET ID: ${widget.pet.id}");
    debugPrint("NAME: $name");
    debugPrint("TYPE: $type");
    debugPrint("GENDER: $gender");
    debugPrint("WEIGHT: $parsedWeight");
    debugPrint("BIRTH DATE: $calculatedBirthDate");
    debugPrint("IMAGE PATH: $imagePath");
    debugPrint("DELETE PROFILE PIC: $_deleteProfilePic");
    debugPrint("==========================================");

    final bool success = await petsProvider.updatePetDetails(
      petId: widget.pet.id,
      name: name,
      type: type,
      gender: gender,
      weight: parsedWeight,
      birthDate: calculatedBirthDate,
      deleteProfilePic: _deleteProfilePic,
      imagePath: imagePath,
      token: token,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Pet updated successfully",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          margin: EdgeInsets.all(16.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  petsProvider.updatePetError ?? "Failed to update pet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          margin: EdgeInsets.all(16.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      bottomNavigationBar: _buildBottomSaveBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 110.h),
        child: Column(
          children: [
            _buildTopHeader(),
            Transform.translate(
              offset: Offset(0, -42.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    _buildImagePickerSection(),
                    SizedBox(height: 18.h),
                    _buildPetInfoMiniCard(),
                    SizedBox(height: 18.h),
                    _buildFormCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        left: 20.w,
        right: 20.w,
        bottom: 72.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.78),
            const Color(0xFFBFE8E4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36.r),
          bottomRight: Radius.circular(36.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildCircleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const Spacer(),
              Text(
                "Edit Pet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _buildCircleButton(
                icon: Icons.pets_rounded,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Update ${widget.pet.name}'s profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Keep your pet information fresh and accurate.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.35),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    final String imageText = _imageController.text.trim();
    final bool hasNetworkImage = imageText.startsWith('http');
    final bool hasNoImage = imageText.isEmpty || _deleteProfilePic;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.22),
                  blurRadius: 30.r,
                  offset: Offset(0, 14.h),
                ),
              ],
            ),
            child: Container(
              width: 132.r,
              height: 132.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEAF7F6),
                    AppColors.primary.withOpacity(0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipOval(
                child: hasNoImage
                    ? _buildEmptyPetImage()
                    : hasNetworkImage
                    ? Image.network(
                  imageText,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildEmptyPetImage();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.4,
                      ),
                    );
                  },
                )
                    : Image.file(
                  File(imageText),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildEmptyPetImage();
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4.h,
            right: 2.w,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 14.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                child: _isPickingImage
                    ? Padding(
                  padding: EdgeInsets.all(11.r),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          if (!hasNoImage)
            Positioned(
              top: 6.h,
              right: 0,
              child: GestureDetector(
                onTap: _removeImage,
                child: Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5A5F),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.5.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyPetImage() {
    return Container(
      color: const Color(0xFFEAF4F3),
      child: Icon(
        Icons.pets_rounded,
        size: 54.sp,
        color: AppColors.primary.withOpacity(0.58),
      ),
    );
  }

  Widget _buildPetInfoMiniCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              _petTypeIcon(widget.pet.type),
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pet.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "${widget.pet.type} • ${widget.pet.gender}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FBFA),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
            child: Text(
              "Profile",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: "Pet Details",
            subtitle: "Edit the basic information below",
          ),
          SizedBox(height: 18.h),
          CustomPetTextField(
            controller: _nameController,
            label: "Pet Name",
            hint: "Enter pet name",
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16.h),
          CustomPetTextField(
            controller: _typeController,
            label: "Pet Type",
            hint: "Enter pet type (e.g., Dog, Cat)",
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16.h),
          CustomPetTextField(
            controller: _genderController,
            label: "Gender",
            hint: "Enter gender (Male/Female)",
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: CustomPetTextField(
                  controller: _ageController,
                  label: "Age",
                  hint: "2",
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomPetTextField(
                  controller: _weightController,
                  label: "Weight (kg)",
                  hint: "8.5",
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.edit_note_rounded,
            color: AppColors.primary,
            size: 25.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSaveBar() {
    return Consumer<PetsProvider>(
      builder: (context, petsProvider, child) {
        final bool isSaving = petsProvider.isUpdatingPet;

        return Container(
          padding: EdgeInsets.fromLTRB(
            20.w,
            12.h,
            20.w,
            MediaQuery.of(context).padding.bottom + 14.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 20.r,
                offset: Offset(0, -8.h),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: isSaving ? null : _savePetData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.55),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isSaving
                    ? Row(
                  key: const ValueKey("loading"),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Saving...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                )
                    : Row(
                  key: const ValueKey("save"),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Save Changes",
                      style: AppTextStyles.button16SemiBold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _petTypeIcon(String type) {
    final value = type.toLowerCase().trim();

    if (value.contains("cat")) {
      return Icons.cruelty_free_rounded;
    }

    if (value.contains("dog")) {
      return Icons.pets_rounded;
    }

    if (value.contains("bird")) {
      return Icons.flutter_dash_rounded;
    }

    return Icons.pets_rounded;
  }
}