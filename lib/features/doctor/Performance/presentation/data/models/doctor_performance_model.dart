class DoctorPerformanceModel {
  final List<DoctorPerformanceAppointment> appointments;
  final AppointmentsCounts appointmentsCounts;
  final DoctorRating doctorRating;

  DoctorPerformanceModel({
    required this.appointments,
    required this.appointmentsCounts,
    required this.doctorRating,
  });

  factory DoctorPerformanceModel.fromJson(Map<String, dynamic> json) {
    return DoctorPerformanceModel(
      appointments: (json['appointments'] as List? ?? [])
          .map((e) => DoctorPerformanceAppointment.fromJson(e))
          .toList(),
      appointmentsCounts: AppointmentsCounts.fromJson(
        json['appoinmentsCounts'] ?? {},
      ),
      doctorRating: DoctorRating.fromJson(
        json['doctorRating'] ?? {},
      ),
    );
  }
}

class DoctorPerformanceAppointment {
  final String id;
  final String date;
  final String time;
  final String reason;
  final String status;
  final PerformanceOwner owner;
  final PerformancePet pet;

  DoctorPerformanceAppointment({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.owner,
    required this.pet,
  });

  factory DoctorPerformanceAppointment.fromJson(Map<String, dynamic> json) {
    return DoctorPerformanceAppointment(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      owner: PerformanceOwner.fromJson(json['owner'] ?? {}),
      pet: PerformancePet.fromJson(json['pet'] ?? {}),
    );
  }
}

class AppointmentsCounts {
  final int totalAppointments;
  final int completedAppointments;

  AppointmentsCounts({
    required this.totalAppointments,
    required this.completedAppointments,
  });

  factory AppointmentsCounts.fromJson(Map<String, dynamic> json) {
    return AppointmentsCounts(
      totalAppointments: json['totalAppoinments'] ?? 0,
      completedAppointments: json['completedAppoinments'] ?? 0,
    );
  }
}

class DoctorRating {
  final double rating;
  final int ratingCount;

  DoctorRating({
    required this.rating,
    required this.ratingCount,
  });

  factory DoctorRating.fromJson(Map<String, dynamic> json) {
    return DoctorRating(
      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
    );
  }
}

class PerformanceOwner {
  final String id;
  final String name;

  PerformanceOwner({
    required this.id,
    required this.name,
  });

  factory PerformanceOwner.fromJson(Map<String, dynamic> json) {
    return PerformanceOwner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class PerformancePet {
  final String id;
  final String name;
  final String type;
  final String gender;
  final String profilePic;

  PerformancePet({
    required this.id,
    required this.name,
    required this.type,
    required this.gender,
    required this.profilePic,
  });

  factory PerformancePet.fromJson(Map<String, dynamic> json) {
    return PerformancePet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }
}