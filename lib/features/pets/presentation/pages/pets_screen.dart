import 'package:aleef/features/profile/presentation/widgets/my_pets_card.dart';
import 'package:flutter/material.dart';
import '../../data/models/pet_model.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة تجريبية حتى يتم ربط الـ API الخاص بالجلب
    List<PetModel> pets = [];

    return Scaffold(
      appBar: AppBar(title: const Text("My Pets")),
      body: pets.isEmpty
          ? const Center(child: Text("No pets yet"))
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: pets.length,
              itemBuilder: (context, index) => MyPetsCard(pet: pets[index]),
            ),
    );
  }
}
