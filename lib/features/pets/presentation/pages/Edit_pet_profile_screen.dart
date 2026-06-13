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
  const EditPetProfileScreen({super.key, required this.pet});

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
    _ageController = TextEditingController(
      text: widget.pet.age.toString(),
    );
    _weightController = TextEditingController(text: widget.pet.weight.toString());
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
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
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

  void _savePetData() async {
    final petsProvider = Provider.of<PetsProvider>(context, listen: false);
    final secureStorage = SecureStorageService();
    String? token = await secureStorage.getToken();

    if (token != null) {
      final double? parsedWeight = double.tryParse(_weightController.text.trim());
      final int? inputtedAge = int.tryParse(_ageController.text.trim());
      String? calculatedBirthDate;

      // الخدعة الذكية: لو المستخدم كتب سن، بنحسب تاريخ ميلاد متوافق معاه ونبعته مكان الـ birthDate
      if (inputtedAge != null) {
        int targetYear = DateTime.now().year - inputtedAge;
        String currentMonthDay = "${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
        calculatedBirthDate = "$targetYear-$currentMonthDay";
      }

      await petsProvider.updatePetDetails(
        petId: widget.pet.id,
        name: _nameController.text.trim(),
        type: _typeController.text.trim(),
        gender: _genderController.text.trim(),
        weight: parsedWeight,
        birthDate: calculatedBirthDate, // بتبعت التاريخ المحسوب بذكاء هنا للسيرفر
        deleteProfilePic: _deleteProfilePic,
        imagePath: _imageController.text.startsWith('http') || _imageController.text.isEmpty
            ? null
            : _imageController.text,
        token: token,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      debugPrint("NO token found in secure storage for updating pet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: AppTextStyles.title16SemiBold),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildImagePickerSection(),
            SizedBox(height: 30.h),
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
            CustomPetTextField(
              controller: _ageController,
              label: "Age",
              hint: "Enter pet age (e.g., 2, 3)",
              keyboardType: TextInputType.number, // مفتوح للكتابة المباشرة وشكله ممتاز
            ),
            SizedBox(height: 16.h),
            CustomPetTextField(
              controller: _weightController,
              label: "Weight (kg)",
              hint: "Enter weight",
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40.h),
            _buildSaveButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerSection() {
    bool hasNetworkImage = _imageController.text.startsWith('http');
    bool hasNoImage = _imageController.text.isEmpty || _deleteProfilePic;

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60.r),
              child: hasNoImage
                  ? Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.pets,
                        size: 50.sp,
                        color: Colors.grey[500],
                      ),
                    )
                  : hasNetworkImage
                      ? Image.network(
                          _imageController.text,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.pets,
                                size: 50.sp,
                                color: Colors.grey[500],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            );
                          },
                        )
                      : Image.file(File(_imageController.text), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          if (!hasNoImage)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: _removeImage,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: _savePetData,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: Text('Save Changes', style: AppTextStyles.button16SemiBold),
      ),
    );
  }
}
