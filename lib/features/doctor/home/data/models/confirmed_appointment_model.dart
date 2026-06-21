class ConfirmedAppointmentsResponse {
  final List<ConfirmedAppointmentModel> appointments;

  ConfirmedAppointmentsResponse({required this.appointments});

  factory ConfirmedAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmedAppointmentsResponse(
      appointments: (json['appointments'] as List? ?? [])
          .map(
            (e) =>
            ConfirmedAppointmentModel.fromJson(e as Map<String, dynamic>),
      )
          .toList(),
    );
  }
}

class ConfirmedAppointmentModel {
  final String id;
  final String date;
  final String time;
  final String reason;
  final AppointmentPetModel pet;
  final AppointmentOwnerModel owner;

  ConfirmedAppointmentModel({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.pet,
    required this.owner,
  });

  factory ConfirmedAppointmentModel.fromJson(Map<String, dynamic> json) {
    return ConfirmedAppointmentModel(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      pet: AppointmentPetModel.fromJson(json['pet'] ?? {}),
      owner: AppointmentOwnerModel.fromJson(json['owner'] ?? {}),
    );
  }
}

class AppointmentPetModel {
  final String id;
  final String name;
  final String type;
  final String? breed;
  final String? profilePic;

  final String? age;
  final String? weight;
  final String? gender;

  AppointmentPetModel({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.profilePic,
    this.age,
    this.weight,
    this.gender,
  });

  factory AppointmentPetModel.fromJson(Map<String, dynamic> json) {
    return AppointmentPetModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      breed: json['breed']?.toString(),
      profilePic: json['profilePic']?.toString(),

      // لو الباك بيرجعهم بأسماء دي هيتقرو، لو مش بيرجعهم هيفضلوا null
      age: json['age']?.toString(),
      weight: json['weight']?.toString(),
      gender: json['gender']?.toString(),
    );
  }
}

class AppointmentOwnerModel {
  final String name;
  final String? phone;

  AppointmentOwnerModel({
    required this.name,
    this.phone,
  });

  factory AppointmentOwnerModel.fromJson(Map<String, dynamic> json) {
    return AppointmentOwnerModel(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
    );
  }
}