import '../../../pets/data/models/pet_model.dart';
import 'doctor_model.dart';

class AppointmentModel {
  final String? id;
  final PetModel? pet;
  final String? owner;
  final DoctorModel? doctor;
  final DateTime? date;
  final String? time;
  final String? reason;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? notes;


  AppointmentModel({
    this.id,
    this.pet,
    this.owner,
    this.doctor,
    this.date,
    this.time,
    this.reason,
    this.status,
    this.createdAt,
    this.updatedAt, this.notes,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      pet: json['pet'] != null ? PetModel.fromJson(json['pet']) : null,
      owner: json['owner'],
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'],
      reason: json['reason'],
      status: json['status'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      notes: json['notes'],
    );
  }
}