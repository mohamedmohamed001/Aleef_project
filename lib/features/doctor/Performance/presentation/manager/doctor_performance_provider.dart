import 'package:flutter/material.dart';

import '../data/models/doctor_performance_model.dart';
import '../data/models/doctor_wallet_transaction_model.dart';
import '../data/services/doctor_performance_api_service.dart';

class DoctorPerformanceProvider extends ChangeNotifier {
  final DoctorPerformanceApiService _apiService = DoctorPerformanceApiService();

  DoctorPerformanceModel? performance;

  bool isLoading = false;
  String? errorMessage;

  List<DoctorWalletTransactionModel> walletTransactions = [];

  bool isWalletTransactionsLoading = false;
  String? walletTransactionsErrorMessage;

  List<DoctorPerformanceAppointmentModel> get appointments {
    return performance?.appointments ?? [];
  }

  AppointmentsCountsModel? get appointmentsCounts {
    return performance?.appointmentsCounts;
  }

  DoctorRatingModel? get doctorRating {
    return performance?.doctorRating;
  }

  DoctorWalletModel? get wallet {
    return performance?.wallet;
  }

  double get totalEarnings {
    return performance?.totalEarnings ?? 0.0;
  }

  bool get hasData => performance != null;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  bool get hasWalletTransactions {
    return walletTransactions.isNotEmpty;
  }

  bool get hasWalletTransactionsError {
    return walletTransactionsErrorMessage != null &&
        walletTransactionsErrorMessage!.isNotEmpty;
  }

  Future<void> getDoctorPerformance() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _apiService.getDoctorPerformance();

    if (result['status'] == 'success') {
      performance = DoctorPerformanceModel.fromJson(result);
      errorMessage = null;
    } else {
      performance = null;
      errorMessage = result['message'] ?? 'Something went wrong';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getWalletTransactions() async {
    isWalletTransactionsLoading = true;
    walletTransactionsErrorMessage = null;
    notifyListeners();

    final result = await _apiService.getWalletTransactions();

    if (result['status'] == 'success') {
      walletTransactions = (result['transactions'] as List? ?? [])
          .map(
            (item) => DoctorWalletTransactionModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();

      walletTransactionsErrorMessage = null;
    } else {
      walletTransactions = [];
      walletTransactionsErrorMessage =
          result['message'] ?? 'Something went wrong';
    }

    isWalletTransactionsLoading = false;
    notifyListeners();
  }

  Future<void> refreshDoctorPerformance() async {
    await getDoctorPerformance();
  }

  Future<void> refreshWalletTransactions() async {
    await getWalletTransactions();
  }

  void clearPerformance() {
    performance = null;
    errorMessage = null;
    isLoading = false;

    walletTransactions = [];
    walletTransactionsErrorMessage = null;
    isWalletTransactionsLoading = false;

    notifyListeners();
  }
}