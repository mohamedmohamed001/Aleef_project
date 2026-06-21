import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeVetTipCard extends StatelessWidget {
  final PetModel? selectedPet;

  const HomeVetTipCard({
    super.key,
    this.selectedPet,
  });

  static const List<String> generalTips = [
    "Fresh water should always be available for your pet.",
    "Regular brushing helps keep your pet's coat healthy.",
    "Keep vaccines updated to protect your pet from diseases.",
    "Avoid giving your pet human food without asking a vet.",
    "Daily playtime helps reduce stress and boredom.",
    "Check your pet's ears and paws regularly.",
    "A sudden appetite change may need a vet check.",
  ];

  static const List<String> dogTips = [
    "Daily walks help dogs reduce stress and stay active.",
    "Avoid chocolate, grapes, and onions because they can be harmful to dogs.",
    "Check your dog's paws after walks, especially in hot weather.",
    "Regular brushing helps reduce shedding and keeps your dog's coat healthy.",
  ];

  static const List<String> catTips = [
    "Cats may hide illness, so watch for appetite or litter box changes.",
    "Keep fresh water available to support your cat's kidney health.",
    "Interactive play helps cats reduce stress and stay active.",
    "A clean litter box helps you notice health changes earlier.",
  ];

  @override
  Widget build(BuildContext context) {
    final tip = _getTip();
    final title = _getTitle();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8ED),
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(
          color: const Color(0xFFFFB547).withOpacity(0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB547).withOpacity(0.16),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: const Color(0xFFFF9900),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF101828),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  tip,
                  style: TextStyle(
                    color: const Color(0xFF667085),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.favorite_rounded,
            color: AppColors.primary.withOpacity(0.75),
            size: 18.sp,
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    final pet = selectedPet;

    if (pet == null) return "Care Tip";

    final name = pet.name.trim();
    if (name.isEmpty) return "Vet Tip";

    return "Tip for $name";
  }

  String _getTip() {
    final pet = selectedPet;

    if (pet == null) {
      final index = DateTime.now().weekday % generalTips.length;
      return "Add your pet profile to get more personalized tips. ${generalTips[index]}";
    }

    final type = pet.type.trim().toLowerCase();

    if (type.contains("dog")) {
      final index = DateTime.now().weekday % dogTips.length;
      return dogTips[index];
    }

    if (type.contains("cat")) {
      final index = DateTime.now().weekday % catTips.length;
      return catTips[index];
    }

    final index = DateTime.now().weekday % generalTips.length;
    return generalTips[index];
  }
}