class DoctorWalletTransactionModel {
  final String id;
  final String type;
  final double amount;
  final double balanceAfter;
  final String? reason;
  final DateTime createdAt;
  final String appointmentId;
  final WalletTransactionOwnerModel? owner;
  final WalletTransactionPetModel? pet;

  DoctorWalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.reason,
    required this.createdAt,
    required this.appointmentId,
    required this.owner,
    required this.pet,
  });

  factory DoctorWalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return DoctorWalletTransactionModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      balanceAfter:
      double.tryParse(json['balanceAfter']?.toString() ?? '0') ?? 0.0,
      reason: json['reason']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      appointmentId: json['appointmentId']?.toString() ?? '',
      owner: json['owner'] == null
          ? null
          : WalletTransactionOwnerModel.fromJson(
        Map<String, dynamic>.from(json['owner']),
      ),
      pet: json['pet'] == null
          ? null
          : WalletTransactionPetModel.fromJson(
        Map<String, dynamic>.from(json['pet']),
      ),
    );
  }

  bool get isCredit => type.toLowerCase() == 'credit';

  bool get isDebit => type.toLowerCase() == 'debit';
}

class WalletTransactionOwnerModel {
  final String id;
  final String name;

  WalletTransactionOwnerModel({
    required this.id,
    required this.name,
  });

  factory WalletTransactionOwnerModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionOwnerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class WalletTransactionPetModel {
  final String id;
  final String name;

  WalletTransactionPetModel({
    required this.id,
    required this.name,
  });

  factory WalletTransactionPetModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionPetModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}