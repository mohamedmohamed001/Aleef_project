import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/services/pets_service.dart';
import 'package:flutter/material.dart';

class PetsProvider with ChangeNotifier {
  final PetsService _petsService = PetsService();

  List<PetModel> _allPets = [];
  PetModel? _selectedPet;

  bool _isLoading = false;
  bool _isUpdatingPet = false;

  String? _updatePetError;

  List<PetModel> get allPets => _allPets;
  PetModel? get selectedPet => _selectedPet;

  bool get isLoading => _isLoading;
  bool get isFetchingDetails => _isLoading;

  bool get isUpdatingPet => _isUpdatingPet;
  String? get updatePetError => _updatePetError;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setUpdatingPet(bool value) {
    _isUpdatingPet = value;
    notifyListeners();
  }

  void _setUpdatePetError(String? message) {
    _updatePetError = message;
    notifyListeners();
  }

  Future<void> getAllPets(String token) async {
    _setLoading(true);

    try {
      final List<dynamic> petsData = await _petsService.getPets(token);

      debugPrint(petsData.toString());

      _allPets = petsData.map((json) => PetModel.fromJson(json)).toList();
    } catch (error) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPetDetails(String petId, String token) async {
    if (petId.trim().isEmpty) {
      return;
    }

    _isLoading = true;
    _selectedPet = null;
    notifyListeners();

    try {
      final Map<String, dynamic> responseData = await _petsService.getPetById(
        petId,
        token,
      );

      final Map<String, dynamic> fixedResponse =
      Map<String, dynamic>.from(responseData);

      if (fixedResponse['pet'] is Map<String, dynamic>) {
        fixedResponse['pet'] = {
          ...Map<String, dynamic>.from(fixedResponse['pet']),
          'id': petId,
        };
      } else {
        fixedResponse['id'] = petId;
      }

      _selectedPet = PetModel.fromJson(fixedResponse);
    } catch (error) {
      rethrow;
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
    required String birthDate,
    String? breed,
    String? imagePath,
    required String token,
  }) async {
    _setLoading(true);

    try {
      await _petsService.addPet(
        name: name,
        type: type,
        gender: gender,
        weight: weight,
        birthDate: birthDate,
        breed: breed,
        imagePath: imagePath,
        token: token,
      );

      final List<dynamic> petsData = await _petsService.getPets(token);

      debugPrint(petsData.toString());

      _allPets = petsData.map((json) => PetModel.fromJson(json)).toList();
    } catch (error) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePet(String petId, String token) async {
    if (petId.trim().isEmpty) {
      return;
    }

    final oldPets = List<PetModel>.from(_allPets);
    final oldSelectedPet = _selectedPet;

    try {
      _allPets.removeWhere((pet) => pet.id == petId);

      if (_selectedPet?.id == petId) {
        _selectedPet = null;
      }

      notifyListeners();

      await _petsService.deletePetFromApi(petId, token);
    } catch (error) {
      _allPets = oldPets;
      _selectedPet = oldSelectedPet;
      notifyListeners();

      rethrow;
    }
  }

  Future<bool> updatePetDetails({
    required String petId,
    String? name,
    String? type,
    String? gender,
    String? breed,
    double? weight,
    int? age,
    String? birthDate,
    bool? deleteProfilePic,
    String? imagePath,
    required String token,
  }) async {
    _setUpdatingPet(true);
    _setUpdatePetError(null);

    try {
      if (petId.trim().isEmpty) {
        const message = "Pet id is empty. Refresh pets and try again.";
        _setUpdatePetError(message);
        return false;
      }

      await _petsService.updatePet(
        petId: petId,
        name: name,
        type: type,
        gender: gender,
        breed: breed,
        weight: weight,
        age: age,
        birthDate: birthDate,
        deleteProfilePic: deleteProfilePic,
        imagePath: imagePath,
        token: token,
      );

      await fetchPetDetails(petId, token);

      final List<dynamic> petsData = await _petsService.getPets(token);

      debugPrint(petsData.toString());

      _allPets = petsData.map((json) => PetModel.fromJson(json)).toList();

      notifyListeners();
      return true;
    } catch (error) {
      _setUpdatePetError(error.toString());
      return false;
    } finally {
      _setUpdatingPet(false);
    }
  }

  void clearSelectedPet() {
    _selectedPet = null;
    notifyListeners();
  }

  void clearUpdatePetError() {
    _updatePetError = null;
    notifyListeners();
  }
}