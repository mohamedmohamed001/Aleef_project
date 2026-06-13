class AppointmentDetailsModel {
  final String id;
  final String date;
  final String time;
  final String reason;
  final String status;
  final String? notes;
  final int appoinmentFee;
  final AppointmentOwner owner;
  final AppointmentPet pet;

  AppointmentDetailsModel({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.notes,
    required this.appoinmentFee,
    required this.owner,
    required this.pet,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
      appoinmentFee: json['appoinmentFee'] ?? 0,
      owner: AppointmentOwner.fromJson(json['owner'] ?? {}),
      pet: AppointmentPet.fromJson(json['pet'] ?? {}),
    );
  }
}

class AppointmentOwner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePic;

  AppointmentOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
  });

  factory AppointmentOwner.fromJson(Map<String, dynamic> json) {
    return AppointmentOwner(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }
}

class AppointmentPet {
  final String id;
  final String name;
  final String type;
  final String gender;
  final num weight;
  final String birthDate;
  final String profilePic;
  final int age;

  AppointmentPet({
    required this.id,
    required this.name,
    required this.type,
    required this.gender,
    required this.weight,
    required this.birthDate,
    required this.profilePic,
    required this.age,
  });

  factory AppointmentPet.fromJson(Map<String, dynamic> json) {
    return AppointmentPet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      weight: json['weight'] ?? 0,
      birthDate: json['birthDate'] ?? '',
      profilePic: json['profilePic'] ?? '',
      age: json['age'] ?? 0,
    );
  }
}