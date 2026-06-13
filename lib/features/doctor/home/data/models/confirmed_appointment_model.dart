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
  final AppointmentPetModel pet; // هنا ربطنا بالحيوان الخاص بالموعد
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
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      reason: json['reason'] ?? '',
      pet: AppointmentPetModel.fromJson(json['pet'] ?? {}),
      owner: AppointmentOwnerModel.fromJson(json['owner'] ?? {}),
    );
  }
}

class AppointmentPetModel {
  final String name;
  final String type;
  final String gender;
  final String profilePic;

  AppointmentPetModel({
    required this.name,
    required this.type,
    required this.gender,
    required this.profilePic,
  });

  factory AppointmentPetModel.fromJson(Map<String, dynamic> json) {
    return AppointmentPetModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }
}

class AppointmentOwnerModel {
  final String name;
  AppointmentOwnerModel({required this.name});
  factory AppointmentOwnerModel.fromJson(Map<String, dynamic> json) =>
      AppointmentOwnerModel(name: json['name'] ?? '');
}
