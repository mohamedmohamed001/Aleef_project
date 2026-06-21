class DoctorPerformanceModel {
  final List<DoctorPerformanceAppointmentModel> appointments;
  final AppointmentsCountsModel appointmentsCounts;
  final DoctorRatingModel doctorRating;
  final DoctorWalletModel wallet;
  final double totalEarnings;

  DoctorPerformanceModel({
    required this.appointments,
    required this.appointmentsCounts,
    required this.doctorRating,
    required this.wallet,
    required this.totalEarnings,
  });

  factory DoctorPerformanceModel.fromJson(Map<String, dynamic> json) {
    return DoctorPerformanceModel(
      appointments: (json['appointments'] as List? ?? [])
          .map((e) => DoctorPerformanceAppointmentModel.fromJson(e))
          .toList(),

      appointmentsCounts: AppointmentsCountsModel.fromJson(
        json['appoinmentsCounts'] ??
            json['appointmentsCounts'] ??
            {},
      ),

      doctorRating: DoctorRatingModel.fromJson(
        json['doctorRating'] ?? {},
      ),

      wallet: DoctorWalletModel.fromJson(
        json['wallet'] ?? {},
      ),

      totalEarnings:
      double.tryParse(json['totalEarnings']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class DoctorPerformanceAppointmentModel {
  final String id;
  final DateTime? date;
  final String time;
  final String reason;
  final String status;
  final OwnerModel owner;
  final PetModel pet;
  final int cancelledCount;

  DoctorPerformanceAppointmentModel({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.owner,
    required this.pet,
    required this.cancelledCount,
  });

  factory DoctorPerformanceAppointmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DoctorPerformanceAppointmentModel(
      id: json['id'] ?? '',
      date: json['date'] == null ? null : DateTime.tryParse(json['date']),
      time: json['time'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      owner: OwnerModel.fromJson(json['owner'] ?? {}),
      pet: PetModel.fromJson(json['pet'] ?? {}),
      cancelledCount: int.tryParse(json['cancelledCount'].toString()) ?? 0,
    );
  }
}

class OwnerModel {
  final String id;
  final String name;

  OwnerModel({
    required this.id,
    required this.name,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class PetModel {
  final String id;
  final String name;
  final String type;
  final String gender;
  final String? profilePic;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.gender,
    required this.profilePic,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      profilePic: json['profilePic'],
    );
  }
}

class AppointmentsCountsModel {
  final int totalAppointments;
  final int completedAppointments;
  final int cancelledAppointments;

  AppointmentsCountsModel({
    required this.totalAppointments,
    required this.completedAppointments,
    required this.cancelledAppointments,
  });

  factory AppointmentsCountsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentsCountsModel(
      totalAppointments: json['totalAppoinments'] ?? 0,
      completedAppointments: json['completedAppoinments'] ?? 0,
      cancelledAppointments: json['cancelledAppoinments'] ?? 0,
    );
  }
}

class DoctorRatingModel {
  final double rating;
  final int ratingCount;

  DoctorRatingModel({
    required this.rating,
    required this.ratingCount,
  });

  factory DoctorRatingModel.fromJson(Map<String, dynamic> json) {
    return DoctorRatingModel(
      rating: double.tryParse(json['rating'].toString()) ?? 0,
      ratingCount: json['ratingCount'] ?? 0,
    );
  }
}

class DoctorWalletModel {
  final String id;
  final double balance;
  final int transactionsCount;

  DoctorWalletModel({
    required this.id,
    required this.balance,
    required this.transactionsCount,
  });

  factory DoctorWalletModel.fromJson(Map<String, dynamic> json) {
    return DoctorWalletModel(
      id: json['id']?.toString() ?? '',
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      transactionsCount:
      int.tryParse(json['transactionsCount']?.toString() ?? '0') ?? 0,
    );
  }
}