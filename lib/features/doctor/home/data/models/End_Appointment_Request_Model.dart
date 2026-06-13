import 'dart:io';

class EndAppointmentRequestModel {
  final MedicalRecordModel medicalRecord;
  final VaccinationModel? vaccination;
  final VaccinationModel? upComingVaccination;
  final List<File>? attachments;

  EndAppointmentRequestModel({
    required this.medicalRecord,
    this.vaccination,
    this.upComingVaccination,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      "medicalRecord": medicalRecord.toJson(),
      "vaccination": vaccination?.toJson(),
      "upComingVaccination": upComingVaccination?.toJson(),
    };
  }
}

class MedicalRecordModel {
  final String title;
  final String condition;
  final String description;

  MedicalRecordModel({required this.title, required this.condition, required this.description});

  Map<String, dynamic> toJson() => {
    "title": title,
    "condition": condition,
    "description": description,
  };
}

class VaccinationModel {
  final String name;
  final String date;

  VaccinationModel({required this.name, required this.date});

  Map<String, dynamic> toJson() => {
    "name": name,
    "date": date,
  };
}