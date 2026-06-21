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
  DateTime? _selectedBirthDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
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

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(now.year - 1),
      firstDate: DateTime(now.year - 30),
      lastDate: now,
      helpText: "Select birth date",
      cancelText: "Cancel",
      confirmText: "Select",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedBirthDate = pickedDate;
      _birthDateController.text = _formatDateForDisplay(pickedDate);
    });
  }

  String _formatDateForDisplay(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return "$day-$month-$year";
  }

  String _formatDateForApi(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return "$year-$month-$day";
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Pet profile created successfully!",
          style: AppTextStyles.label14Medium.copyWith(
            color: Colors.white,
          ),
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
          style: AppTextStyles.label14Medium.copyWith(
            color: Colors.white,
          ),
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
    _birthDateController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petsProvider = Provider.of<PetsProvider>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              SizedBox(height: 18.h),
              _buildPetInfoCard(),
              SizedBox(height: 24.h),
              _buildActionButtons(petsProvider),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.22),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeroAvatar(),
          SizedBox(height: 14.h),
          Text(
            "Create Pet Profile",
            style: AppTextStyles.title16SemiBold.copyWith(
              color: Colors.white,
              fontSize: 19.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Add your pet details to personalize care",
            textAlign: TextAlign.center,
            style: AppTextStyles.label14Medium.copyWith(
              color: Colors.white.withOpacity(.82),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAvatar() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.22),
              border: Border.all(
                color: Colors.white.withOpacity(.65),
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              radius: 56.r,
              backgroundColor: Colors.white,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : null,
              child: _selectedImage == null
                  ? Icon(
                Icons.pets_rounded,
                size: 48.sp,
                color: AppColors.primary,
              )
                  : null,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 2.h,
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.12),
                    blurRadius: 12.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.045),
            blurRadius: 26.r,
            spreadRadius: 1,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(
            icon: Icons.info_outline_rounded,
            title: "Pet Information",
          ),

          CustomPetTextField(
            controller: _nameController,
            label: "Pet Name",
            hint: "e.g. Max, Luna",
            validator: Validators.validateName,
            prefixIcon: Icon(
              Icons.badge_outlined,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),

          CustomPetChoiceChips(
            label: "Pet Type",
            selectedValue: _selectedType,
            items: const ["dog", "cat"],
            iconBuilder: (item) {
              if (item == "dog") return Icons.pets_rounded;
              return Icons.cruelty_free_rounded;
            },
            onSelected: (value) {
              setState(() {
                _selectedType = value;
              });
            },
          ),

          CustomPetChoiceChips(
            label: "Gender",
            selectedValue: _selectedGender,
            items: const ["male", "female"],
            iconBuilder: (item) {
              if (item == "male") return Icons.male_rounded;
              return Icons.female_rounded;
            },
            onSelected: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),

          CustomPetTextField(
            controller: _breedController,
            label: "Breed / Type",
            hint: "Optional e.g. Golden Retriever, Persian",
            prefixIcon: Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),

          SizedBox(height: 4.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomPetTextField(
                  controller: _birthDateController,
                  label: "Birth Date",
                  hint: "Select date",
                  readOnly: true,
                  onTap: _pickBirthDate,
                  validator: (value) {
                    return Validators.validateRequiredField(
                      value,
                      "Birth Date",
                    );
                  },
                  suffixIcon: Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomPetTextField(
                  controller: _weightController,
                  label: "Weight",
                  hint: "kg",
                  validator: (value) {
                    return Validators.validateNumericField(
                      value,
                      "Weight",
                    );
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        "kg",
                        style: AppTextStyles.label14Medium.copyWith(
                          color: AppColors.hint,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.10),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: AppTextStyles.title16SemiBold.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
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
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final token = await _storageService.getToken();

              if (!mounted) return;

              if (token == null || token.isEmpty) {
                _showErrorSnackBar(
                  "Session expired, please login again",
                );
                return;
              }

              if (_selectedType == null) {
                _showErrorSnackBar("Please select pet type");
                return;
              }

              if (_selectedGender == null) {
                _showErrorSnackBar("Please select gender");
                return;
              }

              if (_selectedBirthDate == null) {
                _showErrorSnackBar("Please select birth date");
                return;
              }

              try {
                final weightValue =
                    double.tryParse(_weightController.text.trim()) ??
                        0.0;

                await petsProvider.addNewPet(
                  name: _nameController.text.trim(),
                  type: _selectedType!.toLowerCase(),
                  gender: _selectedGender!.toLowerCase(),
                  weight: weightValue,
                  birthDate: _formatDateForApi(_selectedBirthDate!),
                  breed: _breedController.text.trim(),
                  imagePath: _selectedImage?.path ?? '',
                  token: token,
                );

                if (!mounted) return;

                _showSuccessSnackBar();
                Navigator.pop(context);
              } catch (e) {
                debugPrint("Error adding pet: $e");

                if (!mounted) return;

                _showErrorSnackBar(
                  "Something went wrong, try again",
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
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
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 21.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Create Pet Profile",
                  style: AppTextStyles.button16SemiBold,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: OutlinedButton(
            onPressed: petsProvider.isLoading
                ? null
                : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.border.withOpacity(.9),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            child: Text(
              "Cancel",
              style: AppTextStyles.label14Medium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}