import 'package:aleef/core/services/secure_storage_service.dart';
import 'package:aleef/core/services/service_locator.dart';
import 'package:aleef/core/services/session_service.dart';
import 'package:aleef/features/appointments/data/models/appointment_model.dart';
import 'package:aleef/features/appointments/services/appointment_api.dart';
import 'package:aleef/features/home/presentation/widgets/home_products_section.dart';
import 'package:aleef/features/pets/data/models/pet_model.dart';
import 'package:aleef/features/pets/presentation/manager/pets_provider.dart';
import 'package:aleef/features/store/services/store_provider.dart';
import 'package:aleef/providers/user_provider.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final SessionService session = getIt<SessionService>();

  AppointmentModel _appointment = AppointmentModel();

  bool _isFirstLoading = true;
  bool _isAppointmentLoading = true;

  int _selectedPetIndex = 0;
  String? _selectedPetId;

  bool _isDisposed = false;

  AppointmentModel get appointment => _appointment;

  bool get isFirstLoading => _isFirstLoading;
  bool get isAppointmentLoading => _isAppointmentLoading;

  int get selectedPetIndex => _selectedPetIndex;
  String? get selectedPetId => _selectedPetId;

  Future<void> initHome({
    required UserProvider userProvider,
    required PetsProvider petsProvider,
    required StoreProvider storeProvider,
    required Future<void> Function() onUnauthorized,
  }) async {
    _setFirstLoading(true);

    await _initSession(userProvider);
    await _loadSelectedPetId();

    await Future.wait([
      fetchCurrentAppointment(onUnauthorized: onUnauthorized),
      fetchPets(petsProvider: petsProvider),
      fetchProducts(storeProvider: storeProvider),
    ]);

    _setFirstLoading(false);
  }

  Future<void> refreshHome({
    required UserProvider userProvider,
    required PetsProvider petsProvider,
    required StoreProvider storeProvider,
    required Future<void> Function() onUnauthorized,
  }) async {
    await _initSession(userProvider);
    await _loadSelectedPetId();

    await Future.wait([
      fetchCurrentAppointment(onUnauthorized: onUnauthorized),
      fetchPets(petsProvider: petsProvider),
      fetchProducts(storeProvider: storeProvider),
    ]);
  }

  Future<void> _initSession(UserProvider userProvider) async {
    final storage = getIt<SecureStorageService>();
    final user = await storage.getUser();
    final token = await storage.getToken();

    if (user == null || token == null || token.isEmpty) return;

    session.setSession(
      user: user,
      tokenValue: token,
    );

    userProvider.setUser(user);
  }

  Future<void> _loadSelectedPetId() async {
    final storage = getIt<SecureStorageService>();
    _selectedPetId = await storage.getSelectedPetId();
  }

  Future<void> fetchPets({
    required PetsProvider petsProvider,
  }) async {
    final token = await _getUserToken();
    if (token == null) return;

    try {
      await petsProvider.getAllPets(token);

      final pets = petsProvider.allPets;
      if (pets.isEmpty) {
        _selectedPetIndex = 0;
        _selectedPetId = null;

        await getIt<SecureStorageService>().deleteSelectedPetId();

        _safeNotifyListeners();
        return;
      }

      await _resolveSelectedPetFromStorage(pets);

      final selectedPet = pets[_selectedPetIndex];

      await petsProvider.fetchPetDetails(
        selectedPet.id,
        token,
      );

      _safeNotifyListeners();
    } catch (error) {
      debugPrint('Home fetch pets error: $error');
    }
  }

  Future<void> _resolveSelectedPetFromStorage(List<PetModel> pets) async {
    if (pets.isEmpty) return;

    final storage = getIt<SecureStorageService>();

    final savedPetId = _selectedPetId;

    if (savedPetId != null && savedPetId.trim().isNotEmpty) {
      final savedIndex = pets.indexWhere((pet) => pet.id == savedPetId);

      if (savedIndex != -1) {
        _selectedPetIndex = savedIndex;
        _selectedPetId = pets[savedIndex].id;
        return;
      }
    }

    _fixSelectedPetIndex(pets);

    final fallbackPet = pets[_selectedPetIndex];

    _selectedPetId = fallbackPet.id;

    await storage.saveSelectedPetId(fallbackPet.id);
  }

  Future<void> fetchSelectedPetDetails({
    required int index,
    required PetModel pet,
    required PetsProvider petsProvider,
  }) async {
    final token = await _getUserToken();
    if (token == null) return;

    try {
      _selectedPetIndex = index;
      _selectedPetId = pet.id;

      await getIt<SecureStorageService>().saveSelectedPetId(pet.id);

      _safeNotifyListeners();

      await petsProvider.fetchPetDetails(
        pet.id,
        token,
      );

      _safeNotifyListeners();
    } catch (error) {
      debugPrint('Home fetch selected pet error: $error');
    }
  }

  Future<void> fetchProducts({
    required StoreProvider storeProvider,
  }) async {
    try {
      await storeProvider.getAllProducts();
    } catch (error) {
      debugPrint('Home fetch products error: $error');
    }
  }

  Future<void> fetchCurrentAppointment({
    required Future<void> Function() onUnauthorized,
  }) async {
    _setAppointmentLoading(true);

    try {
      final response = await AppointmentApi().getActiveAppointment();

      if (response['status'] == 'success') {
        final data = response['data'];

        _appointment = data != null
            ? AppointmentModel.fromJson(
          Map<String, dynamic>.from(data),
        )
            : AppointmentModel();

        _setAppointmentLoading(false);
        return;
      }

      if (response['status'] == 'unauthorized') {
        await onUnauthorized();
        return;
      }

      _clearAppointment();
    } catch (error, stackTrace) {
      debugPrint('Home active appointment error: $error');
      debugPrint('Stack trace: $stackTrace');

      _clearAppointment();
    }
  }

  PetModel? resolveSelectedPet({
    required PetsProvider petsProvider,
  }) {
    final pets = petsProvider.allPets;
    if (pets.isEmpty) return null;

    final detailedPet = petsProvider.selectedPet;

    final listPet = _getSelectedPet(pets);

    if (detailedPet != null && listPet != null && detailedPet.id == listPet.id) {
      return detailedPet;
    }

    return listPet;
  }

  List<HomeProductData> buildHomeProducts(StoreProvider storeProvider) {
    return storeProvider.allProducts.take(5).map((product) {
      return HomeProductData(
        id: product.id,
        name: product.title,
        imageUrl: product.thumbnail.url,
        price: "EGP ${product.finalPrice.toStringAsFixed(0)}",
      );
    }).toList();
  }

  Future<String?> _getUserToken() async {
    final storage = getIt<SecureStorageService>();
    final token = await storage.getToken();

    if (token == null || token.isEmpty) return null;

    return token;
  }

  void _clearAppointment() {
    _appointment = AppointmentModel();
    _setAppointmentLoading(false);
  }

  PetModel? _getSelectedPet(List<PetModel> pets) {
    if (pets.isEmpty) return null;

    if (_selectedPetId != null && _selectedPetId!.trim().isNotEmpty) {
      final petById = pets.where((pet) => pet.id == _selectedPetId).toList();

      if (petById.isNotEmpty) {
        return petById.first;
      }
    }

    _fixSelectedPetIndex(pets);

    return pets[_selectedPetIndex];
  }

  void _fixSelectedPetIndex(List<PetModel> pets) {
    if (pets.isEmpty) return;

    if (_selectedPetIndex < 0 || _selectedPetIndex >= pets.length) {
      _selectedPetIndex = 0;
    }
  }

  void _setFirstLoading(bool value) {
    _isFirstLoading = value;
    _safeNotifyListeners();
  }

  void _setAppointmentLoading(bool value) {
    _isAppointmentLoading = value;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (_isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}