import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../manager/pets_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/services/secure_storage_service.dart';
import 'custom_pet_fields.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  File? _selectedImage;
  String? _selectedType;
  String? _selectedGender;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final SecureStorageService _storageService = SecureStorageService();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Pet Added Successfully!",
          style: AppTextStyles.label14Medium.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petsProvider = Provider.of<PetsProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePickerHeader(),

            Text("Basic Information", style: AppTextStyles.title16SemiBold),
            CustomPetTextField(
              controller: _nameController,
              label: "Pet Name",
              hint: "Enter pet name",
            ),

            CustomPetDropdown(
              label: "Pet Type",
              hint: "Select pet type",
              value: _selectedType,
              items: ["dog", "cat"],
              onChanged: (val) => setState(() => _selectedType = val),
            ),

            CustomPetTextField(
              controller: _breedController,
              label: "Breed",
              hint: "Enter breed",
            ),

            CustomPetDropdown(
              label: "Gender",
              hint: "Select gender",
              value: _selectedGender,
              items: ["male", "female"],
              onChanged: (val) => setState(() => _selectedGender = val),
            ),

            Row(
              children: [
                Expanded(
                  child: CustomPetTextField(
                    controller: _ageController,
                    label: "Age",
                    hint: "Years",
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomPetTextField(
                    controller: _weightController,
                    label: "Weight",
                    hint: "kg",
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Text("Appearance", style: AppTextStyles.title16SemiBold),
            ),
            CustomPetTextField(
              controller: _colorController,
              label: "Color",
              hint: "e.g. Golden, Black",
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Text(
                "Medical Info (Optional)",
                style: AppTextStyles.title16SemiBold,
              ),
            ),
            CustomPetTextField(
              controller: _medicalController,
              label: "Known Conditions",
              hint: "e.g. None",
            ),
            CustomPetTextField(
              controller: _notesController,
              label: "Notes",
              hint: "Additional notes...",
              maxLines: 3,
            ),

            SizedBox(height: 30.h),
            _buildActionButtons(petsProvider),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 4.h),
          child: Text("Pet Image", style: AppTextStyles.label14Medium),
        ),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.border),
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
            child: _selectedImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.hint,
                        size: 30.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Upload Photo",
                        style: AppTextStyles.label14Medium.copyWith(
                          color: AppColors.hint,
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildActionButtons(PetsProvider petsProvider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: petsProvider.isLoading
                ? null
                : () async {
                    if (_selectedImage == null) return;
                    String? token = await _storageService.getToken();
                    if (token == null) return;

                    try {
                      int ageValue = int.tryParse(_ageController.text) ?? 1;
                      double weightValue =
                          double.tryParse(_weightController.text) ?? 0.0;

                      await petsProvider.addNewPet(
                        name: _nameController.text.trim(),
                        type: (_selectedType ?? "dog").toLowerCase(),
                        gender: (_selectedGender ?? "male").toLowerCase(),
                        weight: weightValue,
                        age: ageValue,
                        imagePath: _selectedImage?.path ?? '',
                        token: token,
                      );

                      if (mounted) {
                        _showSuccessSnackBar();
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      debugPrint("Error adding pet: $e");
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
            ),
            child: petsProvider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("Add Pet", style: AppTextStyles.button16SemiBold),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              "Cancel",
              style: AppTextStyles.label14Medium.copyWith(
                color: AppColors.hint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
