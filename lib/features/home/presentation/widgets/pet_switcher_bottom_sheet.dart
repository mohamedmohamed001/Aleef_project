import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:flutter/material.dart';

class PetSwitcherBottomSheet extends StatelessWidget {
  final List<PetModel> pets;
  final int selectedPetIndex;
  final void Function(int index, PetModel pet) onPetSelected;
  final VoidCallback onAddPetTap;

  const PetSwitcherBottomSheet({
    super.key,
    required this.pets,
    required this.selectedPetIndex,
    required this.onPetSelected,
    required this.onAddPetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFA),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),

            _SheetHeader(
              petsCount: pets.length,
            ),

            const SizedBox(height: 16),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(pets.length, (index) {
                    final pet = pets[index];
                    final isSelected = selectedPetIndex == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PetSheetItem(
                        pet: pet,
                        isSelected: isSelected,
                        onTap: () => onPetSelected(index, pet),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 4),

            _AddPetButton(
              onTap: onAddPetTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final int petsCount;

  const _SheetHeader({
    required this.petsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.pets_rounded,
            color: AppColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            "Choose your pet",
            style: TextStyle(
              color: Color(0xFF101828),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          "$petsCount pets",
          style: const TextStyle(
            color: Color(0xFF667085),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PetSheetItem extends StatelessWidget {
  final PetModel pet;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetSheetItem({
    required this.pet,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pet.profilePic.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.45)
                : Colors.black.withOpacity(0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primary.withOpacity(0.10),
              backgroundImage: hasImage ? NetworkImage(pet.profilePic) : null,
              child: hasImage
                  ? null
                  : Icon(
                Icons.pets_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF101828),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _petSubtitle(pet),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _petSubtitle(PetModel pet) {
    final type = pet.type.trim();
    final breed = pet.breed.trim();
    final age = pet.age.trim();

    final parts = <String>[];

    if (type.isNotEmpty) parts.add(type);
    if (breed.isNotEmpty) parts.add(breed);
    if (age.isNotEmpty && age != "0") parts.add("$age old");

    if (parts.isEmpty) return "Pet profile";

    return parts.join(" • ");
  }
}

class _AddPetButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPetButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.22),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          "Add another pet",
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}