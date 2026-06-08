class PreviousAppointmentModel {
  final String id;

  final String petId;
  final String petName;
  final String petProfilePic;

  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorProfilePic;

  final DateTime? date;
  final String time;
  final String reason;
  final String status;

  PreviousAppointmentModel({
    required this.id,
    required this.petId,
    required this.petName,
    required this.petProfilePic,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorProfilePic,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
  });

  factory PreviousAppointmentModel.fromJson(Map<String, dynamic> json) {
    final pet = json["pet"] as Map<String, dynamic>?;
    final doctor = json["doctor"] as Map<String, dynamic>?;

    return PreviousAppointmentModel(
      id: json["id"] ?? "",

      petId: pet?["id"] ?? "",
      petName: pet?["name"] ?? "",
      petProfilePic: pet?["profilePic"] ?? "",

      doctorId: doctor?["id"] ?? "",
      doctorName: doctor?["name"] ?? "",
      doctorSpecialization: doctor?["specialization"] ?? "",
      doctorProfilePic: doctor?["profilePic"] ?? "",

      date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
      time: json["time"] ?? "",
      reason: json["reason"] ?? "",
      status: json["status"] ?? "",
    );
  }
}