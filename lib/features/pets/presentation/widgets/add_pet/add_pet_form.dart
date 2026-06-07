import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/secure_storage_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/validators/validators.dart';
import '../../manager/pets_provider.dart';
import 'custom_pet_fields.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? _selectedType;
  String? _selectedGender;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();


  final SecureStorageService _storageService = SecureStorageService();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted || image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.label14Medium.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    // _colorController.dispose();
    // _medicalController.dispose();
    // _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final petsProvider = Provider.of<PetsProvider>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    // Text(
                    //   "Create Pet Profile",
                    //   style: AppTextStyles.title16SemiBold,
                    // ),
                    // SizedBox(height: 6.h),
                    // Text(
                    //   "Add your pet information",
                    //   style: AppTextStyles.label14Medium.copyWith(
                    //     color: AppColors.hint,
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              _buildHeroAvatar(),
              // SizedBox(height: 24.h),
              SizedBox(height: 10.h),

              Center(
                child: Text(
                  "Tap to upload pet photo",
                  style: AppTextStyles.label14Medium.copyWith(
                    color: AppColors.hint,
                  ),
                ),
              ),

              _sectionCard(
                title: "Basic Information",
                child: Column(
                  children: [
                    CustomPetTextField(
                      controller: _nameController,
                      label: "Pet Name",
                      hint: "Enter pet name",
                      validator:Validators.validateName,
                    ),

                    CustomPetDropdown(
                      label: "Pet Type",
                      hint: "Select pet type",
                      value: _selectedType,
                      items: const ["dog", "cat"],
                      onChanged: (val) => setState(() => _selectedType = val),
                    ),

                    CustomPetTextField(
                      controller: _breedController,
                      label: "Breed",
                      hint: "Enter breed",
                      validator: (value) =>
                          Validators.validateRequiredField(value, "Breed"),
                    ),

                    CustomPetDropdown(
                      label: "Gender",
                      hint: "Select gender",
                      value: _selectedGender,
                      items: const ["male", "female"],
                      onChanged: (val) => setState(() => _selectedGender = val),
                    ),
                  ],
                ),
              ),
              _sectionCard(
                title: "Additional Details",
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomPetTextField(
                            controller: _ageController,
                            label: "Age",
                            hint: "Years",
                            validator: (value) =>
                                Validators.validateRequiredField(
                                  value,
                                  "Age",
                                )
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: CustomPetTextField(
                            controller: _weightController,
                            label: "Weight",
                            hint: "kg",
                            validator: (value) =>
                                Validators.validateNumericField(value, "Weight"),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // CustomPetTextField(
              //   controller: _colorController,
              //   label: "Color",
              //   hint: "e.g. Golden, Black",
              // ),
              //
              // Padding(
              //   padding: EdgeInsets.only(top: 20.h),
              //   child: Text(
              //     "Medical Info (Optional)",
              //     style: AppTextStyles.title16SemiBold,
              //   ),
              // ),
              //
              // CustomPetTextField(
              //   controller: _medicalController,
              //   label: "Known Conditions",
              //   hint: "e.g. None",
              // ),
              //
              // CustomPetTextField(
              //   controller: _notesController,
              //   label: "Notes",
              //   hint: "Additional notes...",
              //   maxLines: 3,
              // ),
      
              SizedBox(height: 30.h),
              _buildActionButtons(petsProvider),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeroAvatar() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 58.r,
              backgroundColor: AppColors.inputFill,
              backgroundImage:
              _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : null,
              child: _selectedImage == null
                  ? Icon(
                Icons.pets,
                size: 50.sp,
                color: AppColors.primary,
              )
                  : null,
            ),
          ),

          Positioned(
            right: -2,
            bottom: -2,
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
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final token = await _storageService.getToken();

              if (!mounted) return;

              if (token == null || token.isEmpty) {
                _showErrorSnackBar("Session expired, please login again");
                return;
              }

              try {
                final weightValue =
                    double.tryParse(_weightController.text.trim()) ?? 0.0;
                if (_selectedType == null) {
                  _showErrorSnackBar(
                    "Please select pet type",
                  );
                  return;
                }
                if (_selectedGender == null) {
                  _showErrorSnackBar(
                    "Please select gender",
                  );
                  return;
                }

                await petsProvider.addNewPet(
                  name: _nameController.text.trim(),
                  type: (_selectedType ?? "dog").toLowerCase(),
                  gender: (_selectedGender ?? "male").toLowerCase(),
                  weight: weightValue,
                  age: _ageController.text.trim(),
                  imagePath: _selectedImage?.path ?? '',
                  token: token,
                );

                if (!mounted) return;

                _showSuccessSnackBar();
                Navigator.pop(context);
              } catch (e) {
                debugPrint("Error adding pet: $e");

                if (!mounted) return;

                _showErrorSnackBar("Something went wrong, try again");
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
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.4,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.pets,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Add Pet Profile",
                  style: AppTextStyles.button16SemiBold,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: OutlinedButton(

            onPressed: petsProvider.isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.border,
              ),
            ),
            child: Text(
              "Cancel",
                style: AppTextStyles.label14Medium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                )
            ),
          ),
        ),
      ],
    );
  }
  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 18.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 25,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title16SemiBold,
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}