import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/services/pets_service.dart';
import 'package:flutter/material.dart';

class PetsProvider with ChangeNotifier {
  final PetsService _petsService = PetsService();

  List<PetModel> _allPets = [];
  PetModel? _selectedPet;
  bool _isLoading = false;

  List<PetModel> get allPets => _allPets;
  PetModel? get selectedPet => _selectedPet;
  bool get isLoading => _isLoading;
  bool get isFetchingDetails => _isLoading;

  Future<void> getAllPets(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> petsData = await _petsService.getPets(token);
      _allPets = petsData.map((json) => PetModel.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchPetDetails(String petId, String token) async {
    _isLoading = true;
    _selectedPet = null;
    notifyListeners();

    try {
      debugPrint("--- START API CALL: Fetching Pet Details ---");
      final Map<String, dynamic> responseData = await _petsService.getPetById(
        petId,
        token,
      );

      debugPrint("RAW SERVER RESPONSE DATA: $responseData");

      if (responseData['data'] != null) {
        _selectedPet = PetModel.fromJson(
          responseData['data'] as Map<String, dynamic>,
        );
      } else {
        _selectedPet = PetModel.fromJson(responseData);
      }

    } catch (error) {
      debugPrint("API ERROR CAUGHT IN PROVIDER: $error");
      if (error.toString().contains("HandshakeException")) {

      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNewPet({
    required String name,
    required String type,
    required String gender,
    required double weight,
    required String age,
    String? imagePath,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _petsService.addPet(
        name: name,
        type: type,
        gender: gender,
        weight: weight,
        age: age,
        imagePath: imagePath,
        token: token,
      );
      await getAllPets(token);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePet(String petId, String token) async {
    try {
      _allPets.removeWhere((pet) => pet.id == petId);
      if (_selectedPet?.id == petId) {
        _selectedPet = null;
      }
      notifyListeners();
      await _petsService.deletePetFromApi(petId, token);
    } catch (error) {
      await getAllPets(token);
      rethrow;
    }
  }

  Future<void> updatePetDetails({
    required String petId,
    String? name,
    String? type,
    String? gender,
    double? weight,
    int? age,
    String? birthDate,
    bool? deleteProfilePic,
    String? imagePath,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _petsService.updatePet(
        petId: petId,
        name: name,
        type: type,
        gender: gender,
        weight: weight,
        age: age,
        birthDate: birthDate,
        deleteProfilePic: deleteProfilePic,
        imagePath: imagePath,
        token: token,
      );
      await fetchPetDetails(petId, token);
      await getAllPets(token);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
